#!/usr/bin/env bash
# Bootstrap this machine:
#   1. Apply chezmoi-managed files (dotfiles + future AI-agent files), cross-platform.
#   2. Run the manual Debian/Ubuntu app setup scripts (Linux only).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1) chezmoi-managed files.
chezmoi apply --source "$SCRIPT_DIR/chezmoi"

# 2) Manual app setup (Linux/Debian only; scripts/ stay outside chezmoi).
if [[ "$(uname)" == Linux* ]]; then
  sudo apt update
  for f in "$SCRIPT_DIR"/scripts/*.sh; do
    bash "$f" -H || break
  done
fi
