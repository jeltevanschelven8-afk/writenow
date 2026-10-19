#!/bin/bash
# Builds "WriteNow.app" from index.html, main.swift and logo.png.
set -e
cd "$(dirname "$0")"

APP="WriteNow.app"
EXE="WriteNow"

if ! command -v swiftc >/dev/null 2>&1; then
  echo "Apple's Command Line Tools are not installed yet."
  echo "A window will appear to install them. Run this script again afterwards."
  xcode-select --install || true
  exit 1
fi

echo "Building the app..."
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

swiftc -O main.swift -o "$APP/Contents/MacOS/$EXE" -framework Cocoa -framework WebKit
cp index.html "$APP/Contents/Resources/index.html"

# Make the app icon from the logo (sips and iconutil come with macOS).
TMP="$(mktemp -d)"
if sips -s format png logo.png --out "$TMP/icon.png" >/dev/null 2>&1; then
  ICONSET="$TMP/AppIcon.iconset"
  mkdir -p "$ICONSET"
  for s in 16 32 128 256 512; do
    sips -z $s $s "$TMP/icon.png" --out "$ICONSET/icon_${s}x${s}.png" >/dev/null
    d=$((s * 2))
    sips -z $d $d "$TMP/icon.png" --out "$ICONSET/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"
else
  echo "Note: the logo could not be converted; the app will get the default icon."
fi
rm -rf "$TMP"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>WriteNow</string>
  <key>CFBundleDisplayName</key><string>WriteNow</string>
  <key>CFBundleIdentifier</key><string>com.jeltevanschelven.writenow</string>
  <key>CFBundleExecutable</key><string>$EXE</string>
  <key>CFBundleIconFile</key><string>AppIcon</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.00</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>NSHumanReadableCopyright</key><string>©2026 Jelte van Schelven</string>
  <key>LSMinimumSystemVersion</key><string>11.0</string>
  <key>NSHighResolutionCapable</key><true/>
  <key>CFBundleDocumentTypes</key>
  <array>
    <dict>
      <key>CFBundleTypeName</key><string>PDF document</string>
      <key>CFBundleTypeRole</key><string>Viewer</string>
      <key>LSHandlerRank</key><string>Alternate</string>
      <key>LSItemContentTypes</key><array><string>com.adobe.pdf</string></array>
    </dict>
  </array>
</dict>
</plist>
PLIST

codesign --force --deep -s - "$APP" >/dev/null 2>&1 || true

echo
echo "Done! \"$APP\" is in this folder."
echo "Drag it to your Applications folder and open it with a double-click."
open -R "$APP" || true
