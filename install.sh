#!/bin/bash
# Specter Host Engine — Automated Installer
# Bypasses rigorous Gatekeeper security for early-access Developer distributions.

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

TMP_DIR=$(mktemp -d)
DMG_PATH="$TMP_DIR/$DMG_NAME"

echo "⬇️ Downloading Specter..."
curl -L -o "$DMG_PATH" "$LATEST_RELEASE_URL" -#

echo "💿 Mounting Disk Image..."
# Robustly extract the mount path regardless of macOS terminal formatting
MOUNT_PATH=$(hdiutil attach "$DMG_PATH" -nobrowse | grep -o '/Volumes/.*' | head -n 1)

if [ -z "$MOUNT_PATH" ]; then
    echo "❌ Error: Failed to mount disk image."
    exit 1
fi

# Check if app is already running
if pgrep -x "$APP_NAME" > /dev/null; then
    echo "🛑 Stopping currently running Specter..."
    killall "$APP_NAME"
    sleep 1
fi

# Remove existing installation to prevent permission ghosting
if [ -d "$INSTALL_DIR/$APP_NAME.app" ]; then
    echo "🗑️ Removing previous version..."
    sudo rm -rf "$INSTALL_DIR/$APP_NAME.app"
fi

echo "📦 Installing to $INSTALL_DIR..."
sudo cp -R "$MOUNT_PATH/$APP_NAME.app" "$INSTALL_DIR/"

echo "🔓 Bypassing Apple Gatekeeper Quarantine..."
sudo xattr -rd com.apple.quarantine "$INSTALL_DIR/$APP_NAME.app" || true

echo "🧹 Cleaning up installers..."
hdiutil detach "$MOUNT_PATH" -quiet
rm -rf "$TMP_DIR"

echo "🚀 Launching Specter Engine..."
open "$INSTALL_DIR/$APP_NAME.app"

echo ""
echo "✅ Specter is now successfully installed and running!"

