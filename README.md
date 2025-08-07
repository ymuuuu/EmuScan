# EmuScan 📱

A powerful PowerShell script for managing Android Virtual Devices (AVDs) with an intuitive interface and comprehensive device information display.

## 🚀 Features

- **📋 Comprehensive AVD Information**: View device model, Android version, API level, architecture, root status, and last usage date
- **🎯 Smart Boot Options**: Choose between normal boot (fast) or cold boot (clean state)
- **⚡ System-wide Installation**: Install once, run from anywhere
- **🎨 Color-coded Interface**: Easy-to-read output with emoji indicators
- **🔧 Easy Management**: Install/uninstall with simple commands

## 📸 Screenshots

```
📱 Available Android Virtual Devices (AVDs):

1. Nexus_6_2 | Device: Nexus 6 | API: 33 | Android: 13.0 | Arch: x86_64 | Root: Yes | Type: Google Play | Last Used: 2025-07-31
2. Nexus_6_3 | Device: Nexus 6 | API: 34 | Android: 14.0 | Arch: x86_64 | Root: Yes | Type: AOSP | Last Used: 2025-08-07

Enter the number of the AVD to launch (1-2): 
```

## 🛠️ Prerequisites

- **Windows** with PowerShell 5.1 or later
- **Android SDK** installed with emulator
- **Android Virtual Devices** (AVDs) created in Android Studio

## 📦 Installation

### Option 1: Quick Setup (Recommended)
1. Download `EmuScan.ps1`
2. Run the script:
   ```powershell
   .\EmuScan.ps1
   ```
3. Choose "Install system-wide" when prompted
4. After installation, run from anywhere:
   ```powershell
   EmuScan
   ```

### Option 2: Manual Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/ymuuuu/EmuScan.git
   cd EmuScan
   ```
2. Run the script:
   ```powershell
   .\EmuScan.ps1
   ```

## 🎮 Usage

### Basic Usage
```powershell
# Run EmuScan
EmuScan

# Or from the script directory
.\EmuScan.ps1
```

### System Management
```powershell
# Uninstall from system
EmuScan -uninstall

# Or from the script directory
.\EmuScan.ps1 -uninstall
```

## 📋 Supported Information

| Information | Description |
|-------------|-------------|
| **Device Model** | Hardware profile (e.g., Nexus 6, Pixel 4) |
| **API Level** | Android API version number |
| **Android Version** | Human-readable Android version (e.g., 14.0, 13.0) |
| **Architecture** | CPU architecture (x86, x86_64, arm64-v8a) |
| **Root Status** | Whether the AVD is rooted |
| **Type** | Google Play vs AOSP build |
| **Last Used** | Last opened date (YYYY-MM-DD format) |

## 🔧 Configuration

The script automatically detects:
- **Android SDK Path**: `%USERPROFILE%\AppData\Local\Android\Sdk\emulator\emulator.exe`
- **AVD Directory**: `%USERPROFILE%\.android\avd`

## 🚨 Troubleshooting

### Common Issues

**❌ "Emulator not found"**
- Ensure Android SDK is installed
- Verify emulator.exe exists in the SDK directory

**❌ "No AVDs found"**
- Create AVDs in Android Studio first
- Check AVD directory permissions

**❌ "Script not recognized"**
- Use `-uninstall` (single dash) not `--uninstall`
- Restart PowerShell after installation

### Getting Help
```powershell
# Check PowerShell execution policy
Get-ExecutionPolicy

# Set execution policy if needed (run as Administrator)
Set-ExecutionPolicy RemoteSigned
```

## 🔄 Android Version Support

| API Level | Android Version | Codename |
|-----------|----------------|----------|
| 34 | 14.0 | Upside Down Cake |
| 33 | 13.0 | Tiramisu |
| 32 | 12L | Large Screens Update |
| 31 | 12.0 | S |
| 30 | 11.0 | R |
| 29 | 10.0 | Q |
| 28 | 9.0 | P |
| 27 | 8.1 | O MR1 |
| 26 | 8.0 | O |
| 25 | 7.1 | N MR1 |
| 24 | 7.0 | N |
| 23 | 6.0 | M |
| 22 | 5.1 | Lollipop MR1 |
| 21 | 5.0 | Lollipop |

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Android SDK team for the emulator tools
- PowerShell community for scripting inspiration
- All contributors and users of EmuScan

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/ymuuuu/EmuScan/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ymuuuu/EmuScan/discussions)

---

**Made with ❤️ for Android developers**
