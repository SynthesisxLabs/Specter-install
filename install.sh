#!/bin/bash

# 🔮 SPECTER INSTALLER - Genesis v1.0
# High-fidelity deployment for SynthesisxLabs.

set -e

# --- Configuration ---
ORG="SynthesisxLabs"
REPO="Specter-install"
APP_NAME="Specter"
BUNDLE_ID="app.specter.desktop"

# --- Colors ---
RED='\033[0;31m'
CRIMSON='\033[38;2;196;30;58m'
NC='\033[0m'
BOLD='\033[1m'

# --- Header ---
clear
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

echo -e "System Status: ${BOLD}macOS $OS_VER ($ARCH)${NC}"

if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: Specter is currently macOS exclusive.${NC}"
    exit 1
fi

# --- Fetch Latest Release ---
echo -e "Connecting to Specter Registry..."
API_URL="https://api.github.com/repos/$ORG/$REPO/releases/latest"
RELEASE_JSON=$(curl -s $API_URL)

if [[ $(echo "$RELEASE_JSON" | grep '"message": "Not Found"') ]]; then
    echo -e "${RED}CRITICAL: No releases found at $ORG/$REPO.${NC}"
    exit 1
fi

# Robust Parsing using Python3 (Standard on macOS)
VERSION=$(echo "$RELEASE_JSON" | python3 -c "import sys, json; print(json.load(sys.stdin)['tag_name'])")
DMG_URL=$(echo "$RELEASE_JSON" | python3 -c "import sys, json; data=json.load(sys.stdin); print([a['browser_download_url'] for a in data['assets'] if a['name'].endswith('.dmg')][0])")
RELEASE_NOTES=$(echo "$RELEASE_JSON" | python3 -c "import sys, json; print(json.load(sys.stdin).get('body', ''))")

echo -e "Found Release Identifier: ${CRIMSON}${BOLD}$VERSION${NC}"

# --- Display Release Notes ---
if [ ! -z "$RELEASE_NOTES" ] && [ "$RELEASE_NOTES" != '""' ] && [ "$RELEASE_NOTES" != "null" ]; then
    echo -e "${BOLD}Release Notes:${NC}"
    echo -e "$RELEASE_NOTES"
    echo -e "----------------------------------------------------\n"
fi

# --- Download ---
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
DMG_PATH="$TMP_DIR/Specter.dmg"

echo -e "Downloading Specter Package..."
curl -L -# -o "$DMG_PATH" "$DMG_URL"

# --- Mount ---
echo -e "Virtualizing Installation Surface..."
mount_info=$(hdiutil mount -nobrowse -plist "$DMG_PATH")
mount_point=$(echo "$mount_info" | python3 -c "import sys, plistlib; obj = plistlib.loads(sys.stdin.buffer.read()); print([e['mount-point'] for e in obj['system-entities'] if 'mount-point' in e][0])")

# --- Install ---
echo -e "Deploying Specter.app..."
if [ -d "/Applications/$APP_NAME.app" ]; then
    echo -e "Updating existing installation..."
    rm -rf "/Applications/$APP_NAME.app"
fi
cp -R "$mount_point/$APP_NAME.app" /Applications/

# --- Quarantine Bypass ---
echo -e "Applying Security Clearances..."
xattr -rd com.apple.quarantine "/Applications/$APP_NAME.app" 2>/dev/null || true

# --- Cleanup ---
echo -e "Cleaning environment..."
if [ -n "$mount_point" ]; then
    hdiutil unmount -force "$mount_point" >/dev/null 2>&1
fi

# --- Success ---
echo -e "\n----------------------------------------------------"
echo -e "${CRIMSON}${BOLD}SUCCESS: SPECTER IS NOW OPERATIONAL${NC}"
echo -e "Location:  /Applications/$APP_NAME.app"
echo -e "Telemetry: https://SynthesisxLabs.xyz"
echo -e "----------------------------------------------------\n"

# --- Auto-Launch (Ironclad Pipe Fix) ---
# We wrap this in a block to ensure the entire clause is parsed before execution
{
    printf "Execute Specter Core now? (y/n) "
    if read -r REPLY < /dev/tty && [[ "$REPLY" =~ ^[Yy]$ ]]; then
        printf "Booting Specter...\n"
        open "/Applications/Specter.app"
    else
        printf "Deployment complete. Specter is ready.\n"
    fi
}

# End of script
