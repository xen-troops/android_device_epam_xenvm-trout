#!/usr/bin/env python3

import importlib.util
from pathlib import Path
import tarfile
import unittest


SCRIPT = (Path(__file__).parents[1] /
          'yocto-layer/meta-google/recipes-trout/images/core-image-weston/'
          'google-overlay/usr/bin/gnss_replay.py')
DATA_ARCHIVE = (Path(__file__).parents[1] /
                'yocto-layer/meta-google/recipes-trout/gnss-replay/'
                'gnss-replay-data/gnss-replay-data.tar.gz')
DATASET_MEMBER = 'google-overlay/usr/share/gnss/test.csv'
SPEC = importlib.util.spec_from_file_location('gnss_replay', SCRIPT)
GNSS_REPLAY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GNSS_REPLAY)


class Clock(object):
    START_MONOTONIC_SECONDS = 10.0
    START_WALL_NANOSECONDS = 1700000000000000000

    def __init__(self):
        self.monotonic_seconds = self.START_MONOTONIC_SECONDS
        self.wall_nanoseconds = self.START_WALL_NANOSECONDS

    @property
    def monotonic_nanoseconds(self):
        return int(self.monotonic_seconds * 1000000000)

    @property
    def wall_milliseconds(self):
        return self.wall_nanoseconds // 1000000

    def monotonic(self):
        return self.monotonic_seconds

    def wall_time_ns(self):
        return self.wall_nanoseconds

    def advance(self, seconds):
        self.monotonic_seconds += seconds
        self.wall_nanoseconds += int(seconds * 1000000000)


class FakeSocket(object):
    def __init__(self, chunks):
        self.chunks = iter(chunks)
        self.responses = []

    def recv(self, size):
        return next(self.chunks)

    def sendall(self, response):
        self.responses.append(response)


# Fix fields: Provider, LatitudeDegrees, LongitudeDegrees, AltitudeMeters,
# SpeedMps, AccuracyMeters, BearingDegrees, UnixTimeMillis, SpeedAccuracyMps,
# BearingAccuracyDegrees, elapsedRealtimeNanos, VerticalAccuracyMeters.
def fix(provider, timestamp_ms, latitude, longitude, speed_mps, bearing,
        bearing_accuracy=2.0):
    return (f'Fix,{provider},{latitude},{longitude},100,{speed_mps},3,'
            f'{bearing},{timestamp_ms},0.5,{bearing_accuracy},123,4\n')


# Raw fields follow the Android GnssLogger header. Important fields here are
# utcTimeMillis, TimeNanos, FullBiasNanos, BiasNanos, Svid, State,
# ReceivedSvTimeNanos, Cn0DbHz, PseudorangeRateMetersPerSecond,
# CarrierFrequencyHz, ConstellationType, and ChipsetElapsedRealtimeNanos.
# Rows with the same utcTimeMillis form one receiver epoch.
def raw(timestamp_ms, received_time_nanos, constellation=1, svid=1):
    values = [''] * 37
    values[0] = 'Raw'
    values[1] = str(timestamp_ms)
    values[2] = '1000000000000'
    values[3] = '18'
    values[5] = '-1000000000000000000'
    values[6] = '0'
    values[10] = '1'
    values[11] = str(svid)
    values[12] = '0'
    values[13] = '1'
    values[14] = str(received_time_nanos)
    values[15] = '1'
    values[16] = '35'
    values[17] = '-1'
    values[18] = '0.1'
    values[19] = '1'
    values[20] = '0'
    values[21] = '0.1'
    values[22] = '1575420000'
    values[28] = str(constellation)
    values[29] = '-1'
    values[30] = '35'
    values[36] = '123'
    return ','.join(values) + '\n'


