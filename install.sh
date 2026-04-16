#!/bin/bash

# 🔮 SPECTER INSTALLER
# Redefining the boundary between hardware and interface.

set -e

# --- Configuration ---
ORG="SynthesisxLabs"
REPO="Specter"
APP_NAME="Specter"
BUNDLE_ID="app.specter.desktop"

# --- Colors ---
RED='\033[0;31m'
CRIMSON='\033[38;2;196;30;58m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# --- Header ---
echo -e "${CRIMSON}${BOLD}"
echo "    _____ ____  __________________________ "
echo "   / ___// __ \\/ ____/ ____/_  __/ ____/ __ \\"
echo "   \\__ \\/ /_/ / __/ / /     / / / __/ / /_/ /"
echo "  ___/ / ____/ /___/ /___  / / / /___/ _, _/ "
echo " /____/_/   /_____/\\____/ /_/ /_____/_/ |_|  "
echo -e "${NC}"
echo -e "${BOLD}Initializing Specter v1.0 (Genesis) Deployment...${NC}"
echo "----------------------------------------------------"

# --- Environment Check ---
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: Specter is currently macOS exclusive.${NC}"
    exit 1
fi

# --- Fetch Latest Release ---
echo -e "🛰️  Fetching latest telemetry from GitHub..."
API_URL="https://api.github.com/repos/$ORG/$REPO/releases/latest"
RELEASE_INFO=$(curl -s $API_URL)

VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DMG_URL=$(echo "$RELEASE_INFO" | grep "browser_download_url" | grep ".dmg" | head -n 1 | cut -d '"' -f 4)

if [ -z "$DMG_URL" ]; then
    echo -e "${RED}Error: Could not find a stable DMG release for $VERSION.${NC}"
    exit 1
fi

echo -e "💎 Found Specter $VERSION"

# --- Download ---
TMP_DIR=$(mktemp -d)
DMG_PATH="$TMP_DIR/Specter.dmg"

echo -e "📥 Downloading Specter..."
curl -L -o "$DMG_PATH" "$DMG_URL"

# --- Mount ---
echo -e "📦 Mounting Genesis Core..."
mount_point=$(hdiutil mount "$DMG_PATH" | tail -n 1 | awk '{print $3}')

# --- Install ---
echo -e "🚀 Deploying to /Applications..."
# Remove existing version if present
if [ -d "/Applications/$APP_NAME.app" ]; then
    rm -rf "/Applications/$APP_NAME.app"
fi
cp -R "$mount_point/$APP_NAME.app" /Applications/

# --- Quarantine Bypass ---
echo -e "🛡️  Bypassing Gatekeeper quarantine..."
xattr -rd com.apple.quarantine "/Applications/$APP_NAME.app" || true

# --- Cleanup ---
echo -e "🧹 Sanitizing environment..."
# Check if mounted before unmounting
if [ -n "$mount_point" ]; then
    hdiutil unmount "$mount_point"
fi
rm -rf "$TMP_DIR"

# --- Success ---
echo "----------------------------------------------------"
echo -e "${CRIMSON}${BOLD}SUCCESS: Specter is now operational.${NC}"
echo -e "Find it in your ${BOLD}/Applications${NC} folder."
echo -e "Visit ${BOLD}https://synthesisx.app${NC} for telemetry syncing."
echo "----------------------------------------------------"

# --- Auto-Launch ---
read -p "Do you want to launch Specter now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "/Applications/$APP_NAME.app"
fi
