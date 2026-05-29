#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${NVIM_APPNAME:-ox}"
INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"

OXYN_RUNTIME_DIR="${OXYN_RUNTIME_DIR:-"$XDG_DATA_HOME/oxyn"}"
OXYN_CONFIG_DIR="${OXYN_CONFIG_DIR:-"$XDG_CONFIG_HOME/oxyn"}"
OXYN_CACHE_DIR="${OXYN_CACHE_DIR:-"$XDG_CACHE_HOME/oxyn"}"

REMOVE_CONFIG=0
if [ "${1:-}" = "--remove-config" ]; then
  REMOVE_CONFIG=1
fi

rm -f "$INSTALL_PREFIX/bin/$APP_NAME"
rm -f "$INSTALL_PREFIX/share/applications/oxyn.desktop"
rm -f "$INSTALL_PREFIX/share/icons/oxyn.png"
rm -rf "$OXYN_RUNTIME_DIR" "$OXYN_CACHE_DIR"

if [ "$REMOVE_CONFIG" -eq 1 ]; then
  rm -rf "$OXYN_CONFIG_DIR"
fi

echo "OXYN uninstalled. User config kept unless --remove-config was provided."
