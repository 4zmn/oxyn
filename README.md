# 4SHVIM

4SHVIM is maintained by 4zmn.

It requires Neovim to be installed on the system. Neovim is not bundled.

## Install

```sh
git clone <your-4SHVIM-repo-url> 4SHVIM
cd 4SHVIM
./install.sh
```

The installer creates an isolated user-local app. It does not install system-wide.

- Launcher: `~/.local/bin/fvim`
- Runtime: `~/.local/share/4shvim/4shvim`
- Config: `~/.config/4shvim/config.lua`
- Cache: `~/.cache/4shvim`

## Run

```sh
fvim
```

## Uninstall

```sh
~/.local/share/4shvim/4shvim/uninstall.sh
```

Remove user config too:

```sh
~/.local/share/4shvim/4shvim/uninstall.sh --remove-config
```
