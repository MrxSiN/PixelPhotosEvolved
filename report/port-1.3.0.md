# Photos 7.98 port — 1.3.0-dev / 29

Checked 29 October 2026 on Pixel 8 Pro, Android 17 API 37, Google Photos
7.98.0.1007591100 / 52591217, Vector 2.2 / API 102.

## Problem

The 1.2.2 log on 7.98 showed `Unsupported Photos / Android / ABI; native behavior retained`
at every start. The backend gate (f27, f90, f148) accepted only 7.97 / 52549361, and every
backend lookup used 7.97 obfuscated names. Backup identity, the Video Boost router and
Storage Reclaim were off. Only the profile card and the DexKit observer ran.

## Port

Both Photos base APKs were parsed outside the repo. Each 7.97 class was matched by its string
constants and member-shape fingerprint, then confirmed through method signatures and usage
(caller/field-reader) fingerprints. The full map is in
[symbols-7.98-1.3.0.json](symbols-7.98-1.3.0.json).

- 66 obfuscated classes renamed; member names are unchanged except `yxq.v → ytx.u`,
  `ccxa.j/k → ccie.z/A` (media upload SDK 6.0.3 → 6.1.0), and the protobuf-lite builder base
  (`N → L` copyOnWrite, `J → H` build). In 7.98, `N` is a different method that throws.
- Enum constants were checked by their `<clinit>` names: `DOWNLOAD_PHOTO_ONE_UP` (`eO`),
  the PIXEL_2016–2021 feature fields and the five Video Boost state classes.
- The backup generation and snapshot hooks only act for allowlisted stack callers. The
  allowlists still named 7.97 frames, so the offer probe failed. Callers of the generation
  provider were matched in order (`baie`, `abwr`, `abwg`, `vxt`, `wdv`, `tkd`).
- The gate and the diagnostics text now name 7.98.0.1007591100 / 52591217. 7.97 is inactive
  in 1.3.0.

A static check replays every reflective lookup in the module against the 7.98 dex: 228/228
resolve. The same check reports 70 failures for 1.2.2 on 7.98.

## UI consistency

- Diagnostics showed `1.2.2-dev`. The version strings now follow the package version.
- One-line descriptions drop the trailing period, matching native Photos settings rows
  ("Compatible with Google Photos …", the Storage Saver description).
- Reclaim page buttons are now Photos' own `MaterialButton`, in sentence case, instead of
  legacy all-caps `android.widget.Button`.
- Checked and left unchanged: the profile card's title size, inset and weight match the native
  rows (ink density per character 212–223). Tile colour follows the account sheet's
  `colorSurfaceContainerLowest`, the same black as the native sheet rows.

## Device results (1.3.0-dev, fixture-signed)

| Check | Result |
|---|---|
| Startup | Router, identity, Video Boost observer and backup offer hooks installed; policy self-tests 6/6; no exceptions |
| Unlimited Original Quality | Probe passed (offer `PixelOfferDetail{Pixel XL, PIXEL_2016, hasOffer=true}`); native Backup page: "This Pixel XL can back up unlimited photos & videos at no charge" |
| Unlimited Storage Saver | Mutual exclusion works; Pixel 5 identity applied; probe passed; Storage saver quality offered. Original preferences restored byte-for-byte afterwards |
| Reclaim scan (read-only) | 74,145 cached records read; 2 chargeable boosted videos (236 MB) listed |
| Reclaim journal | SHA-256 unchanged |

## Not verified

No upload, deletion or reclaim ran. The Video Boost router and native finalization hooks
install and resolve. The runtime-typed protobuf fields `d` and `e` on hook arguments were not
exercised by a live Boost upload. Cloud quota accounting was not rechecked. The hooks are
pinned to one Photos build again. Resolving them through DexKit at runtime would survive the
next Photos update, but that is not done here.
