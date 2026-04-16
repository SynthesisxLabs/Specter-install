<div align="center">
  <h1>🔮 Specter Host Engine</h1>
  <p><strong>The official automated installer for Specter 0.1 on macOS.</strong></p>
  
  <p>
    <img src="https://img.shields.io/badge/Platform-macOS%2012%2B-black?style=flat-square&logo=apple" alt="macOS" />
    <img src="https://img.shields.io/badge/Architecture-Apple%20Silicon%20%7C%20Intel-blue?style=flat-square" alt="Arch" />
    <img src="https://img.shields.io/badge/Security-Gatekeeper%20Bypass-red?style=flat-square" alt="Security" />
  </p>
</div>

## 📥 One-Line Installation
To instantly install the latest version of the Specter Host Engine onto your Mac, copy and paste this command into your terminal:

```bash
curl -sSL https://raw.githubusercontent.com/SynthesisxLabs/Specter-install/main/install.sh | bash
```

### What does this script do?
Unlike standard internet downloads, this script automates the tedious parts of macOS app installation to guarantee a seamless, zero-friction developer experience:

- 🛰️ Connects to the main [Specter GitHub Repository](https://github.com/SynthesisxLabs/Specter).
- ⬇️ Scans and downloads the absolute newest `Specter.dmg` release build.
- 💿 Silently mounts the disk image in the background.
- 📦 Copies the `.app` bundle directly into your `/Applications` directory.
- 🔓 **Automatically strips Apple Quarantine tags** (`com.apple.quarantine`), preventing macOS Gatekeeper from showing the scary "App is Malicious" warnings normally triggered by unsigned beta software.
- 🧹 Safely cleans up all temporary installer files.

### ⚠️ Prerequisite Note
During the installation process, the terminal will ask for your root **password**. This is required to silently copy the app to the protected `/Applications` directory and bypass the Gatekeeper quarantines. 

## 🛠 Manual Installation
If you prefer not to use the automated `curl` string, you can always visit the main repository's [Releases Page](https://github.com/SynthesisxLabs/Specter/releases) and download the DMG manually.

---

<div align="center">
  <sub>Built by <a href="https://github.com/SynthesisxLabs">SynthesisxLabs</a>. Part of the Specter Intelligence Ecosystem.</sub>
</div>
