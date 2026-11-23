## 1.1.5

### What's new
- **See what Reclaim is doing, item by item.** The Progress card shows the current item's seven steps and a checklist of
  what is already proven (where the original came from, same SHA-1 as Google's original, safe copy kept, old cloud copy
  removed, uploaded again). History is now **Items**: done / skipped / left at a glance, filter chips with counts, and
  every item with its state, step bars and status; the item being downloaded shows its download bar. Tap an item for its
  step timeline, hashes, safe copy location and attempts, and to **Skip** or **Retry** an item that has not started.

### Fixes
- **Recover storage could stop for good at Step 2/7 (Downloading)** ([#5](https://github.com/MrxSiN/PixelPhotosEvolved/issues/5)).
  One item whose download never finished stopped the whole queue, and Resume started again at that same item. Step 2
  now downloads the original itself first (timeouts, 3 tries) and uses it only when it is the original byte for byte
  (SHA-1 equals Photos' dedup key, same size); Photos' own download task is the fallback. If the download still fails, that
  item is skipped with its reason in the journal (nothing was deleted for it) and the queue goes on; Resume retries skipped
  items, and after 3 failed runs an item stops holding up Resume and new Recover storage jobs. Later steps still stop the
  job on any failure.
- **Reclaim page and thumbnails were slow, and a thumbnail could be another photo's.** An item whose keys Photos no
  longer had was looked up by file name, a scan of the whole library database for every row. Only Video Boost names use
  that lookup now; with 400 items a run took about 18 s before and 7 to 9 s after. Progress text is written to the journal
  at most once a second while a job runs.

## 1.1.4

Works with Google Photos 8.1. **Library Tools** is now **Library Manager**.

### What's new
- **Smart Filter 2.0.** New filters: Kind (screenshots, creations, favorites), Camera (make and model, read from each
  item's own record), Location (has / missing) and Uploaded (last 7 days ... over a year ago); Albums adds "In 2 or more
  albums". A **search** bar at the bottom, as in Photos, finds file names, dates (`2024-05`), album titles and camera names.
- **Find duplicates.** Exact copies, same name and date, and visually similar photos (a cached difference hash of each
  photo taken within a minute of another), side by side with the suggested best version. RAW + JPEG pairs are never
  suggested; nothing is selected for you, and at least one item of every group stays.
- **Export.** What the filters match, as originals, into one folder, year / month folders or one folder per album, with
  manifest.csv, manifest.json, SHA256SUMS.txt and a report of failed files. Pause any time; it resumes where it stopped,
  even after Photos is closed. Useful as a checked copy before Recover storage.
- **Recover storage.** Select items in Library Manager and tap **Recover storage** (after Download as ZIP). It shows how
  many of them use your account storage and how much, then **Re-upload** sends them through the Reclaim engine (download,
  delete the cloud copy and its own Trash copy, upload again with your Backup setting, check the new copy's storage use),
  or **Move to trash** deletes them. Re-uploaded copies leave their albums, shared links and edits behind.
- **Albums like Photos** for the album filter and Add to: All / Shared with me / My albums, Photos' sorts (Last modified,
  Album title, Most recent photo) and a grid or list view. Albums other people shared with you are included.
- **Info sheet:** People and Albums open Photos' own pages. The viewer's album chip shows "+N" for more albums.
- **Pull to refresh** replaces the Refresh button.

### Fixes
- **Library Manager opened slowly** (up to 10 s and more with every item shown). It now keeps its own small snapshot of
  Photos' records and refreshes it in the background only when they change: about a second with 32,000 items.
- **Dialog buttons** (Add to album, Trash, Delete from device) were nearly invisible on the dark dialog.
- **Albums made on the phone** could not be opened from Info (Photos refused their local key).
- **Reclaim finalization on Photos 7.99 and later.** The last step of Reclaim and Recover storage could fail with an
  account-check error: PPE looked for Photos' owner check under an old class name. It is now found on the phone.
- **Reclaim waits for the delete.** A job no longer stops with "Delete not finished yet" while Photos is still syncing
  the delete (up to 30 seconds).
- **Move to trash of cloud-only items** (Duplicates, the viewer's Trash, Recover storage) failed: PPE asked Photos to
  trash a device copy that did not exist. Items with no copy on the phone are now trashed from the account only.
- **Library Manager counted items in Photos' trash** as library items, so a trashed duplicate stayed in the list. Trashed
  items are now left out, and Duplicates refreshes a moment after Move to trash.
- **Find duplicates > Similar photos is about 5 times faster the first time:** about 3½ minutes instead of about 18 for
  25,000 photos. Later scans only check new photos, as before.
- **Less work per animation frame.** Library Manager's animations (fades, slides, the scrubber and the day pill) no
  longer create throwaway objects on each update, and unused code is left out of the module.
- **Pull to refresh no longer blocks the filter chips.** After a pull let go before it refreshed, the chips could not be
  scrolled sideways.
- **Recover storage toast** says "1 item" for one item and where progress is: Backup > Video Boost Storage Reclaim.

## 1.1.3

Works with Google Photos 8.0 and adds **Library Tools**.

### Fixes
- **Android 13 crash (#2).** Opening the Pixel Photos Evolved card closed Google Photos on Android 13:
  the module called `Character.toString(int)`, which Android 13 does not have. It now builds the text
  another way, and every build is checked so that it calls nothing newer than Android 13.
- **Photos 8.0.** Photos 8.0 renamed one field PPE used to find a class, and PPE then turned every
  feature off. That class is now found without member names.
- **Video Boost uploads on 8.0.** The phone's own User-Agent was not applied to Video Boost uploads on
  Photos 8.0, because the router looked up its upload context under a field that 8.0 moved.
- **No fixed Photos names.** Every Photos class, method and field PPE uses is now found on the phone
  (DexKit rules, field types, protobuf field numbers). A missing one turns off only its own feature.

### What's new
- **Pixel Photos Evolved section** in the profile menu, with **Backup**, **Library Tools** and
  **Compatibility & diagnostics**.
- **Library Tools.** Your whole library, filtered by type, storage, size, date and album, with the
  total size and the account storage each selection uses (#1). It reads Photos' own cache on the
  phone and changes nothing until you act.
- **Grid and viewer** like Google Photos: day headers, pinch to change columns, select by holding.
  The viewer has the date and place, the album, Share, Edit, Add to, Trash and Download, and an Info
  sheet with People, Albums and the place. Swipe the sheet down to close it.
- **Add to album** and **Download** (originals or one ZIP) for selected items.

### Not included yet
- Deleting or re-uploading ordinary photos and videos to free storage (only Video Boost Reclaim
  does this).
- The favourite star and the map in the Info sheet.

## 1.1.2

Works with Google Photos 7.99.

### Fixes
- **Photos 7.99.** Photos 7.99 moved one class PPE looks up, and PPE then turned every feature off,
  including Unlimited Original Quality. PPE now finds that class in 7.99.
- **Updates no longer turn off backup.** Like Pixelify, the Pixel XL identity only changes Android's
  device information, so PPE now applies it on every Photos version. Video Boost routing still checks
  its own Photos classes before it starts. Features that need a Photos class PPE can't find stay off
  on their own.
- **Reclaim upload names.** The Reclaim uploader's method names are now found by their shape instead
  of being fixed to one Photos version.

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
