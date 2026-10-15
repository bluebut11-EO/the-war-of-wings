#!/usr/bin/env bash
# The War of Wings uninstall (also removes saved progress in the app window)
set -euo pipefail
APP_ID="the-war-of-wings"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DESKTOP_DIR="$(command -v xdg-user-dir >/dev/null 2>&1 && xdg-user-dir DESKTOP || echo "$HOME/Desktop")"
rm -rf "$DATA_HOME/$APP_ID" "$DATA_HOME/$APP_ID-profile"
rm -f "$HOME/.local/bin/$APP_ID" "$DATA_HOME/applications/$APP_ID.desktop" "$DESKTOP_DIR/$APP_ID.desktop"
rm -f "$DATA_HOME/icons/hicolor/192x192/apps/$APP_ID.png" "$DATA_HOME/icons/hicolor/512x512/apps/$APP_ID.png"
echo "removed $APP_ID"
