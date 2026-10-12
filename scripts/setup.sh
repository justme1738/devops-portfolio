#!/usr/bin/env bash
# setup.sh - prepare a fresh Linux machine: install Git and Docker, then clone (or update) a repo
# Usage: setup.sh [repo-url] [target-folder]
# Safe to run again: anything already done is skipped.

set -euo pipefail

repo_url="${1:-https://github.com/justme1738/devops-portfolio.git}"
target_dir="${2:-$HOME/devops-portfolio}"
user=$(whoami)

compose_version="v5.6.0"

install_if_missing() {
    local command_name="$1"
    local package="$2"

    if command -v "$command_name" > /dev/null 2>&1; then
        echo "✔ $command_name is already installed - skipping"
    else
        echo "➜ Installing $package..."
        sudo apt-get update -qq
        sudo apt-get install -y "$package"
        echo "✔ $package installed"
    fi
}

install_if_missing git git
install_if_missing docker docker.io
install_if_missing curl curl

if id -nG "$user" | grep -qw docker; then
    echo "✔ $user is already in the docker group - skipping"
else
    sudo usermod -aG docker "$user"
    echo "✔ Added $user to the docker group (log out and back in for it to take effect)"
fi

install_compose() {
    if docker compose version > /dev/null 2>&1; then
        echo "✔ docker compose is already installed - skipping"
        return
    fi

    local arch
    arch=$(uname -m)
    if [[ "$arch" == "armv7l" ]]; then
        arch="armv7"
    fi

    local file="docker-compose-linux-$arch"
    local url="https://github.com/docker/compose/releases/download/$compose_version/$file"
    local tmp_dir
    tmp_dir=$(mktemp -d)

    echo "➜ Installing docker compose $compose_version for $arch..."
    curl -fsSL "$url" -o "$tmp_dir/$file"
    curl -fsSL "$url.sha256" -o "$tmp_dir/$file.sha256"
    (cd "$tmp_dir" && sha256sum -c "$file.sha256")

    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    sudo install -m 755 "$tmp_dir/$file" /usr/local/lib/docker/cli-plugins/docker-compose
    rm -rf "$tmp_dir"
    echo "✔ docker compose installed"
}

install_compose

if [[ -d "$target_dir/.git" ]]; then
    echo "➜ $target_dir already exists - pulling the latest changes"
    git -C "$target_dir" pull --ff-only
else
    echo "➜ Cloning $repo_url into $target_dir"
    git clone "$repo_url" "$target_dir"
fi

echo "✔ Setup complete"
