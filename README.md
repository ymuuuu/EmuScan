# EmuScan 📱

A PowerShell script for running Android Virtual Devices (AVDs) on windows without laucnhing Android Studio with an intuitive interface and comprehensive device information display.

## Features

- \*\* Less Resources Consumption due to not running the whole AS IDE
- ** Comprehensive AVD Information**: View device model, Android version, API level, architecture, root status, and last usage date
- ** Smart Boot Options**: Choose between normal boot (fast) or cold boot (clean state)
- ** System-wide Installation**: Install once, run from anywhere
- ** Easy Management**: Install/uninstall with simple commands

## Example

```
📱 Available Android Virtual Devices (AVDs):

1. Device 1 | Device: Nexus 6 | API: 33 | Android: 13.0 | Arch: x86_64 | Root: Yes | Type: Google Play | Last Used: 2025-07-31
2. Device 2 | Device: Nexus 6 | API: 34 | Android: 14.0 | Arch: x86_64 | Root: Yes | Type: AOSP | Last Used: 2025-08-07

Enter the number of the AVD to launch (1-2):
```

## Prerequisites

- **Windows** with PowerShell 5.1 or later
- **Android SDK** installed with emulator
- **Android Virtual Devices** (AVDs) created in Android Studio

## Installation

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

## Usage

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

## Supported Information

| Information         | Description                                       |
| ------------------- | ------------------------------------------------- |
| **Device Model**    | Hardware profile (e.g., Nexus 6, Pixel 4)         |
| **API Level**       | Android API version number                        |
| **Android Version** | Human-readable Android version (e.g., 14.0, 13.0) |
| **Architecture**    | CPU architecture (x86, x86_64, arm64-v8a)         |
| **Root Status**     | Whether the AVD is rooted                         |
| **Type**            | Google Play vs AOSP build                         |
| **Last Used**       | Last opened date (YYYY-MM-DD format)              |

## Configuration

The script automatically detects:

- **Android SDK Path**: `%USERPROFILE%\AppData\Local\Android\Sdk\emulator\emulator.exe`
- **AVD Directory**: `%USERPROFILE%\.android\avd`

## Troubleshooting

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

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
