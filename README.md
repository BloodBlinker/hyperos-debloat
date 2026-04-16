# HyperOS Debloat — Android Bloatware Removal Script for Xiaomi / POCO / Redmi

Remove pre-installed bloatware, ads, and junk apps from **Xiaomi, POCO, and Redmi phones running HyperOS or MIUI** using ADB — no root required.

Works on Windows, Linux, and macOS. Tested on HyperOS (India variant).

> **Safe by design:** uses `pm uninstall -k --user 0`, which removes apps only for your user account. System files stay intact. Everything can be restored from the Play Store or with a single ADB command.

---

## What gets removed

| Category | Examples |
|---|---|
| Xiaomi / HyperOS bloat | Analytics, MSA ads, cloud sync, Mi Pay, Mi wallpaper, voice assistants |
| Games | Block Puzzle, Bubble Shooter, Solitaire, Mahjong, RAID Legends, and more |
| Amazon | Kindle, Audible, Amazon Shopping, Prime Video |
| Facebook suite | Facebook, Messenger, Facebook Services / System |
| Microsoft Office | Word, Excel, PowerPoint, Outlook, OneDrive, Skype |
| Google extras | YouTube, Duo/Meet, Books, Magazines, AR Core, VR Core, Ad Services |
| Opera | Browser, Opera Max, preinstall stub |
| Spotify / Netflix | Full app + partner activation stubs |
| Mi Credit / Mi Pay | Wallet (IN/ID), Mi Pay manager, UnionPay service |
| Debug / Factory | Logger UI, factory test apps, AutoTest |
| Misc | TikTok, LinkedIn, TripAdvisor, SwiftKey, Sogou IME, CNN Edge Panel |

168 packages total, deduplicated and categorized.

---

## Requirements

- **ADB** (Android Debug Bridge)
  - Linux: `sudo apt install android-tools-adb`
  - macOS: `brew install android-platform-tools`
  - Windows: [Download Android Platform Tools](https://developer.android.com/tools/releases/platform-tools) and extract the zip
- **USB Debugging** enabled on your phone:
  - Settings → About phone → tap *HyperOS version* 7 times → back → Additional settings → Developer options → USB debugging: **ON**

---

## How to use

### Step 1 — Connect your phone

```bash
adb devices
```

You should see your device listed. If it shows `unauthorized`, tap **Allow** on your phone screen when prompted.

### Step 2 — Run the script

**Linux / macOS**

```bash
chmod +x debloat.sh
./debloat.sh
```

**Windows**

Double-click `debloat.bat`, or run it from Command Prompt.

> If Windows SmartScreen blocks it, click **More info → Run anyway**.

The script will ask for confirmation, then show live progress for each of the 168 packages.

```
[  1/168] cn.wps.moffice_eng                                     OK
[  2/168] com.amazon.kindle                                       OK
[  3/168] com.facebook.katana                                     Not installed
...
========================================
 Done.
   Removed : 142
   Skipped : 26 (not present)
   Failed  : 0
========================================
```

Reboot your phone after the script finishes.

---

## Restoring an app

Removal with `--user 0` never deletes system files — it just hides the app from your account.

**Via Play Store:** search and reinstall normally.

**Via ADB:**

```bash
adb shell cmd package install-existing <package.name>
```

Example — restore the stock clock:

```bash
adb shell cmd package install-existing com.android.deskclock
```

---

## Notes

- Some packages won't be present on every device or region — the script silently skips those.
- The wildcard entry `com.miui.miwallpaper.overlay.*` is excluded from the script (`pm uninstall` doesn't support wildcards). Remove specific overlay packages manually if needed.

### Gaming performance

This script removes HyperOS's built-in gaming optimization packages. If you notice worse gaming performance after debloating, restore these four packages:

```bash
adb shell cmd package install-existing com.xiaomi.joyose
adb shell cmd package install-existing com.xiaomi.migameservice
adb shell cmd package install-existing com.xiaomi.gamecenter.sdk.service
adb shell cmd package install-existing com.enhance.gameservice
```

| Package | Purpose |
|---|---|
| `com.xiaomi.joyose` | HyperOS game performance tuner (CPU/GPU boost profiles) |
| `com.xiaomi.migameservice` | Mi Game Service — manages in-game features and optimizations |
| `com.xiaomi.gamecenter.sdk.service` | Game Center SDK backend |
| `com.enhance.gameservice` | Third-party game enhancement service bundled by Xiaomi |

If you don't play games, removing them is fine — they run in the background and consume resources even when idle.

---

## Contributing

Found a package that should be added or removed? Open an issue or PR. Include:
- Package name
- What it does / why it should be removed
- Device model and HyperOS / MIUI version
