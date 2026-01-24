# Run as Administrator
# Restore Classic Notepad in Windows 11 (24H2/25H1 Ready)

Write-Host "=== Classic Notepad Setup ===" -ForegroundColor Cyan

# 1. Install correct System Notepad capability
Write-Host "`n[1/4] Checking System Notepad installation..." -ForegroundColor Yellow
$capName = "Microsoft.Windows.Notepad.System~~~~0.0.1.0"
$notepad = Get-WindowsCapability -Online | Where-Object Name -like $capName

if ($notepad.State -ne 'Installed') {
    Write-Host "Installing System Notepad (Classic)..." -ForegroundColor Yellow
    DISM /Online /Add-Capability /CapabilityName:$capName
} else {
    Write-Host "System Notepad already installed" -ForegroundColor Green
}

# 2. Disable Modern Notepad Execution Alias (Robust Method)
Write-Host "`n[2/4] Disabling modern Notepad alias..." -ForegroundColor Yellow

# A. Registry Method (Fixes Win+R / Run Dialog)
$aliasRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\notepad.exe"
if (Test-Path $aliasRegPath) {
    Remove-Item -Path $aliasRegPath -Force -Recurse
    Write-Host " - Registry alias key removed (Fixes Run dialog)" -ForegroundColor Green
} else {
    Write-Host " - Registry alias key already clean" -ForegroundColor Green
}

# B. File Method (Fixes PowerShell / CMD / Git Bash)
$aliasFilePath = "$env:LOCALAPPDATA\Microsoft\WindowsApps\notepad.exe"
if (Test-Path $aliasFilePath) {
    $fileItem = Get-Item $aliasFilePath
    # Check if it is a ReparsePoint (Symlink/Junction/AppExecLink) which confirms it's an alias
    if ($fileItem.Attributes -match "ReparsePoint") {
        try {
            # Rename it so it's no longer in the PATH
            Rename-Item -Path $aliasFilePath -NewName "notepad.exe.bak" -ErrorAction Stop
            Write-Host " - Execution Alias file renamed (Fixes CLI/PATH)" -ForegroundColor Green
        } catch {
            Write-Host " ! Unable to rename locked alias file (Normal for WindowsApps)." -ForegroundColor Red
            Write-Host "   ACTION: Go to Settings > Apps > Advanced app settings > App execution aliases > Toggle 'Notepad' OFF" -ForegroundColor Magenta
        }
    } else {
        Write-Host " - Alias file already handled (not a reparse point)" -ForegroundColor Green
    }
}

# 3. Create txtfilelegacy registry keys (ProgID)
Write-Host "`n[3/4] Setting .txt file association keys..." -ForegroundColor Yellow
$regPath = "HKLM:\SOFTWARE\Classes\txtfilelegacy\Shell\Open\Command"
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}
# Point directly to System32 to avoid any alias confusion
Set-ItemProperty -Path $regPath -Name "(Default)" -Value 'C:\Windows\System32\notepad.exe "%1"'
Write-Host "Registry keys created" -ForegroundColor Green

# 4. Create Start Menu shortcut
Write-Host "`n[4/4] Creating Start Menu shortcut..." -ForegroundColor Yellow
$startMenuPath = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
$shortcutPath = "$startMenuPath\Notepad (Classic).lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$shortcut = $WScriptShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "C:\Windows\System32\notepad.exe"
$shortcut.Description = "Classic Notepad"
$shortcut.Save()
Write-Host "Shortcut created" -ForegroundColor Green

Write-Host "`n=== Setup Complete ===" -ForegroundColor Cyan
Write-Host "Final Manual Step Required:" -ForegroundColor Yellow
Write-Host "1. Right-click any .txt file"
Write-Host "2. Select 'Open with' > 'Choose another app'"
Write-Host "3. Select 'Notepad (Classic)' or 'Notepad' (Look for the old icon)"
Write-Host "4. Click 'Always'" -ForegroundColor Green
