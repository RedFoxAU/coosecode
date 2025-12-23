# Apple Device Recovery & DFU Master List

A comprehensive reference for entering Recovery Mode, DFU Mode, and Startup Managers across the Apple ecosystem.

## 📋 Table of Contents
*   [Apple Vision Pro & Peripherals](#apple-vision-pro--peripherals)
    *   [Apple Vision Pro](#apple-vision-pro)
    *   [AirTags](#airtags)
*   [Apple TV](#apple-tv)
    *   [Apple TV 4K (No USB Port)](#apple-tv-4k-no-usb-port)
    *   [Apple TV HD / Earlier](#apple-tv-hd--earlier-usb-c--micro-usb)
*   [Apple Watch](#apple-watch)
*   [Audio Devices (HomePod & AirPods)](#audio-devices-homepod--airpods)
    *   [HomePod & HomePod mini](#homepod-original--2nd-gen--homepod-mini)
    *   [AirPods (Pro, Standard, & Max)](#airpods-pro-standard--max)
*   [Mac (macOS)](#mac-macos)
    *   [Apple Silicon (M1/M2/M3/M4)](#apple-silicon-m1-m2-m3-m4)
    *   [Intel Macs with T2 Chip](#intel-macs-with-t2-security-chip-2018-2020)
    *   [Intel Macs (Non-T2)](#intel-macs-non-t2)
*   [iPad](#ipad)
    *   [iPad with Face ID](#ipad-with-face-id-no-home-button)
    *   [iPad with Home Button](#ipad-with-home-button)
*   [iPhone & iPod Touch](#iphone--ipod-touch)
    *   [iPhone 8 to iPhone 16](#iphone-8-x-11-12-13-14-15-16)
    *   [iPhone 7 / 7 Plus](#iphone-7--7-plus--ipod-touch-7th-gen)
    *   [iPhone 6s / SE (1st Gen)](#iphone-6s--se-1st-gen--ipod-touch-6th-gen)
*   [⚠️ The Brutal Reset Procedures](#-the-brutal-reset-procedures-corrupt-firmware)

---

## Apple Vision Pro & Peripherals

### Apple Vision Pro
**Force Restart (Frozen System):**
* Press & hold the **Top Button** + **Digital Crown** simultaneously.
* Keep holding until the screen turns completely black (ignore the Force Quit menu) and the Apple logo reappears [web:66][web:75].

**Recovery Mode:**
* **Wireless (Firmware Issue):** If the device fails to boot, ensure it is powered. Bring an unlocked iPhone (iOS 17+) near the headset. Follow the "Recover Apple Vision Pro" prompt on the iPhone [web:41][web:36].
* **Wired (Requires Developer Strap):**
    1. Connect Developer Strap to Mac via USB-C.
    2. Unplug power from Vision Pro.
    3. Hold the **Top Button** while plugging power back in.
    4. Keep holding until the "Connect to Computer" icon appears [web:71][web:83].

### AirTags
**Factory Reset (Battery Loop):**
1. Press down on the steel battery cover and rotate counter-clockwise to remove.
2. Remove the battery.
3. Replace the battery and press down until you hear a **chirp**.
4. **Remove the battery again immediately.**
5. Repeat this process **5 times total**. The 5th chirp will sound different/longer, indicating the reset is complete [web:73][web:82].

---

## Apple TV

### Apple TV 4K (No USB Port)
**Wireless Recovery:**
* Bring an unlocked iPhone close to the Apple TV if you see a black screen or issue. Follow the prompt on the iPhone to recover tvOS [web:42].

**Force Recovery (The "Plug Pull" Method):**
1. Unplug the Power cord.
2. Plug it back in.
3. **Immediately unplug** as soon as the status light turns on.
4. Repeat this cycle **5-6 times** in rapid succession.
5. On the final plug-in, the device should force itself into Recovery Mode [web:42].

### Apple TV HD / Earlier (USB-C / Micro-USB)
**DFU / Restore Mode:**
1. Unplug HDMI and Power.
2. Connect Apple TV to computer via USB cable.
3. Plug in Power.
4. Hold **Menu** + **Play/Pause** (Siri Remote) or **Menu** + **Down** (Old Remote) for 6 seconds [web:27].

---

## Apple Watch

### All Models (Series 3 and later)
**Wireless Firmware Restore:**
1. Place Apple Watch on its charger.
2. If the screen shows a red "!" icon: Double-click the **Side Button**.
3. Bring an unlocked iPhone (iOS 15.4+) nearby.
4. Follow the "Recover Apple Watch" prompt on the iPhone [web:33][web:43].

**Force Restart:**
* Hold **Side Button** + **Digital Crown** for at least 10 seconds until the Apple logo appears.

---

## Audio Devices (HomePod & AirPods)

### HomePod (Original & 2nd Gen) & HomePod mini
**Manual Reset (Top Touch):**
1. Unplug HomePod, wait 10 seconds, plug back in.
2. Wait 10 seconds, then **touch and hold the top touch surface**.
3. The spinning light will turn **RED**. Keep holding.
4. Siri will say, "Your HomePod is about to reset."
5. Wait for **3 beeps**, then release [web:45][web:56].

**HomePod mini (USB Restore):**
1. Unplug from power brick.
2. Connect the USB-C cable directly to a Mac/PC.
3. Open Finder/iTunes. Locate "HomePod" in the sidebar.
4. Click **Restore HomePod** [web:45][web:49].

### AirPods (Pro, Standard, & Max)
**AirPods Pro & Standard (Case Reset):**
1. Put AirPods in case, lid open.
2. Press & hold the **Setup Button** (back of case) for ~15 seconds.
3. Light flashes **Amber** → then **White** [web:52][web:64].

**AirPods Max (Button Reset):**
1. Charge them for a few minutes.
2. Press & hold **Noise Control** + **Digital Crown** for 15 seconds.
3. Wait for the light to flash **Amber**, then **White** [web:51][web:57].

---

## Mac (macOS)

### Apple Silicon (M1, M2, M3, M4)
**Startup Options (Recovery):**
* Shut down completely.
* Press & hold **Power Button** until "Loading startup options" appears. Select **Options** [web:25].

**DFU Mode (For Apple Configurator / Revive):**
1. Connect USB-C cable to the **Back Left** port (MacBook) or specific DFU port (Desktop).
2. Shut down.
3. Press & hold **Power Button**.
4. Simultaneously press & hold: **Left Control** + **Left Option** + **Right Shift**.
5. Hold all 4 keys for **10 seconds**.
6. Release keyboard keys, **keep holding Power** for 5+ seconds until detected by Configurator [web:39][web:44].

### Intel Macs with T2 Security Chip (2018-2020)
**Recovery Mode:** Cmd (`⌘`) + `R` during boot.
**Internet Recovery:** Cmd + Option + `R` (Latest OS).

**DFU Mode:**
1. Connect to **Front Left** USB-C port.
2. Shut down.
3. Press **Power** for 1 second.
4. Immediately hold: **Right Shift** + **Left Option** + **Left Control**.
5. Hold all 4 keys (including Power) for **10 seconds** [web:35][web:40].

### Intel Macs (Non-T2)
**Recovery:** Cmd + `R`.
**Boot Picker:** Hold `Option` (`⌥`).
**NVRAM Reset:** Cmd + Option + `P` + `R` (2 chimes).

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
**Recovery Mode:** Hold **Home** + **Top Power** until Recovery screen appears.
**DFU Mode:** Hold **Home** + **Top Power** for 8 seconds. Release Power, hold Home [web:24].

---

## iPhone & iPod Touch

### iPhone 8, X, 11, 12, 13, 14, 15, 16
**Recovery Mode:**
1. Press & release **Volume Up**.
2. Press & release **Volume Down**.
3. Press & hold **Side Button** until "Computer + Cable" screen appears [web:28].

**DFU Mode (Black Screen):**
1. Connect to computer.
2. Press & release **Volume Up**.
3. Press & release **Volume Down**.
4. Press & hold **Side Button** for **10 seconds**.
5. While holding Side, press & hold **Volume Down** for **5 seconds**.
6. Release **Side**, keep holding **Volume Down** until detected [web:14].

### iPhone 7 / 7 Plus / iPod Touch (7th Gen)
**Recovery Mode:** Hold **Side** + **Volume Down** until Recovery screen appears.
**DFU Mode:** Hold **Side** + **Volume Down** for 8 seconds. Release Side, hold Volume Down [web:16][web:53].

### iPhone 6s / SE (1st Gen) / iPod Touch (6th Gen)
**Recovery Mode:** Hold **Home** + **Top/Side Power** until Recovery screen appears.
**DFU Mode:** Hold **Home** + **Top/Side Power** for 8 seconds. Release Power, hold Home [web:24].

---

## ⚠️ The Brutal Reset Procedures (Corrupt Firmware)
*Use these "Nuclear Options" when devices are unresponsive, bricked, or have corrupt firmware. These will erase all data.*

### 1. Mac "Revive" & "Restore" (Apple Configurator)
**Requires:** Another Mac with Apple Configurator 2 + USB-C cable.
*   **Target:** Bricked Macs (T2 or Apple Silicon) showing no life or stuck in loops.
*   **Method:** Put the target Mac into **DFU Mode** (Black Screen, see above).
*   **Action:**
    *   **Revive:** Reinstalls bridgeOS/firmware without erasing user data (Try this first) [web:54][web:60].
    *   **Restore:** Completely wipes the SSD, flashes new firmware, and reinstalls recoveryOS (The "Brutal" Fix).

### 2. Apple TV 4K "Plug Pull" Loop
**Requires:** Patience and precise timing.
*   **Target:** Apple TV 4K (no USB port) that fails wireless recovery or has a blinking death light.
*   **Method:** Unplug power → Plug in → Unplug *immediately* as the light turns on.
*   **Repeat:** Do this **5 to 6 times** rapidly. This forces the bootloader to switch partitions and enter Recovery Mode [web:42].

### 3. HomePod "Red Ring" Hard Reset
**Requires:** Manual touch input.
*   **Target:** Unresponsive HomePods.
*   **Method:** Unplug -> Wait -> Plug in -> **Hold Top**.
*   **The Key:** Do not let go when it turns red. You **must wait for the 3 beeps**. If you let go early, it just reboots without wiping [web:45].

### 4. iPhone/iPad DFU Restore (The "True" Clean Install)
**Requires:** Mac/PC.
*   **Target:** Devices with corrupt iOS, failed updates, or boot loops.
*   **Distinction:** Unlike "Recovery Mode" (which uses the device's bootloader), **DFU Mode** (Device Firmware Update) bypasses the bootloader entirely to talk directly to the kernel.
*   **Visual Cue:** The screen **must be black**. If you see a cable icon, you failed and are in standard Recovery Mode. Try again [web:15][web:23].
