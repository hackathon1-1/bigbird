#!/bin/bash

# Variables — fill these in as needed or pass via CLI
LOCAL_IP="$GRETAP_LOCAL"    # Example default local IP
REMOTE_IP="$GRETAP_REMOTE"  # Example default remote IP
HW_NIC="$GRETAP_INTERFACE"  # Hardware NIC (for bridging)

# Names for interfaces
GRETAP_IF="gretap1"
BRIDGE_IF="br1"

# Clean up any previous setup
ip link set $GRETAP_IF down 2>/dev/null
ip link del $GRETAP_IF 2>/dev/null
ip link set $BRIDGE_IF down 2>/dev/null
ip link del $BRIDGE_IF 2>/dev/null

# Create gretap tunnel
ip link add $GRETAP_IF type gretap local $LOCAL_IP remote $REMOTE_IP

# Create bridge
ip link add name $BRIDGE_IF type bridge

# Add interfaces to bridge
ip link set dev $GRETAP_IF master $BRIDGE_IF
ip link set dev $HW_NIC master $BRIDGE_IF

# Bring everything up
ip link set dev $GRETAP_IF up
ip link set dev $HW_NIC up
ip link set dev $BRIDGE_IF up

# Optionally, assign IPv6 link-local (optional – usually auto-generated)
# ip -6 addr add fe80::90aa:eaff:fef0:bbec/64 dev $GRETAP_IF
# ip -6 addr add fe80::7cc5:adff:fe8b:9a4/64 dev $BRIDGE_IF

echo "GRETAP and bridge setup complete:"
echo "  GRETAP interface: $GRETAP_IF"
echo "  Local IP: $LOCAL_IP"
echo "  Remote IP: $REMOTE_IP"
echo "  Bridged to hardware NIC: $HW_NIC"