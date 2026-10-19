#!/usr/bin/env bash
# Removes WriteNow from this computer.
set -eu
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
rm -rf "$DATA/writenow"
rm -f "$DATA/applications/writenow.desktop" "$DATA/icons/hicolor/512x512/apps/writenow.png"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$DATA/applications" >/dev/null 2>&1 || true
echo "WriteNow has been removed."
