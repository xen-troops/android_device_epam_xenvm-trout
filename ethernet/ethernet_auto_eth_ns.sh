#!/system/bin/sh
# Copyright (C) 2024 The Android Open Source Project
# Copyright (C) 2026 EPAM Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# =============================================================================
# Automotive namespace (auto_eth) network setup script
#
# This script runs inside the "auto_eth" network namespace and performs:
#   1. Waits for the veth_auto interface to appear (moved here by the
#      system namespace script)
#   2. Configures the namespace-side veth endpoint and default routing
#   3. Sets up iptables NAT and forwarding rules to route ADB traffic
#      (port 5555) from the automotive network into the system namespace
#
# This is the companion to the system namespace setup script.
#
# Traffic flow for ADB connection via automotive network:
#
#   ADB client (192.168.2.x)
#       │
#       │  TCP dst port 5555
#       ▼
#   eth1 (192.168.2.4) ──DNAT──▶ veth_auto (10.99.0.2) ──▶ veth_sys (10.99.0.1:5555)
#                                     SNAT src→10.99.0.2        │
#                                                            ADB daemon
#
# =============================================================================

# --- Wait for veth_auto interface ---
# The system namespace script creates the veth pair and moves veth_auto
# into this namespace. Since both scripts may start concurrently, we poll
# for up to 10 seconds until veth_auto becomes visible here.
for i in $(seq 1 10); do
    ip link show veth_auto 2>/dev/null && break
    sleep 1
done

# --- Configure veth_auto (namespace side of the veth pair) ---

# Assign the namespace-side IP on the /30 link subnet.
# The peer (veth_sys in the default namespace) has 10.99.0.1/30.
ip addr add 10.99.0.2/30 dev veth_auto

# Bring up the veth endpoint
ip link set veth_auto up

# Set the default route via the automotive network gateway (eth1).
# This allows general outbound traffic from this namespace to reach
# the vehicle/automotive network.
ip route add default via 192.168.2.1 dev eth1

# Enable IP forwarding so this namespace can route packets between
# eth1 (automotive network) and veth_auto (link to system namespace)
sysctl -w net.ipv4.ip_forward=1

# --- iptables: NAT and forwarding rules for ADB routing ---
#
# Goal: Allow an ADB client on the automotive network (192.168.2.x) to
# connect to ADB daemon running in the system namespace (10.99.0.1:5555)
# by connecting to eth1's IP (192.168.2.4:5555).

# DNAT (Destination NAT): Rewrite incoming ADB connections on eth1:5555
# to forward them to the system namespace via the veth link.
# Packets arriving at eth1 on port 5555 get their destination changed
# from 192.168.2.4:5555 → 10.99.0.1:5555
iptables -t nat -A PREROUTING \
    -i eth1 -p tcp --dport 5555 -j DNAT --to-destination 10.99.0.1:5555

# SNAT (Source NAT): Rewrite the source address of forwarded packets
# leaving via veth_auto so that return traffic comes back through this
# namespace (instead of the system namespace trying to reply directly
# to the automotive network, which it cannot reach).
# Source: original client IP → 10.99.0.2
iptables -t nat -A POSTROUTING \
    -o veth_auto -j SNAT --to-source 10.99.0.2

# FORWARD rule: Explicitly allow new ADB TCP connections (port 5555)
# to be forwarded from eth1 to veth_auto
iptables -A FORWARD \
    -i eth1 -o veth_auto -p tcp --dport 5555 -j ACCEPT

# FORWARD rule: Allow return traffic (ESTABLISHED/RELATED connections)
# from veth_auto back to eth1, so ADB responses reach the client.
# This is a stateful rule — it only permits packets belonging to
# connections that were already accepted by the rule above.
iptables -A FORWARD \
    -i veth_auto -o eth1 -m state --state ESTABLISHED,RELATED -j ACCEPT