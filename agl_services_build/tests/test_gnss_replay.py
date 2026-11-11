#!/usr/bin/env python3

import importlib.util
from pathlib import Path
import unittest


SCRIPT = (Path(__file__).parents[1] /
          'yocto-layer/meta-google/recipes-trout/images/core-image-weston/'
          'google-overlay/usr/bin/gnss_replay.py')
SPEC = importlib.util.spec_from_file_location('gnss_replay', SCRIPT)
GNSS_REPLAY = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GNSS_REPLAY)


class FakeSocket(object):
    def __init__(self, chunks):
        self.chunks = iter(chunks)
        self.responses = []

    def recv(self, size):
        return next(self.chunks)

    def sendall(self, response):
        self.responses.append(response)


class CommandLoopTest(unittest.TestCase):
    def test_complete_response_is_sent_before_clean_shutdown(self):
        sk = FakeSocket([b'CMD_GET_LOCATION', b''])
        loop = GNSS_REPLAY.CommandLoop(sk)
        loop.command(b'CMD_GET_LOCATION', lambda: 'fix')

        loop.loop()

        self.assertEqual([b'fix\n\n\n\n'], sk.responses)

    def test_unknown_command_returns_empty_framed_response(self):
        sk = FakeSocket([b'UNKNOWN', b''])
        loop = GNSS_REPLAY.CommandLoop(sk)

        loop.loop()

        self.assertEqual([b'\n\n\n\n'], sk.responses)


if __name__ == '__main__':
    unittest.main()
