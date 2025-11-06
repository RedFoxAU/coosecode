# Windows Long Path Support — Administrator Guide

## Overview
Windows traditionally limits file paths to **260 characters** (`MAX_PATH`).  
This causes errors with deep folder structures or long filenames.  
Modern Windows (10 v1607+, 11, Server 2016+) can support paths up to **32,767 characters**, but the feature must be enabled.

---

## Check Current Setting
Run this PowerShell command as Administrator on the client:
```powershell
(Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem").LongPathsEnabled
```
- `1` = Enabled  
- `0` or blank = Disabled

---

## Affected Systems
- Windows 10 (1607+)  
- Windows 11  
- Windows Server 2016 and later  
- Domain or stand-alone clients  

---

## Root Cause
Mapped drives (e.g. `S:\...`) and older APIs still obey the **260-character limit**.  
UNC paths (`\\server\share\...`) can exceed that, but Windows blocks them unless **Long Paths** are enabled.

---

## How to Enable Long Paths

### Option 1 — Group Policy (recommended for domains)
1. Run `gpedit.msc`
2. Navigate to  
   `Computer Configuration → Administrative Templates → System → Filesystem`
3. Double-click **Enable Win32 long paths**
4. Set to **Enabled**
5. Run:
   ```powershell
   gpupdate /force
   ```
6. Reboot the client.

---

### Option 2 — Registry (all Windows editions)
Run in an elevated PowerShell window:
```powershell
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
  -Name LongPathsEnabled -Value 1 -PropertyType DWORD -Force
```
Reboot after running the command.

---

## Verify Configuration
```powershell
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" | Select LongPathsEnabled
```
If output is `1`, the feature is active.

---

## Detect Long Paths (Diagnostics)
Run as local admin on the client to find files over 260 characters:
```powershell
Get-ChildItem "S:\" -Recurse -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName.Length -gt 259 } |
  Select-Object FullName |
  Out-File "$env:USERPROFILE\Desktop\LongPaths.txt"

Write-Host "Results saved to Desktop\LongPaths.txt"
```

---

## Domain Deployment Script (PowerShell)
Deploy this via Group Policy Startup Script or remote session:
```powershell
# Enable long path support on all clients
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
$Name = "LongPathsEnabled"

if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

Set-ItemProperty -Path $RegPath -Name $Name -Value 1 -Type DWord -Force
Write-Output "Long path support enabled. Reboot required to apply."
```

---

## Notes
- Windows Explorer and some legacy apps may still fail even when enabled.  
- Prefer UNC paths (`\\server\share`) over mapped drives for long paths.  
- Shorten folder and file names where feasible.  
- This is a **client-side** limitation, not server-side.

---

## References
- [Microsoft Docs — Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation)  
- [Microsoft Docs — Naming Files, Paths, and Namespaces](https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file)  
- [Microsoft Q&A — Enable Win32 Long Paths Discussion](https://answers.microsoft.com/en-us/windows/forum/all/enable-win32-long-paths-but-not-work/dbbd1e27-f0ff-482f-b7dd-b71eabcc85d2)

---

**Summary:**  
Enable long paths through Group Policy or Registry, reboot, confirm setting = `1`, and validate with PowerShell.  
Shorten paths where practical even after enabling.
