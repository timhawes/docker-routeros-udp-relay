#!/bin/sh

if [ -n "$1" ]; then
  exec /udp-broadcast-relay-rs $@
fi

ID="${ID:-1}"
RELAY="${RELAY:-1900:239.255.255.250}"
RUST_LOG=${RUST_LOG:-info}
export RUST_LOG

command="/udp-broadcast-relay-rs --id $ID"

for device in $(grep ':' /proc/net/dev | cut -d: -f1 | tr -d ' '); do
  [ "$device" = "lo" ] && continue
  command="$command --dev $device"
done

for relay in $RELAY; do
  command="$command --relay $relay"
done

echo $command
exec $command
