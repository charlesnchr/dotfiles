#!/usr/bin/env bash
set -euo pipefail

nohup sleep 10 >/dev/null 2>&1 &
pid=$!

echo "Started background process PID ${pid} for 10 seconds"
