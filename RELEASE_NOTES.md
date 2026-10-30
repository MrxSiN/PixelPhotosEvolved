## 1.1.1

Video Boost uploads work as intended again, Reclaim finishes reliably, and the Reclaim page is
redesigned in the Material 3 Expressive style.

### Fixes
- **Video Boost uploads.** After the Reclaim page was opened or a scan ran, Video Boost uploads were
  sent with the Pixel XL identity instead of the phone's own, so Google treated them as unlimited
  Original quality uploads. The phone's real model is now captured once at startup and kept.
  Each Video Boost upload logs the model it was sent with.
- **Reclaim finishing.** A reclaim could stop after the upload with "Something went wrong" when
  Photos' account check on the server reply failed. PPE now accepts that check for its own write,
  so the new copy is recorded and linked to the video on the phone.
- **Reclaim page crash.** Opening the page could close Google Photos. Fixed.

### What's new
- **Compatibility & diagnostics** has a **Video Boost identity** row: the model Video Boost uploads
  are sent as, the model of the last upload, and whether it matches the phone.
- **Summary.** Storage in use as a large number, with the selected size next to it. One line below
  shows how many photos and videos the scan checked, or a status that matters.
- **Scan.** **Scan Video Boost**, with a wavy indicator while scanning.
- **Videos.** Shown once a scan finds videos that use storage. **Newest**, **Oldest**, **Largest**
  and **Smallest** sort the list; each video is its own card with a larger thumbnail.
- **Selection.** **Select all**, **Deselect all** and **Invert selection** sit next to **Reclaim
  selected** in the bottom bar, which shows only while you pick videos. The overflow menu is gone.
- **Confirmation.** A new dialog with the amount to free, the four steps and the cautions.
- **Progress.** The card shows the current video's thumbnail, step and bytes. Its circular
  indicator fills during download and upload and spins on the other steps. **Pause** and
  **Resume** are in the card.
- **History.** Date and size, "On device" on its own line, and a short result ("Cloud copy
  replaced." or "Not completed."). Thumbnails come from the phone, or from the cloud copy when the
  phone has none.
- **About reclaim** is two short lines. New text is translated into all ten languages.

## 1.1.0

Support for Google Photos 7.98, a rebuilt Video Boost Storage Reclaim, ten languages, and a module
that keeps working across Photos updates.

### What's new
- **Google Photos 7.98 support.** Unlimited Original Quality, Unlimited Storage Saver, Video Boost
  uploads and Storage Reclaim all work on Photos 7.98.0.1007591100.
- **Survives Photos updates.** PPE finds the Photos classes it hooks with DexKit at runtime, so most
  Photos updates need no new module build. If something can't be found, Photos keeps its own
  behaviour and **Compatibility & diagnostics** shows what is unavailable.
- **Video Boost Storage Reclaim, rebuilt.**
  - Scan for boosted videos that use storage, select them, and reclaim. PPE downloads each video,
    deletes the cloud copy (also from Trash) and uploads it again with your Backup setting.
  - A confirmation dialog explains each step, a progress card shows the current video and step, and
    a history list keeps past results.
  - A safe copy stays on the phone until each video is done, and an interrupted run can be resumed.
- **Ten languages.** English, 简体中文, 繁體中文, Español, Português, Русский, 日本語, 한국어,
  Bahasa Indonesia and Bahasa Melayu. PPE follows the phone language or the per-app language set for
  Google Photos.
- **Restart now.** Changing the backup mode offers a one-tap restart of Photos instead of a manual
  force-stop. It isn't offered while Reclaim is running.
- **Cleaner settings.**
  - No back arrow.
  - Pixel model is greyed out while Unlimited Original Quality is on.
  - The Video Boost description is corrected.
  - Shorter labels throughout.

### Fixes and performance
- The PPE card now appears in the profile menu when Photos is in any language, not only English.
- About 7% less CPU in Photos' first seconds after launch:
  - A redundant compatibility scan no longer runs at every start.
  - Repeat policy checks are cached instead of starting a process each time.
  - A per-label resource lookup was removed from the main thread.
- The Brainfuck policy is now built by current BBC (BFX format 2), with output identical to before.

### Requirements
Android 17 (API 37) ARM64, libxposed API 102 (tested with Vector 2.2), Google Photos
7.98.0.1007591100 (tested). Scope: `com.google.android.apps.photos`. After installing or updating,
force-stop Google Photos and open it again.

Reuploaded videos lose their Video Boost tags and links. Google decides backup eligibility and how
storage is counted, on its servers. Check your account storage after enabling a backup option.

## Retained 1.0.0 release notes

First stable release of Pixel Photos Evolved: unlimited backup and Video Boost controls for Google Photos, inside Google Photos itself (profile picture → **Pixel Photos Evolved**).

### Features
- **Unlimited Original Quality** — Pixel XL (2016) identity inside Google Photos only.
- **Unlimited Storage Saver** — identity of a selected older Pixel (Pixel 2 to Pixel 5a). Mutually exclusive with Unlimited Original Quality.
- **Video Boost** — Video Boost recordings upload with the phone's real identity so Google can process them; other backups keep the backup identity.
- **Compatibility & diagnostics** — module, system and per-feature compatibility, with optional diagnostic logging.

### Requirements
Android 17 (API 37) ARM64, libxposed API 102 (tested with Vector 2.2), Google Photos 7.97.0.1000520730. Scope: `com.google.android.apps.photos`. Force-stop Google Photos after enabling.

Google decides backup eligibility and storage accounting on its servers. Check your account storage after enabling a backup option.