class RawMeasurementReplayTest(unittest.TestCase):
    HEADER = '# Raw,' + ','.join(['field'] * 36) + '\n'

    def make_replay(self, raw_lines):
        self.clock = Clock()
        timeline = GNSS_REPLAY.FixReplay(
            [fix('GPS', 1000, 10, 20, 2, 0),
             fix('GPS', 2000, 12, 24, 4, 90)],
            monotonic=self.clock.monotonic,
            wall_time_ns=self.clock.wall_time_ns)
        return GNSS_REPLAY.RawMeasurementReplay(
            [self.HEADER, *raw_lines], timeline)

    def test_replay_returns_all_measurements_from_current_epoch(self):
        replay = self.make_replay([
            raw(1000, 100, svid=1),
            raw(1000, 200, svid=2),
            raw(2000, 300, svid=3),
        ])

        first = replay.current().splitlines()
        self.assertEqual(self.HEADER.rstrip(), first[0])
        self.assertEqual(['1', '2'], [row.split(',')[11] for row in first[1:]])

        self.clock.advance(1.0)
        second = replay.current().splitlines()
        self.assertEqual(['3'], [row.split(',')[11] for row in second[1:]])

    def test_runtime_clocks_preserve_raw_pseudorange_phase(self):
        source_line = raw(1000, 123456789)
        source = source_line.rstrip().split(',')
        replay = self.make_replay([source_line])

        result = replay.current().splitlines()[1].split(',')
        period = GNSS_REPLAY.RawMeasurementReplay.GPS_WEEK_NANOS

        def phase(values):
            receiver_time = (int(values[2]) - int(values[5]) -
                             int(float(values[6])))
            return (receiver_time - int(values[14])) % period

        self.assertEqual(phase(source), phase(result))
        self.assertEqual(str(self.clock.wall_milliseconds), result[1])
        self.assertEqual(str(self.clock.monotonic_nanoseconds), result[36])

    def test_empty_replay_returns_empty_response(self):
        replay = self.make_replay([])

        self.assertEqual('', replay.current())


