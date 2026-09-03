# Dotfiles and scripts

Cross-platform dotfiles managed with [chezmoi](https://chezmoi.io), plus a set
of manual Debian/Ubuntu setup scripts. One repo targets Linux **and** Windows:
each file's OS is declared in `.chezmoiignore`, so `chezmoi apply` writes only
the files that belong on the current machine.

## Quick start

```sh
# Apply everything managed by chezmoi (dotfiles + AI-agent files):
chezmoi init --apply --source "$(pwd)/chezmoi"

# Or run the full bootstrap (chezmoi apply + Linux app scripts):
./install_all.sh
```

Windows (PowerShell): `chezmoi init --apply --source <repo>\chezmoi`

## How it works

- `chezmoi/` is the chezmoi **source directory**. Every file here maps to a
  path under `$HOME` (`~`). `dot_`-prefixed names become dotfiles
  (e.g. `dot_zshrc` → `~/.zshrc`); `dot_config/...` → `~/.config/...`.
- `.chezmoiignore` is a Go template: Linux-only files are ignored on Windows
  and vice-versa. Adding an OS-specific file = one line in the right block.
- Cross-platform software keeps **one** source of truth. The PowerShell profile
  lives once in `chezmoi/.chezmoitemplates/pwsh_profile.ps1`, and yazi's core
  config (`yazi.toml`, `keymap.toml`, `init.lua`, `package.toml`) in
  `chezmoi/.chezmoitemplates/yazi/`. Each is rendered to both OS paths via thin
  `.tmpl` wrappers: pwsh → `~/Documents/PowerShell/...` (Windows) and
  `~/.config/powershell/...` (Linux); yazi → `~/AppData/Roaming/yazi/config/...`
  (Windows) and `~/.config/yazi/...` (Linux). Edit the `.chezmoitemplates` file,
  not the per-OS wrappers. yazi plugins are restored from `package.toml` via
  `ya pkg install`, so they are not vendored here.
  neovim follows the same pattern: its `init.lua` lives in `chezmoi/.chezmoitemplates/nvim/` and renders to `~/AppData/Local/nvim/init.lua` (Windows, `%LOCALAPPDATA%`) and `~/.config/nvim/init.lua` (Linux) via per-OS `.tmpl` wrappers.
- AI-agent files (e.g. `~/.claude/CLAUDE.md`, `.cursorrules`) are a reserved
  slot: drop them into `chezmoi/` as normal dotfiles when you're ready. They
  need no structural change.

### OS ownership

| File | OS |
|------|----|
| `.zshrc`, `.vimrc`, `.config/i3`, `.config/i3status`, `.config/gtk-3.0` | Linux only |
| `.psmux.conf`, `AppData/Roaming/herdr/config.toml`, `Documents/PowerShell/...` | Windows only |
| `.chezmoitemplates/pwsh_profile.ps1`, `.chezmoitemplates/yazi/*`, `.chezmoitemplates/nvim/*` → both OS paths | Cross-platform (one source) |

## Directory structure

- `chezmoi/` — chezmoi source (dotfiles + AI-agent files, cross-platform).
- `scripts/` — manual Debian/Ubuntu install/setup scripts.
- `systemd/` — systemd service files (battery limit, Wake-on-LAN).
- `conf/` — extra config (e.g. libinput).
- `patch/` — patches for third-party software.
- `install_all.sh` — bootstrap: `chezmoi apply` + Linux `scripts/`.
- `install_conf.sh`, `install_systemd.sh` — manual Linux steps (sudo).

## Adding / editing files

```sh
# Capture an existing file into the source:
chezmoi add --source "$(pwd)/chezmoi" ~/.vimrc
# Edit a managed file (renders the template, opens your editor):
chezmoi edit --source "$(pwd)/chezmoi" ~/.vimrc
# Preview what would change:
chezmoi apply --dry-run --source "$(pwd)/chezmoi"
```

## Credits

Some install scripts are adapted from https://github.com/Soleedus/debian-i3gaps
