# Status — 1.1.1 / 37

**1.1.1** (versionCode 37) fixes Video Boost upload routing and Reclaim finalization, adds a Video
Boost identity row to Compatibility & diagnostics, and redesigns the Reclaim page. Build:
[build-1.1.1.json](build-1.1.1.json). Screenshot: [reclaim-1.1.1.png](../docs/screenshots/reclaim-1.1.1.png).

- **Video Boost identity.** The startup capture of the phone's model ran again on every Reclaim
  scan and page build in the 7.98 port, after the Pixel XL identity was applied, so Video Boost
  uploads went out as Pixel XL. It now runs once. On the device a VB-02.MAIN upload made after a
  Reclaim scan logged `native model Pixel 8 Pro`; two module-on recordings had free covers and
  charged boosted videos, two module-off recordings had charged covers.
- **Reclaim finalization.** Photos' MediaActorVerifier rejected some reupload replies
  (`NON_MATCHING_GAIA_BACKEND_GAIA_ID_INVALID`). It is now accepted only on the thread running
  PPE's own write. Six test videos were reclaimed to 0 charged bytes, each stored once.
- **Not yet exercised on the device:** the new confirmation dialog, the progress card thumbnail and
  byte-based indicator, the equal-width sort row and the owner-check hook during a reclaim. They
  are the first things to check in the next version.

## 1.1.0 / 36

**1.1.0** (versionCode 36) is the release build of 1.5.0-dev: the same module, with the version name
set to 1.1.0. Build: [build-1.1.0.json](build-1.1.0.json).

## 1.5.0-dev / 36

**1.5.0-dev / 36** adds nine UI languages (简体中文, 繁體中文, Español, Português, Русский, 日本語,
한국어, Bahasa Indonesia, Bahasa Melayu) using standard Android resources. It also fixes the profile
card, which never appeared when Photos ran in a language other than English. A device log review led
to four optimizations:
- the 586 ms startup DexKit compatibility scan no longer runs when every symbol is resolved;
- policy results are memoized instead of forking a process per probe;
- the per-TextView `getIdentifier` call on the main thread is gone;
- translated strings are cached.

A backup mode change now offers **Restart now**, which closes and reopens Photos in one tap. This
was checked on the device for Original → Storage Saver → Original.

In an A/B of 10 cold starts per build, Photos used 7.3% less CPU in its first 8 s (−1.17 s). Launch
time and memory were within noise.

Checked in English, Simplified Chinese and Japanese: settings, Reclaim, diagnostics, backup probe and
self-tests. The READMEs are now available in all ten languages. See the
[languages and performance report](i18n-perf-1.5.0.md) and [build](build-1.5.0.json).

## 1.4.1-dev / 33

**1.4.1-dev / 33** removes the last classes pinned to Photos 7.98. New DexKit rules find the
router's stage-4 client-info class and its protobuf message, and the backup-offer caller. On 7.98
every symbol now comes from DexKit (`pinned fill 0, differ 0`): 1671 ms on the first start, 2 ms
from the cache. The backup probe passes. The Reclaim page gains shorter labels, a Material 3
confirmation dialog, a per-video progress card and a history list. The dialog was opened and
cancelled on the device with no crash. A full reclaim run with the new progress and history views
has not been done yet. See the [DexKit report](dexkit-1.4.1.md) and [build](build-1.4.1.json).

## 1.4.0-dev / 32

**1.4.0-dev / 32** resolves obfuscated Photos classes at runtime with DexKit instead of
pinning them to one Photos build. Version-independent rules, validated on 7.97 and 7.98, resolve
75 of 78 classes. On 7.98 the first scan takes 528 ms with 0 disagreements against the verified
names, and later starts use a 1–2 ms cache. The backend gate is now "all required symbols
resolved". Three classes were still pinned to 7.98 (fixed in 1.4.1).

## 1.3.2-dev / 31

**1.3.2-dev / 31** removes ten unused or redundant functions (dead code, the hidden back button,
a duplicate button factory and a redundant guard): 263 → 252 functions. No behaviour change
is intended. All 228 lookups resolve on 7.98, and the device regression passes (startup hooks,
backup probe, settings, diagnostics, Reclaim scan, selection, viewer, back). See
[build](build-1.3.2.json).

The policy executable is now built by current BBC (BFX format 2). It matches the retired
BFX-1 build on 21,480 device vectors and passes the in-app self-tests.

**Reclaim works on 7.98.** The test video went from 37,104,159 charged bytes to a re-uploaded
copy with 0 charged bytes. The first upload attempt timed out; Resume completed it. See the
[reclaim report](reclaim-7.98-1.3.2.md).

## 1.3.1-dev / 30

**1.3.1-dev / 30** removes the page back arrow (system back is kept, and stays above the
account sheet). Pixel model is greyed out while Unlimited Original Quality is on, and the
Video Boost description is corrected. Video Boost Storage Reclaim is rebuilt: overflow menu,
summary card, scan toggle, thumbnail rows with real metadata, empty states, and a bottom
action bar pinned on screen. Checked on 7.98 in light and dark themes; no reclaim was run. See
the [UI report](ui-1.3.1.md) and [build](build-1.3.1.json).

## 1.3.0-dev / 29

Development build **1.3.0-dev / 29** ports every backend hook to Photos
**7.98.0.1007591100 / 52591217**. Backup identity, Unlimited Storage Saver, the Video Boost
router and state observer, and Storage Reclaim are active again. The backup offer probe passes
for Pixel XL and Pixel 5. A read-only Reclaim scan read 74,145 cached records. Diagnostics shows
the right version, descriptions follow Photos' punctuation, and Reclaim uses Photos'
MaterialButton. No upload, deletion or reclaim was run. 7.97 is inactive in this build. See the
[port report](port-1.3.0.md), [symbol map](symbols-7.98-1.3.0.json) and
[build](build-1.3.0.json).

