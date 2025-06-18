# Dotfiles and scripts

This repository contains dotfiles and scripts to automate the setup of a Debian-based Linux environment (tested on Ubuntu 20+ and Debian Bookworm). It includes configuration for i3, vim, zsh, GTK themes, and various utility scripts for installing and configuring essential applications.

## Usage

- To install all scripts and dotfiles, run:
  ```sh
  ./install_all.sh
  ```
  This will execute all `.sh` scripts in the `scripts/` directory in order.

- To install dotfiles only (with backup of existing files), run:
  ```sh
  ./install_dotfiles.sh
  ```

- To install the configuration file in the conf folder, run:
  ```sh
  ./install_conf.sh
  ```

- To install all the systemd services in the systemd folder, run:
  ```sh
  ./install_systemd
  ```

- For details about each script, see [scripts/README.md](scripts/README.md).

## Directory Structure

- `dotfiles/` — Contains configuration files for zsh, vim, i3, gtk, etc.
- `scripts/` — Installation and setup scripts for various tools and environments.
- `conf/` — Extra configuration files (e.g., libinput for touchpad).
- `patch/` — Patches for third-party software.
- `.config/` — Example configs for GTK, i3, i3status.
- `systemd/` — Systemd service files for battery charge limit and Wake-on-LAN.

## Credits

Some install scripts are adapted from the following sources:  
- Inspired by: https://github.com/Soleedus/debian-i3gaps
