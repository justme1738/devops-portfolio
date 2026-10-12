# devops-portfolio
## Skills
- Linux and Bash
- Networking: routing and switching (CCNP level)
- Docker and docker-compose: build and run containers daily
- Git and GitHub pull-request workflow
## Certifications
- LPI
- Cisco CCNA
- Cisco CCNP Enterprise (ENCOR)
## Scripts

| Script | What it does |
| --- | --- |
| `scripts/setup.sh` | Prepares a fresh Linux machine: installs Git, curl, Docker and Docker Compose (checksum-verified), adds the user to the docker group, then clones or updates this repo. Idempotent: safe to run again. |
| `scripts/backup.sh` | Packs a folder into a dated `.tar.gz`, reports its size and deletes backups older than 7 days. Runs nightly via cron. |
| `scripts/sysinfo.sh` | Prints a quick health summary: host, uptime, disk and memory. |

### Usage

    ./scripts/setup.sh [repo-url] [target-folder]
    ./scripts/backup.sh <folder-to-back-up> [where-to-save-backups]
    ./scripts/sysinfo.sh

Example cron entry (nightly backup at 02:00):

    0 2 * * * /path/to/scripts/backup.sh /path/to/folder >> ~/backups/backup.log 2>&1

All scripts use `set -euo pipefail` and pass ShellCheck with zero warnings.
