#!/usr/bin/env bash
# backup.sh - pack a folder into a dated .tar.gz and delete backups older than 7 days
# Usage: backup.sh <folder-to-back-up> [where-to-save-backups]

set -euo pipefail

keep_days=7

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: backup.sh <folder-to-back-up> [where-to-save-backups]" >&2
    exit 1
fi

if [[ ! -d "$1" ]]; then
    echo "✖ Can't back up '$1': that's not a folder" >&2
    exit 1
fi

source_dir=$(realpath "$1")
backup_dir="${2:-$HOME/backups}"
name=$(basename "$source_dir")
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
archive="$backup_dir/${name}_${timestamp}.tar.gz"

mkdir -p "$backup_dir"

tar -czf "$archive" -C "$(dirname "$source_dir")" "$name"
size=$(du -h "$archive" | cut -f1)
echo "✔ Backup ready: $archive ($size)"

find "$backup_dir" -type f -name "${name}_*.tar.gz" -mtime +"$keep_days" -printf "🧹 Cleaned up: %p\n" -delete