## Earlier development builds

- 1.2.2-dev / 28 (Photos 7.98 profile/settings and DexKit discovery): [profile report](profile-1.2.2.md)
- 1.2.1-dev / 27 (Photos 7.97 reclaim recovery and progress): [reclaim report](reclaim-1.2.1.md)

## Retained release and backend evidence

Verified on 2026-10-23, UTC+08:00. Pixel 8 Pro, Android 17 API 37 /
CP3A.261005.005 / 16271449; Photos 7.97.0.1000520730 / 52549361;
Vector 2.2 / 3080 / API 102.

| Area | Current evidence |
|---|---|
| 1.0.0 release | Package io.github.mrxsin.pixelphotosevolved, versionCode 24; v2 signature verified; loaded by Vector with policy self-tests and backup probe passing and settings preserved, checked 2026-10-26; module code unchanged from 0.6.6 |
| Build | 69-function canonical module (0.6.1); installed APK matches delivered artifact; unsigned APK and ARM64 input reproduce exactly; API 102 static check and v2 signature pass |
| Source constraint | Only Brainfuck/canonical XAX source; conventional tooling external; all retained paths scanned |
| Compiled checks | 42 classifier/gate/state/label vectors; 60 router invariants; 400 concurrent host operations |
| Brainfuck policy | Unchanged bytes: 18,187 independent offline vectors and 128 exact packaged ARM64 device vectors retained from 0.4; fresh BBC output matched |
| Startup identity | Exact Photos/API/ABI gate; 13 Build fields, 45 property reads, five additive 2016 flags; real model captured before spoof; backup probe passes |
| Selective Video Boost | Native BLANFORD hint + trusted MediaStore metadata + strict VB-02.MAIN + compiled BF policy 2; six exact hooks, private finalization queue, opaque operation-token correlation |
| Native upload evidence | Genuine manual and automatic raw uploads completed with remote format 1; native headers/client prepared; Pixel XL probe still passed afterward |
| Completed output | Two independent local/remote format-2 matches; both 2160Ã—3840 AV1 files fully decoded on-device, 128 and 134 frames, clean end-of-stream |
| Per-item quota | Disabled original/boosted: 11,401,750 / 8,176,531 charged bytes. Enabled: 0 / 7,039,859. Capture-time module states confirmed by user |
| Ordinary backup | Generated JPEGs uploaded manually and automatically with matching reported dimensions/size and zero charged bytes; prior generated MP4 checks retained |
| 0.6.5 Storage Saver | Pixel 2, 3 XL, 3a XL, 4 XL, 4a, 5 and 5a identities applied on-device; Photos client eligibility confirmed for Pixel 2 to Pixel 5; Pixel 5a not eligible per Photos (PIXEL_2021_MIDYEAR); uploads and quota untested |
| 0.6.5 settings | Photos type scale; Unlimited Original Quality / Unlimited Storage Saver (mutually exclusive) with model picker; Video Boost section with latest status; shared-axis transitions |
| 0.6.4 settings | Pixel Launcher Evolved-style segmented tiles; Backup, Video Boost and Compatibility & diagnostics only; master switch and Editing removed; diagnostics page with module, system and per-feature compatibility; checked 2026-10-26 |
| 0.6.4 package | App label, description, adaptive icon and versionName packaged from module/res with aapt2; shown in App info |
| 0.6.3 settings | Own profile card above Your data with a distinct icon; rewritten production copy; status lines separated; Back/reopen, single entry, persistence, light/dark and 1.3 font scale checked 2026-10-26 |
| 0.6.3 startup | Module loads, no FATAL/ANR; identity trace logging reduced from 7 lines to 1; backend code paths unchanged |
| Settings | In-Photos controls, native/router status, Back/reopen, persisted enabled controls and single profile entry checked on 0.6.1 |
| Backup mode | Earlier manual test used backup off; later automatic test verified Backup on / queue complete and left backup enabled |
| Themes / rotation | Successful 0.4 UI/recreation checks retained; not repeated for 0.6.1 |
| Native editing | Magic Eraser and Photo Unblur saved separate copies with Pixel XL active on 0.4; original JPEG hash unchanged; not repeated for 0.6.1 |
| Hot reload | Unsupported by pinned SDK application profile; restart Photos |

## Limits

The final quota check uses Photos' per-item remote metadata, not an independent
account-meter reconciliation. Original quality for the enabled original remains
user-reported; the agent independently checked original quota and reported size.
There was no fresh cloud-download byte comparison or visual enhancement assessment.
The native ReadyToPlay enum was not captured in the final recheck; native
format-2 records and complete output decoding establish completion.

Live retry/cancel/failure injection, simultaneous ordinary/Boost network uploads,
HEIC, and other modern editing workflows remain untested. Host concurrency tests
do not substitute for simultaneous network tests. The native observer reports
the last state in the process, not a per-file cloud job tracker.

The manual 0.6.1 recording has pre/post-upload unchanged-original evidence. The
automatic recording uploaded before its monitor baseline; only post-upload hash
stability is claimed for that recording. Decoding the final two boosted outputs
was read-only and left their hashes unchanged.

See the [evidence index](../docs/EVIDENCE.md),
[Video Boost implementation](../docs/VIDEO_BOOST.md), and
[independent result](INDEPENDENT_VALIDATION_0.6.1.md). Baseline reports describe
their older builds and support only the explicitly retained checks above.
