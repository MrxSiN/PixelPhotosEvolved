# Automatic Video Boost Storage Reclaim — 1.2.0-dev / 26

Implemented and installed on the connected Pixel 8 Pro on 28 October 2026.
Repository baseline and freshly fetched `origin/main` both resolved to
`49b08b091229b278f7b2d24f00e9177123b9a7c3`. Changes remain local; no push or release
was requested. Prior experiment reports retain their dated scope.

## Result

After selection and confirmation, PPE automatically obtains a full-quality local video,
protects a verified private copy, deletes the selected cloud original, permanently
deletes only that logical video's Trash entry, publishes the same bytes and explicitly
requests Photos' native backup. It reports completion only after matching uploaded cloud
records report explicit zero charge and the published local item is backup-processed
without permanent failure. Recovery stages persist across app restart and APK update.

The scan previously counted two distinct remote aliases for each of two videos. Scanner
deduplication, single selection and bulk selection now use `dedup_key`. Four aliases
produce **two unique videos**, with **264,060,478 cached charged bytes**, rather than
528,120,956 bytes. A checked row enables Reclaim; deselection disables it. Pending jobs
offer Resume. Completion removes completed rows and selections from the current page.

The main card, feature description, confirmation and documentation describe the actual
download → cloud deletion → selected Trash deletion → reupload order. They warn that
the replacement **loses its Video Boost processing flag** and becomes an ordinary video.
Grouping/playback indicators may change. Video bytes are not re-encoded.

## Native implementation

The source remains canonical XAX. New worker/queue/UI functions use Android APIs and
pinned Photos native services within its process. No Java/Kotlin/Python/JS runtime source
or new library is shipped. External compiler transport and fixtures stay outside Git.
The Brainfuck policy, ARM64 executable, policy process, SDK lock and existing native
upload router functions are unchanged.

Native account lookup and logical media loading precede `PhotoDownloadTask`, `pht`
REMOTE_ONLY Trash, `bney` selected-item Trash deletion and
`UploadInBackgroundManagerImpl$StartBackgroundUpload` with MANUAL_BACKUP. Required
native feature sets are loaded before each operation. The account action queue must
drain and the source must remain absent before replacement publication. Other Trash
items are never passed to an Empty Trash operation.

Preflight requires the supported Photos/API/ABI combination, active original account,
enabled PPE/Unlimited Original Quality, applied Pixel XL identity, native Photos backup
and its Original quality setting, and a positive source size. Source aliases, format,
uploaded status, size and hidden/shared/partial flags are rechecked. Before deletion,
the recovery copy must have exact size and stable re-read SHA-256. Source keys are
opaque; the published replacement is re-read against that SHA-256 and resolved through
its exact MediaStore URI, rather than reusing the source key. Verification follows
that stable URI if Photos reconciles a provisional local key after upload. Journal stages are committed before destructive requests.

The account SQLite database is opened read-only; PPE makes no direct Photos database
writes and extracts no credentials. MediaStore creates the replacement in `DCIM/Camera/`.
Private recovery files remain in Photos app data, including after successful reclaim.

## Device validation and its scope

ADB was selected explicitly from `C:/platform-tools/adb.exe`. Device: Pixel 8 Pro,
Android API 37, Google Photos 7.97.0.1000520730 / 52549361, Vector/libxposed API 102.
USB was used for final checks; an earlier wireless transport was also available.

The authorized dummy was `PXL_20261028_000544123.VB-02.MAIN.mp4`, **15,935,452 bytes**.
An earlier native-UI experiment had already changed its charged processed cloud copy
to an ordinary zero-charge replacement. The automatic test therefore used a temporary,
clearly labelled development-only entry to invoke the same transaction worker for that
dummy. Production positive/native-format-2 classification was not broadened. The final
source and APK exclude the dummy entry, hardcoded filename, download probes and debug
stack logging.

The worker initially stopped at a missing native feature before deletion; its journal
and protected copy survived. After fixing the binding, an APK update/Photos restart
resumed the source operation and publication. A further restart resumed stage 6 and
explicitly queued backup. The repeat run with the final quality/action-queue guards
then completed the full native transaction from a fresh download to persisted stage 7.
No ADB media deletion or upload was used to advance the worker's cloud transaction.

Observed after automatic completion:

