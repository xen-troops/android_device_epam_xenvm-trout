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
# System namespace network setup script
#
# This script isolates the automotive Ethernet interface (eth1) into a
# dedicated network namespace ("auto_eth") and creates a veth pair to
# bridge connectivity between the default (system) namespace and the
# automotive namespace. This separation ensures that Android Automotive
# network traffic (e.g., vehicle bus, telematics) does not interfere
# with system-level networking (e.g., ADB, internet access via eth0).
#
# Network topology after execution:
#
#   Default namespace                auto_eth namespace
#   ┌──────────────────┐            ┌──────────────────────┐
#   │  eth0 (system)   │            │  eth1   192.168.2.4  │
#   │                  │            │    (automotive net)   │
#   │  veth_sys        │────────────│  veth_auto           │
#   │  10.99.0.1/30    │  veth pair │  10.99.0.2/30        │
#   └──────────────────┘            └──────────────────────┘
#
# =============================================================================

# --- Automotive namespace creation and eth1 migration ---

# Create a new network namespace called "auto_eth" to isolate automotive traffic
ip netns add auto_eth

# Move the physical Ethernet interface eth1 from the default namespace
# into the "auto_eth" namespace. After this, eth1 is no longer visible
# in the default namespace.
ip link set eth1 netns auto_eth

# Assign a static IP address to eth1 inside the automotive namespace.
# This address is used for communication on the automotive/vehicle network.
ip netns exec auto_eth ip addr add 192.168.2.4/24 dev eth1

# Bring eth1 up inside the automotive namespace
ip netns exec auto_eth ifconfig eth1 up

# --- veth pair: connectivity bridge between namespaces ---
# A virtual Ethernet (veth) pair acts as a point-to-point tunnel between
# the default namespace and auto_eth. This allows the system namespace
# (where ADB runs) to reach the automotive namespace and vice versa.

# Create the veth pair: veth_sys stays in the default namespace,
# veth_auto will be moved into auto_eth
ip link add veth_sys type veth peer name veth_auto

# Assign the system-side endpoint an IP on a small /30 link-local subnet
ip addr add 10.99.0.1/30 dev veth_sys

# Bring up the system-side endpoint
ip link set veth_sys up

# Move the other end of the veth pair into the automotive namespace.
# Note: IP configuration of veth_auto (10.99.0.2/30) and bringing it up
# is handled by the companion script running inside the auto_eth namespace.
ip link set veth_auto netns auto_eth

# --- Policy routing in the default (system) namespace ---
# Policy routing ensures that traffic originating from the veth_sys address
# (10.99.0.1) is routed through the veth link rather than the default route
# (which typically goes via eth0 to the internet/host).

# Add a routing policy rule: packets with source IP 10.99.0.1 use table 100
ip rule add from 10.99.0.1 lookup 100

# In table 100, set the default route to go through veth_sys
# (i.e., towards the automotive namespace)
ip route add default dev veth_sys table 100

# Also add an explicit route for the /30 link subnet in table 100
ip route add 10.99.0.0/30 dev veth_sys table 100

# --- Enable IP forwarding ---
# Required so the kernel forwards packets between interfaces/namespaces,
# e.g., allowing ADB traffic from eth0 to be routed through to auto_eth
sysctl -w net.ipv4.ip_forward=1

# --- Signal readiness ---
# Set an Android system property to notify other services (e.g., the
# auto_eth namespace setup script) that the system namespace side is
# configured and ready
setprop vendor.sys_ns.ready 1
