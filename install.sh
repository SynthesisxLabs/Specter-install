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
ARCH=$(uname -m)
OS_VER=$(sw_vers -productVersion)
MAJOR_VER=$(echo $OS_VER | cut -d. -f1)

echo -e "⚡ System: ${BOLD}macOS $OS_VER ($ARCH)${NC}"

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: Specter is currently macOS exclusive.${NC}"
    exit 1
fi

if [ "$MAJOR_VER" -lt 14 ]; then
    echo -e "${RED}Warning: Specter is optimized for macOS 14+. Performance may vary on $OS_VER.${NC}"
fi

# --- Fetch Latest Release ---
echo -e "🛰️  Connecting to Specter Registry..."
API_URL="https://api.github.com/repos/$ORG/$REPO/releases/latest"
RELEASE_INFO=$(curl -s $API_URL)

VERSION=$(echo "$RELEASE_INFO" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
DMG_URL=$(echo "$RELEASE_INFO" | grep "browser_download_url" | grep ".dmg" | head -n 1 | cut -d '"' -f 4)
RELEASE_NOTES=$(echo "$RELEASE_INFO" | grep '"body":' | sed -E 's/.*"body": "([^"]+)".*/\1/' | sed 's/\\r\\n/\n/g' | sed 's/\\n/\n/g')

if [ -z "$DMG_URL" ]; then
    echo -e "${RED}Error: Could not find a stable DMG release for $VERSION.${NC}"
    exit 1
fi

echo -e "💎 Found Release: ${CRIMSON}${BOLD}$VERSION${NC}"
echo -e "\n${BOLD}Release Notes:${NC}"
echo -e "${RELEASE_NOTES:-No changelog provided for this version.}"
echo -e "----------------------------------------------------\n"

# --- Download ---
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
DMG_PATH="$TMP_DIR/Specter.dmg"

echo -e "📥 Downloading Specter Package..."
curl -L -o "$DMG_PATH" "$DMG_URL"

# --- Mount ---
echo -e "💿 Virtualizing Genesis Core..."
mount_point=$(hdiutil mount -nobrowse "$DMG_PATH" | tail -n 1 | awk -F'\t' '{print $NF}' | xargs)

# --- Install ---
echo -e "🚀 Deploying to /Applications..."
if [ -d "/Applications/$APP_NAME.app" ]; then
    echo -e "🔄 Updating existing installation..."
    rm -rf "/Applications/$APP_NAME.app"
fi
cp -R "$mount_point/$APP_NAME.app" /Applications/

# --- Quarantine Bypass ---
echo -e "🛡️  Sanitizing Gatekeeper clearance..."
xattr -rd com.apple.quarantine "/Applications/$APP_NAME.app" 2>/dev/null || true

# --- Cleanup ---
echo -e "🧹 Sanitizing environment..."
if [ -n "$mount_point" ]; then
    hdiutil unmount -force "$mount_point" >/dev/null 2>&1
fi

# --- Success ---
echo -e "\n----------------------------------------------------"
echo -e "${CRIMSON}${BOLD}SUCCESS: SPECTER IS NOW OPERATIONAL${NC}"
echo -e "Location: ${BOLD}/Applications/$APP_NAME.app${NC}"
echo -e "Telemetry: ${BOLD}https://synthesisx.app${NC}"
echo -e "----------------------------------------------------\n"

# --- Auto-Launch ---
read -p "Execute Specter Core now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "/Applications/$APP_NAME.app"
fi
