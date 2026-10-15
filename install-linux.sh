#!/usr/bin/env bash
# The War of Wings - Linux Mint / Ubuntu installer (no sudo; installs for this user only)
# Usage: bash install-linux.sh
set -euo pipefail
APP_ID="the-war-of-wings"
APP_NAME="The War of Wings"
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/www"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
INSTALL_DIR="$DATA_HOME/$APP_ID"
BIN_DIR="$HOME/.local/bin"
DESKTOP_FILE="$DATA_HOME/applications/$APP_ID.desktop"
ICON_DIR="$DATA_HOME/icons/hicolor"
[ -f "$SRC_DIR/index.html" ] || { echo "www/index.html not found. Run this inside the unzipped folder." >&2; exit 1; }
echo "1/4 copy game -> $INSTALL_DIR"
rm -rf "$INSTALL_DIR"; mkdir -p "$INSTALL_DIR"; cp -r "$SRC_DIR/." "$INSTALL_DIR/"
echo "2/4 icons"
mkdir -p "$ICON_DIR/192x192/apps" "$ICON_DIR/512x512/apps"
cp "$SRC_DIR/icons/icon-192.png" "$ICON_DIR/192x192/apps/$APP_ID.png"
cp "$SRC_DIR/icons/icon-512.png" "$ICON_DIR/512x512/apps/$APP_ID.png"
echo "3/4 launcher -> $BIN_DIR/$APP_ID"
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/$APP_ID" <<LAUNCHER
#!/usr/bin/env bash
GAME="file://$INSTALL_DIR/index.html"
PROFILE="$DATA_HOME/$APP_ID-profile"
for b in chromium chromium-browser google-chrome google-chrome-stable brave-browser microsoft-edge; do
  if command -v "\$b" >/dev/null 2>&1; then
    exec "\$b" --app="\$GAME" --user-data-dir="\$PROFILE" --window-size=900,600 --class=$APP_ID "\$@"
  fi
done
if command -v firefox >/dev/null 2>&1; then exec firefox --new-window "\$GAME"; fi
exec xdg-open "\$GAME"
LAUNCHER
chmod +x "$BIN_DIR/$APP_ID"
echo "4/4 menu entry"
mkdir -p "$(dirname "$DESKTOP_FILE")"
cat > "$DESKTOP_FILE" <<DESKTOP
[Desktop Entry]
Type=Application
Version=1.0
Name=$APP_NAME
Comment=하준과 하나가 다섯 부족의 용들과 함께하는 판타지 RPG
Exec=$BIN_DIR/$APP_ID
Icon=$APP_ID
Terminal=false
Categories=Game;Education;
StartupWMClass=$APP_ID
DESKTOP
chmod +x "$DESKTOP_FILE"
command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$DATA_HOME/applications" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -q -t "$ICON_DIR" >/dev/null 2>&1 || true
DESKTOP_DIR="$(command -v xdg-user-dir >/dev/null 2>&1 && xdg-user-dir DESKTOP || echo "$HOME/Desktop")"
if [ -d "$DESKTOP_DIR" ]; then
  cp "$DESKTOP_FILE" "$DESKTOP_DIR/$APP_ID.desktop"; chmod +x "$DESKTOP_DIR/$APP_ID.desktop"
  command -v gio >/dev/null 2>&1 && gio set "$DESKTOP_DIR/$APP_ID.desktop" metadata::trusted true 2>/dev/null || true
fi
echo; echo "설치 완료! 메뉴 > 게임에서 실행하세요."
command -v chromium >/dev/null 2>&1 || command -v google-chrome >/dev/null 2>&1 || echo "앱 창으로 열려면:  sudo apt install chromium"
