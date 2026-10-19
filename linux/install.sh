#!/usr/bin/env bash
# Installs WriteNow for the current user (no root needed).
# It adds WriteNow to your applications menu, opens in its own window without
# an address bar, and appears under "Open With" for PDF files.
set -eu

SRC="$(cd "$(dirname "$0")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
DEST="$DATA/writenow"
APPS="$DATA/applications"
ICONS="$DATA/icons/hicolor/512x512/apps"

# Needs a Chromium-based browser for the app window.
find_browser() {
  for b in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge microsoft-edge-stable brave-browser vivaldi; do
    if command -v "$b" >/dev/null 2>&1; then command -v "$b"; return 0; fi
  done
  return 1
}
if ! find_browser >/dev/null; then
  echo "No Chromium-based browser found (Chrome, Chromium, Edge, Brave or Vivaldi)."
  echo "Install one, for example:  sudo apt install chromium   (Debian/Ubuntu)"
  echo "                           sudo dnf install chromium   (Fedora)"
  exit 1
fi

mkdir -p "$DEST" "$APPS" "$ICONS"
cp "$SRC/index.html" "$DEST/index.html"
cp "$SRC/writenow.png" "$ICONS/writenow.png"

# The launcher: opens the app window, optionally with a PDF given as argument.
cat > "$DEST/writenow" <<'LAUNCHER'
#!/usr/bin/env bash
DEST="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

find_browser() {
  for b in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge microsoft-edge-stable brave-browser vivaldi; do
    if command -v "$b" >/dev/null 2>&1; then command -v "$b"; return 0; fi
  done
  return 1
}

# Percent-encode every byte that is not a safe URL character.
urlencode() {
  local LC_ALL=C s="$1" out="" c i
  for ((i = 0; i < ${#s}; i++)); do
    c="${s:i:1}"
    case "$c" in
      [a-zA-Z0-9._~/-]) out+="$c" ;;
      *) out+="$(printf '%%%02X' "'$c")" ;;
    esac
  done
  printf '%s' "$out"
}

URL="file://$DEST/index.html?app=1"
if [ "$#" -ge 1 ] && [ -f "$1" ]; then
  FILE="$(readlink -f "$1")"
  URL="$URL&pdf=$(urlencode "$FILE")"
fi

BROWSER="$(find_browser)" || { echo "WriteNow needs Chrome, Chromium, Edge, Brave or Vivaldi." >&2; exit 1; }
exec "$BROWSER" \
  --user-data-dir="$DEST/profile" \
  --no-first-run --no-default-browser-check --disable-sync \
  --allow-file-access-from-files --window-size=1200,860 \
  --class=WriteNow --name=WriteNow \
  --app="$URL"
LAUNCHER
chmod +x "$DEST/writenow"

# Applications menu entry; also offered for PDF files ("Open With").
cat > "$APPS/writenow.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Version=1.0
Name=WriteNow
GenericName=Word Processor
Comment=A quiet word processor in the style of the classic Macintosh
Exec="$DEST/writenow" %f
Icon=writenow
Terminal=false
Categories=Office;WordProcessor;
MimeType=application/pdf;
StartupWMClass=WriteNow
DESKTOP
chmod +x "$APPS/writenow.desktop"

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APPS" >/dev/null 2>&1 || true
command -v gtk-update-icon-cache  >/dev/null 2>&1 && gtk-update-icon-cache -q -t "$DATA/icons/hicolor" >/dev/null 2>&1 || true

echo "WriteNow is installed in $DEST"
echo "Find it in your applications menu (search for \"WriteNow\")."
echo "To open a PDF: right-click it > Open With > WriteNow."
