<div align="center">

<img src="docs/icon.svg" width="120" alt="Pixel Photos Evolved">

# Pixel Photos Evolved

**Unlimited Original Backup with Video Boost**

Google Photos → your profile picture → **Pixel Photos Evolved**.

**English** · [简体中文](README.zh-CN.md) · [繁體中文](README.zh-TW.md) · [Español](README.es.md) · [Português](README.pt.md) · [Русский](README.ru.md) · [日本語](README.ja.md) · [한국어](README.ko.md) · [Bahasa Indonesia](README.id.md) · [Bahasa Melayu](README.ms.md)

<br>

[![Release](https://img.shields.io/github/v/release/MrxSiN/PixelPhotosEvolved?include_prereleases&color=5B3DF5&label=release&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Downloads](https://img.shields.io/github/downloads/MrxSiN/PixelPhotosEvolved/total?color=3DDC84&logo=android&logoColor=fff&style=for-the-badge)](https://github.com/MrxSiN/PixelPhotosEvolved/releases)
[![Android](https://img.shields.io/badge/Android-17%20QPR1-3DDC84?logo=android&logoColor=fff&style=for-the-badge)](https://developer.android.com)
[![Google Photos](https://img.shields.io/badge/Google%20Photos-7.98.0-3DDC84?style=for-the-badge)](#compatibility)
[![libxposed](https://img.shields.io/badge/libxposed-API%20102-5B3DF5?style=for-the-badge)](https://github.com/libxposed/api)
[![Source](https://img.shields.io/badge/source-XAX%20%2B%20Brainfuck-5B3DF5?style=for-the-badge)](#build)
[![Licence](https://img.shields.io/github/license/MrxSiN/PixelPhotosEvolved?color=5B3DF5&style=for-the-badge)](LICENSE)

</div>

---

> [!NOTE]
> **Tested with Google Photos 7.98.0.1007591100 (`52591217`) on Android 17 (API 37),
> Pixel 8 Pro, Vector 2.2 / libxposed API 102.** PPE finds every Photos class it hooks with
> DexKit, so most Photos updates need no new module build. If a class can't be found, Photos
> keeps its own behaviour and **Compatibility &amp; diagnostics** shows what is unavailable.
> See the [DexKit report](report/dexkit-1.4.1.md).

> [!IMPORTANT]
> Google decides backup eligibility and how storage is counted, on its servers. This module
> changes what Google Photos on this phone reports. It cannot promise unlimited storage, and
> using it may conflict with Google's terms of service. Check your account storage after
> enabling any backup option.

<table>
<tr>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/profile-menu.png" width="250"><br><sub>Its own card in the profile menu</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/settings.png" width="250"><br><sub>Drawn like Google Photos settings</sub></td>
<td width="33%" align="center" valign="top"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Compatibility &amp; diagnostics</sub></td>
</tr>
</table>

## Why it works this way

Most modules hand you a second settings app. This one has none: no launcher icon and no settings
activity. Its page opens from its own card in the Google Photos profile menu, above
**Your data in Google Photos** and separate from it. It uses Photos' own fonts, colours, switches
and motion, and stores its settings in Photos' own data directory.

|  | |
|---|---|
| 🧭 **Where you already are** | Profile picture → Pixel Photos Evolved. Back returns to the menu. |
| 🎨 **Looks like Photos** | Photos' type scale, card colours, Material switch and its emphasized easing for page transitions. Light and dark themes follow Photos. |
| 🌐 **Speaks your language** | English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어, Bahasa Indonesia and Bahasa Melayu. Follows the phone's language or the per-app language set for Google Photos. |
| 🛡 **Knows the Photos it runs in** | Every hook is checked against the running Photos build before it is installed. A missing or changed hook disables only its own feature. |
| 🧠 **Policy in Brainfuck** | Backup and Video Boost decisions run as a compiled Brainfuck program (ARM64), called with a small fixed ABI. |
| 🎞 **Original video bytes** | Reclaim keeps a safe copy, deletes only the selected cloud video and its Trash copy, then uploads the same bytes again without re-encoding. |
| 🔒 **Scoped** | Only `com.google.android.apps.photos`. No system-wide hooks, no root needed by the module. |

---

## Features

<details open>
<summary><b>☁️ Backup</b></summary>
<br>

| Setting | What it does |
|---|---|
| **Unlimited Original Quality** | Applies a Pixel XL (2016) identity inside Google Photos, so Photos offers the Pixel XL backup terms. Your phone's own editing features stay available. |
| **Unlimited Storage Saver** | Applies the identity of a selected older Pixel instead. It and Unlimited Original Quality turn each other off. Photos only honours it with backup quality set to Storage saver. |

Identity changes apply when Google Photos starts. After a change, PPE offers **Restart now**, which closes and reopens Photos in one tap. It isn't offered while Reclaim is running.

</details>

<details open>
<summary><b>🎬 Video Boost</b></summary>
<br>

| Setting | What it does |
|---|---|
| **Video Boost** | Detects Video Boost recordings and uploads them with the phone's real identity, so Google can process them while other backups keep the backup identity. Only on phones that record Video Boost: Pixel 8 Pro and the Pixel 9–11 Pro series, including XL and Fold models. |
| **Video Boost Storage Reclaim** | Scan for boosted videos that use storage, select them, and reclaim: PPE downloads each one, deletes the cloud copy (also from Trash) and uploads it again with your Backup setting. Reuploaded videos lose their Video Boost tags and links. |

Videos processed with Video Boost count toward your Google Account storage, even when an
unlimited backup option is on. See [Video Boost](docs/VIDEO_BOOST.md) for how an upload is
recognised and routed.

The current release is **1.1.0** (versionCode 36). The [Reclaim page](docs/VIDEO_BOOST_RECLAIM.md)
asks for confirmation, then works one video at a time: download → check → delete the cloud copy
→ clear it from Trash → upload again → check storage. A progress card shows the current video and
step, and a history list keeps past results. A safe copy stays on the phone until each video is
done, and an interrupted run can be resumed. The scan uses Photos' cache, so it cannot prove full
library coverage. See the [reclaim report](report/reclaim-7.98-1.3.2.md).

</details>

---

## Compatibility

| Android | Google Photos | Device | Status |
|---|---|---|---|
| 17 (API 37) | 7.98.0.1007591100 | Pixel 8 Pro | 1.5.0: all classes found by DexKit, backup probe passes, Reclaim verified on a test video (1.3.2) |
| 17 QPR1 (CP3A.261005.005) | 7.97.0.1000520730 | Pixel 8 Pro | DexKit rules validated against this build's DEX; last tested on the device with 1.2.2-dev |

- **Gate.** At start the module checks Android API 37, ARM64, and that DexKit resolved every class
  it needs. Otherwise it installs nothing that changes behaviour.
- **Per-feature hooks.** Backup and Video Boost hooks are found and checked separately. If one is
  missing, its row in diagnostics says *Not compatible with Google Photos …* and the other keeps
  working.
- **Compatibility &amp; diagnostics** shows the module version, Android, device, Google Photos
  version, libxposed API and framework, and each feature as compatible, disabled or unavailable.
  **Diagnostic logging** adds detail to `adb logcat -s PixelPhotosEvolved`. Logs stay in English.

<table>
<tr>
<td align="center"><img src="docs/screenshots/diagnostics.png" width="250"><br><sub>Module and system</sub></td>
<td align="center"><img src="docs/screenshots/diagnostics-features.png" width="250"><br><sub>Feature compatibility</sub></td>
</tr>
</table>

---

## Requirements

- Android 17 (API 37), ARM64. The APK installs from Android 13, but the hooks only switch on for
  Android 17
- An Xposed framework with **libxposed API 102** (tested with Vector 2.2)
- Google Photos 7.98.0.1007591100 (tested); other builds work when the DexKit rules resolve every required class (Compatibility &amp; diagnostics shows the result)

## Install

1. Install the APK from the [latest release](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
   or the [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
2. Enable **Pixel Photos Evolved** in your Xposed manager, scoped to **Google Photos**
   (`com.google.android.apps.photos`).
3. Force-stop Google Photos and open it again.
4. Profile picture → **Pixel Photos Evolved**.

To turn it off, disable the module in your Xposed manager and restart Google Photos. More in
[installation and troubleshooting](docs/INSTALLATION_AND_TROUBLESHOOTING.md).

Release APKs are built here and re-signed with the release key by the
[release workflow](.github/workflows/release.yml), which also mirrors each release to the
Xposed Modules Repository. [module/pixel_photos_module-signed.apk](module/pixel_photos_module-signed.apk)
is the same build signed with XAX's public test key, for reproducing it.

## How it works

| Piece | Where | What it does |
|---|---|---|
| Module | [module/pixel_photos_module.xax](module/pixel_photos_module.xax) | Canonical XAX store: lifecycle, hooks, settings UI and diagnostics, lowered to DEX by the XAX android-libxposed target |
| Policy | [policy/](policy/) | Brainfuck policy compiled by BBC into an ARM64 stdio executable, packaged as `lib/arm64-v8a/libppepolicy.so` ([ABI](policy/ABI.md)). It is not a JNI library |
| DexKit dependency | [module/deps/](module/deps/) and `module/libdexkit.so` | Precompiled dependency DEX and ARM64 JNI that find the obfuscated Photos classes at runtime; [notices](docs/THIRD_PARTY.md) |
| Resources | [module/res/](module/res/) | Label, description, adaptive icon, and the UI text in ten languages (`values*/`) |

## Translations

The UI text lives in standard Android string resources: English in `module/res/values/ui_strings.xml`
and one `module/res/values-*/strings.xml` per language. To fix a translation, edit the string with
the same `name` in that language's file. To add a language, add a `values-<locale>` folder with
every `ppe_*` key. Missing keys fall back to English.

## Build

Only Brainfuck and canonical XAX are source code in this repository. The build uses the XAX SDK
pinned in [toolchain.lock.json](toolchain.lock.json); conventional build tooling stays outside
the repository. [Reproducing a build](docs/REPRODUCE.md) covers the exact steps: verify the
stores, build the policy executable and module APK with XAX, add the resources with aapt2, sign.
[SHA256SUMS](SHA256SUMS) lists every retained file.

## Evidence

[Status](report/STATUS.md) separates what was checked on the device, what was checked offline and
what is untested. [Evidence index](docs/EVIDENCE.md) links every report.

## Credits

- [XAX](https://github.com/MrxSiN/XAX) — language, semantic store and Android target
- [BBC](https://github.com/MrxSiN/BBC) — Brainfuck compiler
- [DexKit](https://github.com/LuckyPray/DexKit) — runtime DEX discovery ([dependency notices](docs/THIRD_PARTY.md))
- [libxposed](https://github.com/libxposed/api) and Vector

See [attribution](docs/ATTRIBUTION.md). Pixel Photos Evolved is not affiliated with or endorsed by
Google. Google Photos and Pixel are trademarks of Google LLC.
