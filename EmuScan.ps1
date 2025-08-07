# Handle command line arguments
param(
    [switch]$uninstall
)

# Uninstall function
function Uninstall-ScriptFromPath {
    $scriptName = (Split-Path $PSCommandPath -Leaf) -replace '\.ps1$', ''
    $userModulePath = "$env:USERPROFILE\Documents\PowerShell\Scripts"
    $installedScript = "$userModulePath\$scriptName.ps1"
    
    Write-Host "🗑️  Uninstalling script from system..." -ForegroundColor Yellow
    
    if (Test-Path $installedScript) {
        Remove-Item -Path $installedScript -Force
        Write-Host "✅ Script removed from: $installedScript" -ForegroundColor Green
        
        # Check if Scripts directory is empty and remove from PATH if so
        $scriptsInDir = Get-ChildItem -Path $userModulePath -Filter "*.ps1" -ErrorAction SilentlyContinue
        if ($scriptsInDir.Count -eq 0) {
            Write-Host "📂 Scripts directory is empty, removing from PATH..." -ForegroundColor Yellow
            
            $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
            if ($userPath -like "*$userModulePath*") {
                $newPath = ($userPath -split ';' | Where-Object { $_ -ne $userModulePath }) -join ';'
                [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
                Write-Host "✅ PATH updated. Scripts directory removed." -ForegroundColor Green
            }
        }
        
        Write-Host "🎯 Uninstall complete! Script is no longer available system-wide." -ForegroundColor Cyan
        Write-Host "💡 You can still run the script from its original location: $PSCommandPath" -ForegroundColor Gray
    }
    else {
        Write-Host "❌ Script is not installed system-wide. Nothing to uninstall." -ForegroundColor Red
    }
    
    exit
}

# Check for uninstall argument
if ($uninstall) {
    Uninstall-ScriptFromPath
}

# Check if script is installed system-wide and install if not
function Install-ScriptToPath {
    $scriptPath = $PSCommandPath
    $scriptName = (Split-Path $scriptPath -Leaf) -replace '\.ps1$', ''
    $scriptDir = Split-Path $scriptPath -Parent
    
    # Check PowerShell module paths
    $userModulePath = "$env:USERPROFILE\Documents\PowerShell\Scripts"
    $installedScript = "$userModulePath\$scriptName.ps1"
    
    # Create Scripts directory if it doesn't exist
    if (-not (Test-Path $userModulePath)) {
        New-Item -Path $userModulePath -ItemType Directory -Force | Out-Null
    }
    
    # Check if script is already installed
    if (-not (Test-Path $installedScript) -or (Get-FileHash $scriptPath).Hash -ne (Get-FileHash $installedScript -ErrorAction SilentlyContinue).Hash) {
        Write-Host "📦 Installing script system-wide..." -ForegroundColor Yellow
        
        # Copy script to PowerShell Scripts directory
        Copy-Item -Path $scriptPath -Destination $installedScript -Force
        
        # Check if PowerShell Scripts path is in PATH
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        if ($userPath -notlike "*$userModulePath*") {
            $newPath = if ($userPath) { "$userPath;$userModulePath" } else { $userModulePath }
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            $env:PATH = "$env:PATH;$userModulePath"  # Update current session
        }
        
        Write-Host "✅ Script installed! You can now run '$scriptName' from anywhere." -ForegroundColor Green
        Write-Host "📍 Script location: $installedScript" -ForegroundColor Gray
        
        # Test if script works from current session
        try {
            $testResult = & $scriptName -ErrorAction Stop
            Write-Host "✅ Script is now available system-wide in current session!" -ForegroundColor Green
        }
        catch {
            Write-Host "⚠️  PowerShell needs to be restarted for PATH changes to take effect." -ForegroundColor Yellow
            
            # Prompt user for restart
            Write-Host "`n🔄 Restart Options:" -ForegroundColor Cyan
            Write-Host "1. Restart PowerShell now (recommended)" -ForegroundColor Green
            Write-Host "2. Continue with current session (manual restart needed later)" -ForegroundColor Yellow
            Write-Host "`n📋 Manual Restart Instructions:" -ForegroundColor White
            Write-Host "   • Close this PowerShell window" -ForegroundColor Gray
            Write-Host "   • Open a new PowerShell terminal" -ForegroundColor Gray
            Write-Host "   • Type: $scriptName" -ForegroundColor Gray
            
            $restartChoice = Read-Host "`nChoose option (1 or 2)"
            
            if ($restartChoice -eq "1") {
                Write-Host "🚀 Restarting PowerShell..." -ForegroundColor Green
                Start-Process "pwsh.exe" -ArgumentList "-NoExit", "-Command", "$scriptName"
                exit
            }
            else {
                Write-Host "⏭️  Continuing with current session. Remember to restart PowerShell later!" -ForegroundColor Yellow
            }
        }
    }
    else {
        Write-Host "✅ Script is already installed system-wide." -ForegroundColor Green
    }
}

# Check if user wants system-wide installation
function Check-InstallationPreference {
    $scriptName = (Split-Path $PSCommandPath -Leaf) -replace '\.ps1$', ''
    $userModulePath = "$env:USERPROFILE\Documents\PowerShell\Scripts"
    $installedScript = "$userModulePath\$scriptName.ps1"
    
    # Skip prompt if already installed
    if (Test-Path $installedScript) {
        Write-Host "✅ Script is already installed system-wide." -ForegroundColor Green
        return
    }
    
    # Ask user for installation preference
    Write-Host "🔧 Installation Options:" -ForegroundColor Cyan
    Write-Host "1. Install system-wide (run from anywhere as '$scriptName')" -ForegroundColor Green
    Write-Host "2. Run from current directory only" -ForegroundColor Yellow
    Write-Host "`n💡 System-wide installation allows you to run the script from any location." -ForegroundColor Gray
    
    $installChoice = Read-Host "`nChoose option (1 or 2)"
    
    if ($installChoice -eq "1") {
        Install-ScriptToPath
    }
    else {
        Write-Host "⏭️  Running from current directory. You can install system-wide later by choosing option 1." -ForegroundColor Yellow
    }
}

# Only run installation preference check if not uninstalling
if (-not $uninstall) {
    # Run installation preference check
    Check-InstallationPreference

    # Check if emulator exists
    $emulatorPath = "$env:USERPROFILE\AppData\Local\Android\Sdk\emulator\emulator.exe"
    if (-not (Test-Path $emulatorPath)) {
        Write-Host "❌ Emulator not found at: $emulatorPath" -ForegroundColor Red
        exit
    }

    # Find all AVDs
    $avdDir = "$env:USERPROFILE\.android\avd"
    $avdList = @(Get-ChildItem -Path $avdDir -Filter "*.avd" -Directory | Select-Object Name)

    if ($avdList.Count -eq 0) {
        Write-Host "❌ No AVDs found in: $avdDir" -ForegroundColor Red
        exit
    }

    # Get AVD details from config.ini
    function Get-AvdDetails($avdName) {
        $configFile = "$avdDir\$avdName.avd\config.ini"
        if (-not (Test-Path $configFile)) {
            return @{ Error = "Config file missing" }
        }

        # Read and parse config.ini (escape backslashes)
        $configContent = Get-Content $configFile | Where-Object { $_ -match "=" } | ForEach-Object {
            $_ -replace "\\", "\\"  # Escape backslashes
        }
        $config = $configContent | ConvertFrom-StringData

        # Extract clean API level (e.g., "33")
        $imagePath = $config."image.sysdir.1"
        $apiLevel = ($imagePath -split "android-")[1] -split "\\" | Select-Object -First 1

        # Extract architecture (x86, x86_64, arm64-v8a, etc.)
        $arch = if ($imagePath -match "x86_64") { "x86_64" }
        elseif ($imagePath -match "x86") { "x86" }
        elseif ($imagePath -match "arm64-v8a") { "arm64-v8a" }
        elseif ($imagePath -match "armeabi-v7a") { "armeabi-v7a" }
        else { "Unknown" }

        # Map API to Android version
        $androidVersion = switch ($apiLevel) {
            34 { "14.0" }
            33 { "13.0" }
            32 { "12L" }     # Android 12L (large screens update)
            31 { "12.0" }    # Android 12.0 (initial release)
            30 { "11.0" }
            29 { "10.0" }
            28 { "9.0" }
            27 { "8.1" }
            26 { "8.0" }
            25 { "7.1" }
            24 { "7.0" }
            23 { "6.0" }
            22 { "5.1" }     # Android 5.1 (Lollipop MR1)
            21 { "5.0" }     # Android 5.0 (Lollipop)
            default { "Unknown" }
        }

        # Check if rooted
        $isRooted = (Test-Path "$avdDir\$avdName.avd\userdata-qemu.img") ? "Yes" : "No"

        # Check if Google Play (AOSP vs Google APIs)
        $hasGooglePlay = ($imagePath -like "*google_apis*") ? "Google Play" : "AOSP"

        # Get device model (fallback if missing)
        $deviceModel = if ($config."hw.device.name") { $config."hw.device.name" } else { "Unknown" }

        # Get last opened date from snapshots folder or AVD directory
        $lastOpened = "Never"
        $snapshotsDir = "$avdDir\$avdName.avd\snapshots"
        $avdFolder = "$avdDir\$avdName.avd"
    
        if (Test-Path $snapshotsDir) {
            # Check for snapshot files (indicates recent usage)
            $latestSnapshot = Get-ChildItem -Path $snapshotsDir -Recurse -File | 
            Sort-Object LastWriteTime -Descending | 
            Select-Object -First 1
            if ($latestSnapshot) {
                $lastOpened = $latestSnapshot.LastWriteTime.ToString("yyyy-MM-dd")
            }
        }
    
        # Fallback: check AVD folder modification time
        if ($lastOpened -eq "Never" -and (Test-Path $avdFolder)) {
            $avdFolderInfo = Get-Item $avdFolder
            $lastOpened = $avdFolderInfo.LastWriteTime.ToString("yyyy-MM-dd")
        }

        return @{
            Name           = $avdName
            Device         = $deviceModel
            API            = $apiLevel
            AndroidVersion = $androidVersion
            Arch           = $arch
            Rooted         = $isRooted
            Type           = $hasGooglePlay
            LastOpened     = $lastOpened
        }
    }

    # Display available AVDs with details
    Write-Host "`n📱 Available Android Virtual Devices (AVDs):`n" -ForegroundColor Cyan
    for ($i = 0; $i -lt $avdList.Count; $i++) {
        $avdName = $avdList[$i].Name -replace '\.avd$', ''
        $details = Get-AvdDetails $avdName

        Write-Host "$($i + 1). $avdName" -ForegroundColor Yellow -NoNewline
        Write-Host " | Device: $($details.Device)" -ForegroundColor Gray -NoNewline
        Write-Host " | API: $($details.API)" -ForegroundColor Magenta -NoNewline
        Write-Host " | Android: $($details.AndroidVersion)" -ForegroundColor Green -NoNewline
        Write-Host " | Arch: $($details.Arch)" -ForegroundColor DarkCyan -NoNewline
        Write-Host " | Root: $($details.Rooted)" -ForegroundColor DarkYellow -NoNewline
        Write-Host " | Type: $($details.Type)" -ForegroundColor Blue -NoNewline
        Write-Host " | Last Used: $($details.LastOpened)" -ForegroundColor DarkGreen
    }

    # Let user select an AVD
    $selectedAvd = Read-Host "`nEnter the number of the AVD to launch (1-$($avdList.Count))"
    $selectedIndex = [int]$selectedAvd - 1

    if ($selectedIndex -lt 0 -or $selectedIndex -ge $avdList.Count) {
        Write-Host "❌ Invalid selection!" -ForegroundColor Red
        exit
    }

    $avdToLaunch = $avdList[$selectedIndex].Name -replace '\.avd$', ''

    # Ask for boot mode (Normal or Cold Boot)
    Write-Host "`n🔧 Boot Options:" -ForegroundColor Cyan
    Write-Host "1. Normal Boot (Fast)" -ForegroundColor Green
    Write-Host "2. Cold Boot (Clean State)" -ForegroundColor Blue
    $bootChoice = Read-Host "`nChoose boot mode (1 or 2)"

    # Set emulator arguments based on choice
    $emulatorArgs = "-avd $avdToLaunch"
    if ($bootChoice -eq 2) {
        $emulatorArgs += " -no-snapshot-load"  # Cold boot (forces fresh boot)
        Write-Host "🚀 Starting $avdToLaunch (Cold Boot)..." -ForegroundColor Blue
    }
    else {
        Write-Host "🚀 Starting $avdToLaunch (Normal Boot)..." -ForegroundColor Green
    }

    # Launch the emulator
    Start-Process -FilePath $emulatorPath -ArgumentList $emulatorArgs -NoNewWindow -Wait

    # Script resumes after emulator closes
    Write-Host "`n✅ Emulator closed. Script continues..." -ForegroundColor Cyan
    Pause
}