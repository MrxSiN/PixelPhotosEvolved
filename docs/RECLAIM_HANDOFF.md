# Current handoff — 1.2.2-dev / 28

Development build **1.2.2-dev / 28** restores the profile entry and full settings
page on Photos **7.98.0.1007591100 / 52591217**. DexKit 2.3.0 discovers and installs a
read-only native Video Boost state observer. Backup identity, selective upload routing
and Storage Reclaim remain gated to **7.97.0.1000520730 / 52549361**; on 7.98 they are
inactive. The settings page shows this limitation and disables the reclaim action.
No upload, deletion or reclaim was initiated by this compatibility check.

Current canonical implementation: **235 functions**, root
`b3e0625442a4cb43cd0b4206abd05dda0c2d5b7981299ddf9ccf9fdd65a08c34`.
[Semantic index](../report/profile-symbols-1.2.2.json),
[build evidence](../report/build-1.2.2.json),
[profile report](../report/profile-1.2.2.md).
Use current `module_sdk` in the lock (XAX `054262b0af4b40d45b61feafa07612cf87708e7d`), plus
`module/libppepolicy.so`, `module/libdexkit.so` and `module/deps/dexkit-2.3.0.dex`.
The policy executable is built by current BBC (`bbc` pin in toolchain.lock.json).
Original-machine construction/build/tests are external under
`D:/Codex/ppe-profile-20261029/`; no runtime depends on those paths.
`edit.py` expects the original 219-function baseline, so do not rerun it against
the promoted store. Use the canonical source and semantic index for further work.
The current signed APK uses the public development fixture key, not the release key.
The reclaim native bindings, journal and recovery directory described below are
unchanged, and must only run on the supported 7.97 host. Keep all recovery files.

## Retained reclaim implementation handoff (1.2.1 / Photos 7.97)

# Reclaim cross-machine handoff

Current development build: **1.2.1-dev / 27**, checked 29 October 2026. Read the
[feature guide](VIDEO_BOOST_RECLAIM.md) and [repair/device report](../report/reclaim-1.2.1.md).

## Authoritative source and reproduction

`module/pixel_photos_module.xax` is the canonical **219-function** implementation,
root `e7501c953cfa6b8927405d184fb44408d4a30f56aa4297e0ab6a4087283f82d6`. The [semantic index](../report/reclaim-symbols-1.2.1.json) maps external
construction aliases to function CIDs; generic handles can change on export. JSON
evidence is not application source. Keep all conventional tooling outside Git.

Use XAX revision `0876b591f39908e98aa31f746ae2e26bb88c837e`, validated against
`toolchain.lock.json`. Follow [REPRODUCE.md](REPRODUCE.md) to verify stores, compile with
the unchanged ARM64 input, check API 102, package resources, align and sign. VersionCode
is **27**, versionName **1.2.1-dev**. The retained signed APK uses the public development
fixture key. [Build evidence](../report/build-1.2.1.json) and `SHA256SUMS` identify it;
the final installed APK was checked byte for byte. No push or release was requested.

Original-machine transport and tests live in `D:/Codex/ppe-reclaim-20261029/`:
`edit.py`, `direct-upload.py`, `progress.py`, `build-candidate.py`, `test-candidate.py`,
`test-progress.py`, `test-direct.py`, `test-router.py`, `final-device.py`. Recreate the
transport through the pinned SDK elsewhere; those paths are not runtime dependencies.
Private cache IDs, logs, videos and carriers are external. See the report for the
separate successful-upload and final cleanup/restart candidate roots.

## Native boundaries and recovery

The scanner reads the active account cache with OPEN_READONLY and merges `dedup_key`
aliases. Download, source-only Trash and selected permanent deletion retain 1.2.0's
native bindings. The action queue drains before MediaStore publication. The new native
SDK upload uses `cccb`/`ccxa`, an ordinary `cccp` blueprint, actual `cbzj` file fingerprint,
`ccbz.r` byte callback and `tvo.a` finalization in `abiy.c`. Native Photos resolves auth;
PPE does not export credentials or write its account SQL database directly.

Journal: Photos private `ppe_reclaim_journal_v1` preferences. Stages remain 0 download,
1 protected, 2 Trash requested, 4 permanent deletion requested, 5 source absent,
6 replacement published/waiting for upload, 7 complete. Exact size and reread SHA-256
protect destructive steps. `replacement` follows the published local URI; `direct_key`
is the authenticated response's cloud identity, which can differ from the old logical
Boost key. `direct_complete` records native upload/finalization acknowledgement. Final
completion also requires exact-size, active, uploaded cloud records with explicit zero
charge. Existing 1.2.0 stage-6 journals can resume with no repeated deletion.

Progress includes the file/index, seven stages, measured bytes, waits and safe persisted
status. Account/pause guards cancel at native byte callbacks or the next checkpoint.
The worker remains in-process; restart recovery is manual. Verified recovery files
remain in Photos private `files/ppe_reclaim_recovery/` even after success.

The real selected video recovered successfully with zero charged bytes. The final build
restored completion across APK update/restart without another upload. Full fresh cloud
enumeration, thumbnails, account-wide quota proof, recovery-file management and an
exhaustive live failure matrix remain outside this scope. Ordinary reuploads lose the
Video Boost processing flag; old local mappings can still infer Boost from metadata.
