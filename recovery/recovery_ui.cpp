/*
 * Copyright 2026, EPAM Systems
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/unique_fd.h>
#include <net/if.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>

#include <recovery_ui/device.h>
#include <recovery_ui/stub_ui.h>

namespace {

// Interface used for fastbootd over TCP (DomD forwards tcp/5554 to it).
constexpr char kFastbootIface[] = "eth1";

// No graphics in recovery -> stub UI; ignore 120s menu timeout
class VmRecoveryUI : public StubRecoveryUI {
 public:
  size_t ShowMenu(const std::vector<std::string>& headers,
                  const std::vector<std::string>& items,
                  size_t initial_selection, bool menu_only,
                  const std::function<int(int, bool)>& key_handler) override {
    for (;;) {
      size_t ret = StubRecoveryUI::ShowMenu(headers, items, initial_selection,
                                            menu_only, key_handler);
      if (ret != static_cast<size_t>(KeyError::TIMED_OUT)) {
        return ret;
      }
      LOG(INFO) << "VmRecoveryUI: menu timeout ignored";
    }
  }
};

class VmDevice : public Device {
 public:
  explicit VmDevice(RecoveryUI* ui)
      : Device(ui), ctl_sock_(socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0)) {
    if (ctl_sock_ < 0) PLOG(ERROR) << "VmDevice: socket";
  }

 private:
  static bool SetIfUp(int sock, const char* ifname) {
    if (sock < 0) {
      LOG(ERROR) << "VmDevice: no control socket";
      return false;
    }
    struct ifreq ifr = {};
    strlcpy(ifr.ifr_name, ifname, IFNAMSIZ);
    if (ioctl(sock, SIOCGIFFLAGS, &ifr) < 0) {
      PLOG(ERROR) << "VmDevice: SIOCGIFFLAGS " << ifname;
      return false;
    }
    ifr.ifr_flags |= IFF_UP;
    if (ioctl(sock, SIOCSIFFLAGS, &ifr) < 0) {
      PLOG(ERROR) << "VmDevice: SIOCSIFFLAGS " << ifname;
      return false;
    }
    return true;
  }

  void PreFastboot() override {
    android::base::SetProperty("fastbootd.protocol", "tcp");
    bool up = SetIfUp(ctl_sock_.get(), kFastbootIface);
    LOG(INFO) << "VmDevice: fastbootd over TCP, " << kFastbootIface
              << " up=" << up;
  }

  android::base::unique_fd ctl_sock_;
};

}  // namespace

Device* make_device() {
  LOG(INFO) << "VmRecoveryUI: make_device()";
  return new VmDevice(new VmRecoveryUI);
}
