#!/bin/bash

# 🔮 SPECTER INSTALLER v1.0
# Next-Generation Mac Intelligence Bridge
# https://github.com/SynthesisxLabs/Specter

set -e

# Visuals
RED='\033[0;31m'
VOID='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${RED}"
cat << "EOF"
    _____ ____  __________________________ 
   / ___// __ \/ ____/ ____/_  __/ ____/ __ \
   \__ \/ /_/ / __/ / /     / / / __/ / /_/ /
  ___/ / ____/ /___/ /___  / / / /___/ _, _/ 
 /____/_/   /_____/\____/ /_/ /_____/_/ |_|  
                                             
EOF
echo -e "${VOID}Next-Generation Mac Intelligence Bridge${NC}\n"

# 1. Detect Architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    RELEASE_SUF="aarch64.dmg"
    echo -e "⚡ Detected ${RED}Apple Silicon${NC} Architecture"
else
    RELEASE_SUF="x64.dmg"
    echo -e "⚡ Detected ${RED}Intel${NC} Architecture"
fi

# 2. Fetch Latest Release via GitHub API
echo -e "🛰️ Connecting to Specter Registry..."
LATEST_JSON=$(curl -s https://api.github.com/repos/SynthesisxLabs/Specter/releases/latest)
LATEST_VERSION=$(echo "$LATEST_JSON" | grep -oE '"tag_name": "[^"]+"' | head -n 1 | cut -d'"' -f4)

if [ -z "$LATEST_VERSION" ]; then
    echo -e "❌ ${RED}Error:${NC} Could not find latest release. Please check https://github.com/SynthesisxLabs/Specter/releases"
    exit 1
fi

echo -e "🎁 Found Release: ${RED}${LATEST_VERSION}${NC}"

# 3. Find target asset
DOWNLOAD_URL=$(echo "$LATEST_JSON" | grep -oE "https://github.com/SynthesisxLabs/Specter/releases/download/[^\"]+$RELEASE_SUF" | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo -e "❌ ${RED}Error:${NC} Could not find the DMG for your architecture. It might still be building."
    exit 1
fi

# 4. Download and Install
TEMP_DMG="/tmp/Specter.dmg"
echo -e "📥 Downloading Specter..."
curl -L -o "$TEMP_DMG" "$DOWNLOAD_URL"

echo -e "💿 Mounting Disk Image..."
MOUNT_POINT=$(hdiutil mount "$TEMP_DMG" | tail -n 1 | awk '{print $3}')

echo -e "🚀 Installing to Applications..."
cp -R "$MOUNT_POINT/Specter.app" /Applications/

echo -e "🧹 Cleaning up..."
hdiutil unmount "$MOUNT_POINT"
rm "$TEMP_DMG"

echo -e "\n✅ ${RED}SPECTER INSTALLED SUCCESSFULLY${NC}"
echo -e "Open your ${RED}Applications${NC} folder to launch the terminal.\n"
