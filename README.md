<div align="center">
  <h1>🔮 Specter Host Engine</h1>
  <p><strong>The official automated installer for Specter 1.0 on macOS.</strong></p>
  
  <p>
    <img src="https://img.shields.io/badge/Platform-macOS%2012%2B-black?style=flat-square&logo=apple" alt="macOS" />
    <img src="https://img.shields.io/badge/Architecture-Apple%20Silicon%20%7C%20Intel-blue?style=flat-square" alt="Arch" />
    <img src="https://img.shields.io/badge/Security-Gatekeeper%20Bypass-red?style=flat-square" alt="Security" />
    <img src="https://img.shields.io/badge/Engine-Tauri%20%2B%20Rust-orange?style=flat-square" alt="Engine" />
  </p>
</div>

## 🌌 The Specter Architecture
Specter is a **next-generation Desktop Automation & Telemetry engine**. It transforms your iPhone into a military-grade, zero-latency dashboard capable of interacting with your Mac on a foundational level infrastructure.

Built dynamically using React Native and a Rust backend, it enables spatial automation without requiring you to be locked at your desk.

### Core Capabilities
- **Real-Time Telemetry Data:** Native Mac hooks measure live CPU usage, RAM capacity, and Battery life, streaming to your iOS over secure WebSockets.
- **Hardware Integration:** Mutate core macOS APIs directly from your phone (System Volume, Native Mute toggling, App Launching).
- **Project Scout:** Direct deep linking into your code editors (VS Code / Cursor). Remotely open directories and control active AI systems.
- **Physics-Based UI:** The iPhone client utilizes Awwwards-style iOS Glassmorphism and `react-native-reanimated` physics springs for breathtaking visuals.

---

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
- 🧹 Safely cleans up all temporary installer files and automatically launches the engine!

### ⚠️ Prerequisite Note
During the installation process, the terminal will ask for your root **password**. This is required to silently copy the app to the protected `/Applications` directory and bypass the Gatekeeper quarantines. 

## 🛠 Manual Installation
If you prefer not to use the automated `curl` string, you can always visit the main repository's [Releases Page](https://github.com/SynthesisxLabs/Specter/releases) and download the DMG manually.

---

<div align="center">
  <sub>Built by <a href="https://github.com/SynthesisxLabs">SynthesisxLabs</a>. Part of the Specter Intelligence Ecosystem.</sub>
</div>
