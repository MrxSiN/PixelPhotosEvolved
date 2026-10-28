# Reclaim cross-machine handoff

Current development build: **1.2.0-dev / 26**, 28 October 2026. Read the
[feature guide](VIDEO_BOOST_RECLAIM.md) and [implementation/device report](../report/reclaim-1.2.0.md).

## Authoritative source and artifacts

`module/pixel_photos_module.xax` is the canonical implementation, root
`67c4be62d7af424c920cacc95fac0b524cd04755bde60fe33cd5185a3aab01c3`. It contains **193 functions**. The
[semantic index](../report/reclaim-symbols-1.2.0.json) maps construction aliases to exact
function CIDs for this root. Re-exporting a store may renumber generic handles; use CIDs
for navigation. JSON evidence is not an alternative application source.

The unsigned APK is the direct XAX build. The signed APK contains the existing Android
resources and a v2 signature using XAX's public development fixture key. It is not signed
with a release key. Both are retained with [build evidence](../report/build-1.2.0.json)
and `SHA256SUMS`. Native router functions, Brainfuck policy, policy process and toolchain
pins are unchanged. The final APK was installed and checked on the connected phone.

## Reproduce on another machine

1. Pull PPE. Keep authored application source in canonical XAX and Brainfuck. No Java,
   Kotlin, Python or JS application helpers are required or shipped.
2. Obtain XAX revision `0876b591f39908e98aa31f746ae2e26bb88c837e` into an external
   tooling directory and validate every file in `toolchain.lock.json`. Current SDK
   profiles do not substitute for this historical Android/libxposed target.
3. Follow [REPRODUCE.md](REPRODUCE.md): verify stores, supply the unchanged ARM64 policy
   executable to `build_module`, check Vector API 102, package resources using aapt2,
   align, sign and verify. Use versionCode **26**, versionName **1.2.0-dev**.
4. Verify all checksums before device work. Select the intended ADB device explicitly.
   The tested device is Pixel 8 Pro, API 37, Photos 7.97.0.1000520730 / 52549361.

Original-machine transport/build/test drivers are external under
`D:/Codex/ppe-auto-20261028/`. Temporary carriers, private cache identities, logs, UI dumps,
protected videos and diagnostic tooling are outside Git. Recreate transport with the
pinned SDK on another machine; those paths are not runtime dependencies.

## Implemented boundaries

The scan reads the active account's `remote_media` cache with OPEN_READONLY and merges
aliases by `dedup_key`. Selection uses the same identity, fixing duplicated rows and
the disabled-action bug. Real cached positive candidates were checked without reclaiming
them. The authorized dummy completed the automatic native transaction and zero-charge
verification; see the report for the ordinary-dummy test limitation.

The worker uses native logical media from `media`, features loaded through `yxq.v`,
`PhotoDownloadTask`, `pht` remote-only Trash, `bney` selected Trash deletion and
`UploadInBackgroundManagerImpl$StartBackgroundUpload` with MANUAL_BACKUP. Required native
feature sets must be loaded before Trash calls. The native action queue must drain
before replacement publication. No browser RPCs, credential extraction or direct
Photos database writes are used.

Recovery journal: Photos private `ppe_reclaim_journal_v1` preferences. Stages:
0 download, 1 protected, 2 Trash requested, 4 permanent deletion requested,
5 source absent, 6 replacement published/waiting for backup, 7 complete.
Protection requires exact length and stable re-read SHA-256. Photos source keys are
opaque: the published replacement is indexed and verified using its own native identity.
The source and replacement keys may differ, and Photos can reconcile a provisional
local key after upload. Verification refreshes identity from the stable published URI. Recovery files remain in Photos private `files/ppe_reclaim_recovery/`;
they are retained even after success. Resume after process restart is manual.

## Remaining limits and useful follow-up work

Full fresh cloud-library enumeration and cloud thumbnails remain unavailable. Native
cache observations do not guarantee server freshness or account-wide savings. The
worker is in-process; arbitrary process kills, account switching, network failure and
disk-full conditions have not all been exercised as a full failure matrix. Tested
restart/update recovery covers pending native operation and post-deletion upload stages.

Ordinary reuploads lose the Video Boost processing flag. Photos can infer stale native
Boost state from local metadata or the filename; do not recreate format-2 flags to hide
this consequence. The description and confirmation warn users explicitly. A future UI
could expose private recovery-copy management and richer pending-job details.
