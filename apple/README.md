# Apple Device Recovery & DFU Master List

A comprehensive reference for entering Recovery Mode, DFU Mode, and Startup Managers across the Apple ecosystem.

---

## iPhone

### iPhone 8, X, 11, 12, 13, 14, 15, 16 (Face ID & Touch ID SE 2/3)
**Recovery Mode:**
1. Connect to computer.
2. Press & release **Volume Up**.
3. Press & release **Volume Down**.
4. Press & hold **Side Button** until the "Computer + Cable" icon appears (do not release at Apple Logo) [web:17][web:28].

**DFU Mode (Black Screen):**
1. Connect to computer.
2. Press & release **Volume Up**.
3. Press & release **Volume Down**.
4. Press & hold **Side Button** for **10 seconds** (Screen goes black).
5. While holding Side, press & hold **Volume Down** for **5 seconds**.
6. Release **Side Button** but keep holding **Volume Down** until the computer detects a device in recovery (Device screen stays black) [web:14][web:23].

### iPhone 7 & 7 Plus
**Recovery Mode:**
1. Connect to computer.
2. Press & hold **Side Button** + **Volume Down** together.
3. Keep holding until the Recovery Mode screen appears [web:16].

**DFU Mode:**
1. Connect to computer.
2. Press & hold **Side Button** + **Volume Down** for **8 seconds**.
3. Release **Side Button** but keep holding **Volume Down** until detected by computer [web:24].

### iPhone 6s, SE (1st Gen) & Earlier
**Recovery Mode:**
1. Connect to computer.
2. Press & hold **Home Button** + **Top (or Side) Power Button** together.
3. Keep holding until the Recovery Mode screen appears [web:13].

**DFU Mode:**
1. Connect to computer.
2. Press & hold **Home Button** + **Top (or Side) Power Button** for **8 seconds**.
3. Release **Power Button** but keep holding **Home Button** until detected by computer [web:24].

---

## iPad

### iPad with Face ID (No Home Button)
**Recovery Mode:**
1. Press & release **Volume Up**.
2. Press & release **Volume Down**.
3. Press & hold **Top Power Button** until Recovery screen appears [web:30].

**DFU Mode:**
1. Press & release **Volume Up**.
2. Press & release **Volume Down**.
3. Press & hold **Top Power Button** for **10 seconds**.
4. While holding Power, press & hold **Volume Down** for **5 seconds**.
5. Release **Power**, hold **Volume Down** until detected [web:18].

### iPad with Home Button
**Recovery Mode:**
1. Press & hold **Home Button** + **Top Power Button** together until Recovery screen appears [web:13].

**DFU Mode:**
1. Press & hold **Home Button** + **Top Power Button** for **8 seconds**.
2. Release **Power**, keep holding **Home** until detected [web:24].

---

## Mac (macOS)

### Apple Silicon (M1, M2, M3, M4)
**Startup Options (Recovery):**
* Shut down completely.
* Press & hold **Power Button** until "Loading startup options" appears. Select **Options** > **Continue** [web:25].

**DFU Mode (For Apple Configurator / Revive):**
1. Connect USB-C cable to the **Back Left** port (MacBook) or specific DFU port (Desktop).
2. Shut down.
3. Press & hold **Power Button**.
4. At the same time, press & hold: **Left Control** + **Left Option** + **Right Shift**.
5. Hold all 4 keys for **10 seconds**.
6. Release the keyboard keys but **keep holding Power** for another 5+ seconds until detected in Apple Configurator 2 [web:39][web:44].

### Intel Macs with T2 Security Chip (2018-2020)
**Recovery Mode:** Cmd (`⌘`) + `R` during boot [web:19].
**Internet Recovery:** Cmd (`⌘`) + Option (`⌥`) + `R` (Latest OS) OR Shift + Cmd + Option + `R` (Original OS).

**DFU Mode (For Apple Configurator):**
1. Connect USB-C to the **Front Left** port (MacBook) or specific DFU port.
2. Shut down.
3. Press **Power Button** for 1 second.
4. Immediately press & hold: **Right Shift** + **Left Option** + **Left Control**.
5. Hold all 4 keys (including Power) for **10 seconds**.
6. Release all keys (Device remains black, check Configurator) [web:40].

### Intel Macs (Non-T2)
**Recovery Mode:** Cmd (`⌘`) + `R`.
**Boot Picker:** Hold `Option` (`⌥`) during boot.
**Reset NVRAM/PRAM:** Cmd + Option + `P` + `R` (Hold for 2 chimes).
**Safe Mode:** Hold `Shift` during boot [web:31].

---

## Apple Watch & Apple TV

### Apple Watch
**Wireless Firmware Restore (Series 3+, watchOS 8.5+):**
1. If watch shows red "!" icon: Double-click **Side Button**.
2. Bring unlocked iPhone (iOS 15.4+) nearby.
3. Follow prompts on iPhone [web:33][web:38].

### Apple TV
**Apple TV 4K (No USB Port):**
* **Wireless Recovery (tvOS 17+):** Bring unlocked iPhone close to Apple TV if black screen/issue persists (Automatic prompt).
* **Force Recovery Menu:** Unplug power → Plug in → Unplug immediately when light turns on. Repeat **5-6 times** in rapid succession [web:42].

**Apple TV HD / Earlier (USB-C or Micro-USB):**
* Unplug HDMI & Power.
* Connect via USB to Computer (iTunes/Finder).
* Plug in Power. Hold **Menu** + **Play/Pause** for 6 seconds (if not detected automatically) [web:27].