class FixReplayTest(unittest.TestCase):
    def make_replay(self, lines, **kwargs):
        self.clock = Clock()
        return GNSS_REPLAY.FixReplay(
            lines,
            monotonic=self.clock.monotonic,
            wall_time_ns=self.clock.wall_time_ns,
            **kwargs)

    def test_replay_uses_time_and_ignores_non_gps_fixes(self):
        replay = self.make_replay([
            fix('FLP', 1000, 50, 60, 99, 90),
            fix('GPS', 1000, 10, 20, 2, 350),
            fix('GPS', 2000, 12, 24, 4, 10),
        ])

        self.clock.advance(0.5)
        values = replay.current().split(',')

        self.assertEqual('GPS', values[1])
        self.assertAlmostEqual(11.0, float(values[2]))
        self.assertAlmostEqual(22.0, float(values[3]))
        self.assertAlmostEqual(3.0, float(values[5]))
        self.assertAlmostEqual(0.0, float(values[7]))

    def test_replay_advances_while_no_request_is_made(self):
        replay = self.make_replay([
            fix('GPS', 1000, 10, 20, 2, 0),
            fix('GPS', 2000, 12, 24, 4, 90),
        ])

        self.clock.advance(1.0)
        values = replay.current().split(',')

        self.assertAlmostEqual(12.0, float(values[2]))
        self.assertAlmostEqual(4.0, float(values[5]))

    def test_max_speed_stretches_time_and_scales_speed(self):
        replay = self.make_replay([
            fix('GPS', 1000, 46, 10, 0, 0),
            fix('GPS', 2000, 46.000001, 10.000001, 10, 90),
        ], max_speed_mps=5.0)

        self.clock.advance(1.0)
        values = replay.current().split(',')

        self.assertAlmostEqual(46.0000005, float(values[2]))
        self.assertAlmostEqual(2.5, float(values[5]))
        self.assertAlmostEqual(0.5, replay.playback_rate)

    def test_loop_interpolates_from_last_fix_to_first_fix(self):
        replay = self.make_replay([
            fix('GPS', 1000, 10, 20, 2, 90),
            fix('GPS', 2000, 12, 24, 4, 90),
        ])

        self.clock.advance(1.5)
        values = replay.current().split(',')

        self.assertAlmostEqual(11.0, float(values[2]))
        self.assertAlmostEqual(22.0, float(values[3]))

    def test_runtime_fields_use_current_clocks_and_accuracy_floor(self):
        replay = self.make_replay([
            fix('GPS', 1000, 10, 20, 2, 0, bearing_accuracy=0),
            fix('GPS', 2000, 12, 24, 4, 90, bearing_accuracy=0),
        ], minimum_bearing_accuracy_degrees=1.0)

        values = replay.current().split(',')

        self.assertEqual(str(self.clock.wall_milliseconds), values[8])
        self.assertEqual(str(self.clock.monotonic_nanoseconds), values[11])
        self.assertEqual('1', values[10])

    def test_runtime_limits_reject_non_finite_values(self):
        lines = [
            fix('GPS', 1000, 10, 20, 2, 350),
            fix('GPS', 2000, 12, 24, 4, 10),
        ]
        invalid_options = [
            {'playback_rate': float('nan')},
            {'playback_rate': float('inf')},
            {'max_speed_mps': float('nan')},
            {'max_speed_mps': float('inf')},
            {'minimum_bearing_accuracy_degrees': float('nan')},
            {'minimum_bearing_accuracy_degrees': float('inf')},
        ]

        for options in invalid_options:
            with self.subTest(options=options):
                with self.assertRaisesRegex(ValueError, 'finite'):
                    self.make_replay(lines, **options)

    def test_packaged_dataset_produces_location_and_raw_responses(self):
        with tarfile.open(DATA_ARCHIVE, 'r:gz') as archive:
            source = archive.extractfile(DATASET_MEMBER)
            self.assertIsNotNone(source)
            lines = [line.decode('utf-8') for line in source.readlines()]

        replay = self.make_replay(
            lines,
            max_speed_mps=4.5,
            minimum_bearing_accuracy_degrees=1.0)
        raw_replay = GNSS_REPLAY.RawMeasurementReplay(lines, replay)

        location = replay.current().split(',')
        self.assertEqual('GPS', location[1])
        self.assertLessEqual(float(location[5]), 4.5)
        self.assertGreater(float(location[9]), 0.0)
        self.assertGreaterEqual(float(location[10]), 1.0)

        packet = raw_replay.current().splitlines()
        self.assertTrue(packet[0].startswith('# Raw,'))
        self.assertGreater(len(packet), 1)
        raw = packet[1].split(',')
        self.assertEqual('Raw', raw[0])
        self.assertEqual(str(self.clock.wall_milliseconds), raw[1])
        self.assertEqual(str(self.clock.monotonic_nanoseconds), raw[36])


class CommandLoopTest(unittest.TestCase):
    def test_stream_commands_may_be_fragmented_or_coalesced(self):
        sk = FakeSocket([
            b'CMD_GET_',
            b'LOCATION\nCMD_GET_RAW',
            b'MEASUREMENT\n',
            b'',
        ])
        loop = GNSS_REPLAY.CommandLoop(sk)
        loop.command(b'CMD_GET_LOCATION', lambda: 'fix')
        loop.command(b'CMD_GET_RAWMEASUREMENT', lambda: 'raw')

        loop.loop()

        self.assertEqual([
            b'fix\n\n\n\n',
            b'raw\n\n\n\n',
        ], sk.responses)

    def test_unknown_command_returns_empty_framed_response(self):
        sk = FakeSocket([b'UNKNOWN\n', b''])
        loop = GNSS_REPLAY.CommandLoop(sk)

        loop.loop()

        self.assertEqual([b'\n\n\n\n'], sk.responses)


if __name__ == '__main__':
    unittest.main()
