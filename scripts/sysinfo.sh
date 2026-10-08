#!/usr/bin/env bash
# sysinfo.sh - print a quick health summary of this machine
set -euo pipefail

echo "Host:   $(hostname)"
echo "Uptime: $(uptime -p)"
echo "Disk:"
df -h /
free -h
