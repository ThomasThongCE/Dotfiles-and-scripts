kl# Scripts

This folder contains scripts to automate the installation and configuration of common tools and desktop environment components.  
**Note:** Run `sudo apt update` before executing these scripts.

## Script List

- `add_keyboard.sh` — Install Vietnamese (ibus-bamboo) and Japanese (mozc) keyboard input methods.
- `apps.sh` — Install commonly used CLI utilities (wget, curl, vim, ranger, etc.).
- `i3.sh` — Install i3 window manager and Font Awesome fonts.
- `vim.sh` — Install vim, vim-plug, and copy `.vimrc` configuration.
- `zsh.sh` — Install zsh, oh-my-zsh, and set zsh as the default shell.
- `rtc_time.sh` — Set Linux to use RTC time (for dual-boot with Windows).
- `alacritty-debian.sh` — Build and install Alacritty terminal from source.
- `theme-and-icon.sh` — Install Arc-Dark GTK theme and set dark mode.
- `gui-apps.sh` — Install Thunar, lxpolkit, libnotify-bin, lxappearance, qt5ct.
- `tailscale.sh` — Add Tailscale repository and install Tailscale VPN.
- `zoxide.sh` — Install zoxide for smarter directory jumping.
- `install-google-chrome.sh` — Install Google Chrome browser.
- `visual_code.sh` — Install Visual Studio Code editor.

## Usage

Run any script individually:
```sh
bash scripts/<scriptname>.sh
```
Or run all scripts in order:
```sh
./install_all.sh
```

## Notes

- Some scripts require user interaction or manual steps (e.g., ibus-setup for keyboard input).
- Dotfiles are managed via GNU Stow in the root install script.
- For more details on dotfiles, see the `dotfiles/` directory.
- Systemd service files for battery charge limit and Wake-on-LAN are available in the `systemd/` directory.

