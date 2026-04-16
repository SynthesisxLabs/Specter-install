#!/bin/bash
# Specter One-Line Installer
# Downloads, mounts, and silently installs Specter exactly where it needs to go.

set -e

REPO="SynthesisxLabs/Specter"
APP_NAME="Specter"
DMG_NAME="Specter.dmg"
INSTALL_DIR="/Applications"

echo "🔮 Initializing Specter Advanced Installer..."

# 1. Fetch latest release from GitHub API
echo "📡 Scanning for latest stable release..."
LATEST_RELEASE_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep "browser_download_url.*$DMG_NAME" | cut -d '"' -f 4)

if [ -z "$LATEST_RELEASE_URL" ]; then
    echo "❌ Error: Could not find latest release for $DMG_NAME."
    echo "Please check the repository or download manually."
    exit 1
fi

echo "⬇️ Downloading Specter..."
curl -L -o "/tmp/$DMG_NAME" "$LATEST_RELEASE_URL"

echo "💿 Mounting Disk Image..."
MOUNT_PATH=$(hdiutil attach "/tmp/$DMG_NAME" -nobrowse | grep "Volumes" | awk -F'\t' '{print $3}')

# Check if app is already running
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "🛑 Stopping currently running Specter..."
    killall "$APP_NAME"
fi

echo "📦 Installing to $INSTALL_DIR..."
sudo cp -R "$MOUNT_PATH/$APP_NAME.app" "$INSTALL_DIR/"

echo "🔓 Bypassing Apple Gatekeeper Quarantine (Developer Mode)..."
sudo xattr -d com.apple.quarantine "$INSTALL_DIR/$APP_NAME.app" || true

echo "🧹 Cleaning up installers..."
hdiutil detach "$MOUNT_PATH" -quiet
rm "/tmp/$DMG_NAME"

echo ""
echo "✅ Specter successfully installed to $INSTALL_DIR/$APP_NAME.app!"
echo "🚀 You can now launch Specter from Spotlight!"