- Active uploaded cloud record: exact size **15,935,452**, cached charge **0**, native
  processed format **NULL** (ordinary backup).
- Published local item: backup-processed **1**, permanent failure **0**.
- Published and private recovery SHA-256:
  `b6fce21218455c8a4dec36fa1204a51f1c3ef0277d1aa9145833c9c80e3b8b1c`.
- Full native decoder result: AV1, **2160 × 3840**, **147 frames**, duration
  **4,900,000 µs**, clean end-of-stream.
- Cover cloud record remains active/uploaded, **12,990,726 bytes**, zero cached charge.
  Four positive processed aliases still represent the same two other videos.
- Final cache contained seven Trash rows. No before/after identity-complete audit of
  all unrelated Trash content is claimed; the earlier UI's visible count is a different
  observation. The automatic native calls target only the selected logical dummy.

Two early diagnostic Frida attachment attempts crashed Photos due to unsupported device
instrumentation. That server was stopped; canonical native probes and all completed
transactions ran without Frida. These tooling failures are not final module crashes.

The final installed artifact was separately checked for unique rows, enabled/disabled
button behavior, confirmation notices, cancel without mutation, unique bulk selection,
sort/filter selection preservation, navigation, absence of test controls, package version,
exact APK hash, startup probes and preserved six settings. The real positive videos were
not reclaimed by these final UI checks. The earlier charged-dummy experiment remains the
evidence for charged-positive deletion/reupload behavior; the automatic ordinary-dummy
run alone does not independently prove that quota transition.

A final read-only consistency check found that one real processed video's native source
key did not equal the SHA-1 of its downloaded bytes. The worker now treats that key as
opaque, preserves source tracking separately and resolves the replacement's own native
key from its exact published MediaStore URI. Published bytes are re-read against the
protected SHA-256 before backup. A native read-only probe with deliberately different
source and replacement identities passed, and a real processed video's download/protection
path passed without invoking cloud deletion or upload. The complete dummy transaction
also exposed Photos reconciling a provisional replacement key after upload; verification
now refreshes the native identity through the same stable published URI every cycle.
The complete dummy transaction was repeated to completion with these fixes before
producing the final artifact.

## Verification and artifacts

- Canonical source: **193 functions**, root `67c4be62d7af424c920cacc95fac0b524cd04755bde60fe33cd5185a3aab01c3`;
  graph verification, export/construct roundtrip and baseline-checked atomic save pass.
- Direct XAX APK reproduced from the source; signed resource-packaged entries preserve
  every direct APK entry except the replaced manifest. Vector API 102 check passes.
- APK v2 signature verifies using the public development fixture key.
- **225** actual compiled JVM reclaim classifier, comparator, filter and logical-selection
  checks pass, including different remote aliases sharing a selected content identity.
- **60** compiled router invariants and **400** concurrent host operations pass. Router
  CIDs and policy inputs are unchanged; retained earlier BF/device tests still describe
  those exact unchanged subjects.
- Installed final APK SHA-256: `f07860afebbb196f125c99b37a0bfa88ef651e259c7e20c9ed3ecd799816a6d6`.

Evidence: [build](build-1.2.0.json), [source audit](reclaim-audit-1.2.0.json),
[compiled reclaim](reclaim-offline-1.2.0.json), [router](router-offline-1.2.0.json),
[automatic native dummy](reclaim-automatic-device-1.2.0.json),
[final installed UI](reclaim-final-device-1.2.0.json),
[canonical symbol index](reclaim-symbols-1.2.0.json).

## Limits

Scanning and completion/quota verification use Photos' account cache. Full fresh cloud
enumeration, cloud thumbnails and account-wide quota guarantees remain unavailable.
The worker runs in Photos' process, with manual Resume after process death; it is not
a foreground service. Native/network waits are bounded and retained copies permit retry,
but arbitrary network-loss, disk-full and process-kill conditions have not all been
tested as an exhaustive failure matrix. Clearing Photos data removes private recovery.
Private copies remain after success and consume device space.

Photos may infer a Boost-related state from a downloaded VB-02 filename/local metadata
even though the cloud replacement is ordinary. The earlier experiment observed this
native state mismatch. The app warns about flag loss instead of fabricating processed
metadata. See the [feature guide](../docs/VIDEO_BOOST_RECLAIM.md) for operation and recovery.
