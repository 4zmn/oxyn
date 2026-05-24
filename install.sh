#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${NVIM_APPNAME:-fvim}"
INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

FOURSHVIM_RUNTIME_DIR="${FOURSHVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/4shvim"}"
FOURSHVIM_CONFIG_DIR="${FOURSHVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/4shvim"}"
FOURSHVIM_CACHE_DIR="${FOURSHVIM_CACHE_DIR:-"$XDG_CACHE_HOME/4shvim"}"
FOURSHVIM_BASE_DIR="${FOURSHVIM_BASE_DIR:-"$FOURSHVIM_RUNTIME_DIR/4shvim"}"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v nvim >/dev/null 2>&1; then
  echo "4SHVIM requires Neovim to be installed and available as 'nvim'." >&2
  exit 1
fi

if ! nvim --headless --clean +'if !has("nvim-0.10") | cquit | endif' +qa >/dev/null 2>&1; then
  echo "4SHVIM requires Neovim 0.10 or newer." >&2
  exit 1
fi

mkdir -p "$FOURSHVIM_RUNTIME_DIR" "$FOURSHVIM_CONFIG_DIR" "$FOURSHVIM_CACHE_DIR" "$INSTALL_PREFIX/bin"

if [ "$REPO_DIR" != "$FOURSHVIM_BASE_DIR" ]; then
  rm -rf "$FOURSHVIM_BASE_DIR"
  mkdir -p "$FOURSHVIM_BASE_DIR"
  cp -a "$REPO_DIR"/. "$FOURSHVIM_BASE_DIR"/
fi

if [ ! -f "$FOURSHVIM_CONFIG_DIR/config.lua" ]; then
  : > "$FOURSHVIM_CONFIG_DIR/config.lua"
fi

src="$FOURSHVIM_BASE_DIR/utils/bin/fvim.template"
dst="$INSTALL_PREFIX/bin/$APP_NAME"
sed -e s"#NVIM_APPNAME_VAR#\"${APP_NAME}\"#"g \
  -e s"#RUNTIME_DIR_VAR#\"${FOURSHVIM_RUNTIME_DIR}\"#"g \
  -e s"#CONFIG_DIR_VAR#\"${FOURSHVIM_CONFIG_DIR}\"#"g \
  -e s"#CACHE_DIR_VAR#\"${FOURSHVIM_CACHE_DIR}\"#"g \
  -e s"#BASE_DIR_VAR#\"${FOURSHVIM_BASE_DIR}\"#"g "$src" > "$dst"
chmod u+x "$dst"

mkdir -p "$INSTALL_PREFIX/share/applications" "$INSTALL_PREFIX/share/icons"
cp "$FOURSHVIM_BASE_DIR/assets/4shvim.png" "$INSTALL_PREFIX/share/icons/4shvim.png"
cat > "$INSTALL_PREFIX/share/applications/4shvim.desktop" << EOF
[Desktop Entry]
Type=Application
Name=4SHVIM
Comment=4SHVIM IDE - Neovim distribution
Exec=${dst} %F
Icon=4shvim
Terminal=true
Categories=Development;TextEditor;Utility;
StartupWMClass=nvim-${APP_NAME}
MimeType=text/plain;
EOF

if [ "${SKIP_4SHVIM_SYNC:-0}" != "1" ]; then
  "$dst" --headless '+Lazy! sync' +qa
fi

echo "4SHVIM installed. Start it with: $dst"
