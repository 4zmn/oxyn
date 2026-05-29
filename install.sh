#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${NVIM_APPNAME:-oxyn}"
INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

OXYN_RUNTIME_DIR="${OXYN_RUNTIME_DIR:-"$XDG_DATA_HOME/oxyn"}"
OXYN_CONFIG_DIR="${OXYN_CONFIG_DIR:-"$XDG_CONFIG_HOME/oxyn"}"
OXYN_CACHE_DIR="${OXYN_CACHE_DIR:-"$XDG_CACHE_HOME/oxyn"}"
OXYN_BASE_DIR="${OXYN_BASE_DIR:-"$OXYN_RUNTIME_DIR/oxyn"}"

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v nvim >/dev/null 2>&1; then
  echo "OXYN requires Neovim to be installed and available as 'nvim'." >&2
  exit 1
fi

if ! nvim --headless --clean +'if !has("nvim-0.10") | cquit | endif' +qa >/dev/null 2>&1; then
  echo "OXYN requires Neovim 0.10 or newer." >&2
  exit 1
fi

mkdir -p "$OXYN_RUNTIME_DIR" "$OXYN_CONFIG_DIR" "$OXYN_CACHE_DIR" "$INSTALL_PREFIX/bin"

if [ "$REPO_DIR" != "$OXYN_BASE_DIR" ]; then
  rm -rf "$OXYN_BASE_DIR"
  mkdir -p "$OXYN_BASE_DIR"
  cp -a "$REPO_DIR"/. "$OXYN_BASE_DIR"/
fi

if [ ! -f "$OXYN_CONFIG_DIR/config.lua" ]; then
  : > "$OXYN_CONFIG_DIR/config.lua"
fi

src="$OXYN_BASE_DIR/utils/bin/oxyn.template"
dst="$INSTALL_PREFIX/bin/$APP_NAME"
sed -e s"#NVIM_APPNAME_VAR#\"${APP_NAME}\"#"g \
  -e s"#RUNTIME_DIR_VAR#\"${OXYN_RUNTIME_DIR}\"#"g \
  -e s"#CONFIG_DIR_VAR#\"${OXYN_CONFIG_DIR}\"#"g \
  -e s"#CACHE_DIR_VAR#\"${OXYN_CACHE_DIR}\"#"g \
  -e s"#BASE_DIR_VAR#\"${OXYN_BASE_DIR}\"#"g "$src" > "$dst"
chmod u+x "$dst"

mkdir -p "$INSTALL_PREFIX/share/applications" "$INSTALL_PREFIX/share/icons"
cp "$OXYN_BASE_DIR/assets/oxyn.png" "$INSTALL_PREFIX/share/icons/oxyn.png"
cat > "$INSTALL_PREFIX/share/applications/oxyn.desktop" << EOF
[Desktop Entry]
Type=Application
Name=OXYN
Comment=OXYN IDE - Neovim distribution
Exec=${dst} %F
Icon=oxyn
Terminal=true
Categories=Development;TextEditor;Utility;
StartupWMClass=nvim-${APP_NAME}
MimeType=text/plain;
EOF

if [ "${SKIP_OXYN_SYNC:-0}" != "1" ]; then
  "$dst" --headless '+Lazy! sync' +qa
fi

echo "OXYN installed. Start it with: $dst"
