# Single-video reclaim experiment, 28 October 2026

The user-authorized **download → delete source → permanently delete that source
from Trash → reupload** experiment completed for
`PXL_20261028_000544123.VB-02.MAIN.mp4` through Google Photos' native UI using
`C:/platform-tools/adb.exe`. Its replacement has **zero cached charged bytes**;
Photos' details also explicitly report that it does not take up account storage.
The replacement's cloud round-trip preserved every byte of the processed video.

**This is an ADB-assisted experiment, not an implementation of the module's
automatic Reclaim action.** No new module was built. After the experiment the
repository's existing 1.1.0-dev / 25 APK was installed and Photos restarted. The
automatic action remains disabled.

## Environment

`git pull --ff-only` reported up to date on `main` at
`49b08b091229b278f7b2d24f00e9177123b9a7c3`. One explicitly selected Pixel 8 Pro
ran Android API 37 and Photos 7.97.0.1000520730 / 52549361. ADB used its authorized
wireless transport. Root enabled read-only cache inspection and a protected
temporary file; Photos performed authenticated cloud operations. No authentication
tokens or web RPCs were extracted. No app database was edited.

The existing module settings had master, Pixel XL backup and Video Boost detection
enabled; Storage Saver and verbose logging were disabled. Native automatic backup
performed the replacement upload. Account-wide backup and identity settings were
not toggled.

Artifact inspection found that the preinstalled module also reported 1.1.0-dev /
25 but its DEX differed from the repository. Its APK SHA-256 was
`c47da7d2a59d419337bd9aa9b6057c34a335894cddaba89fd8b16536a313b58a`.
It was preserved externally before updating. The repository APK has the same
public development signer and installed successfully with `adb install -r`;
the final pulled installed APK matches the repository's
`1138358311d08f39f032dd7265c935bc4bc665df5547fbef9bb4196ef0caf773`.
The destructive experiment preceded this update. Its successful charge reduction
must not be attributed to the exact committed APK or treated as an execution of
its disabled Reclaim handler.

The repository APK's final native cache-scan smoke inspected **74,149 rows**, found
**four** chargeable processed candidates, and continued to report Reclaim
unavailable. The dummy's ordinary replacement remained zero-charge and was
excluded from processed-candidate classification. All six stored module settings
matched their initial values after update.

## Executed sequence

1. The exact cached target was an active, uploaded, playable native format-2
   processed output. Physical size and cached charge were both **15,935,452 bytes**.
   Its cover was 12,990,726 bytes with zero charge. The original local processed
   file used `VB-03.MAIN`, while its cloud record retained `VB-02.MAIN`.
2. Preserve the local processed file and cover on the PC and verify SHA-256.
   Use Photos' **Delete from device → Current video only**, retaining the cloud
   record and cover. Invoke **Download**. Photos saves the cloud output under
   `DCIM/Restored/…VB-02.MAIN.mp4`.
3. Verify download size and SHA-256 against the original processed output. Preserve
   verified bytes on the PC and outside MediaStore at
   `/data/local/tmp/ppe-reclaim-20261028/verified-download.mp4`.
4. Use **Trash → Current video only**. Photos reports moving the item to Trash;
   the cache shows state 2 while the cover stays active. In Trash, select only the
   matching recording, with selection count **1**, then **Delete → Delete
   permanently**. The target disappears from Trash and is absent from the cache
   before upload. The eight other visible Trash items remain. **Empty Trash was
   never used.**
5. Restore downloaded bytes to Camera with the same `VB-02.MAIN` filename and
   request a MediaStore scan. Automatic backup completes. The new active cloud
   record has upload status 100, size 15,935,452, **quota_charged_bytes = 0** and
   **blanford_format = NULL**. Its local upload record initially reports
   `is_backup_processed = 1`, with no permanent failure.
6. Remove only the replacement's local copy through Photos, force-stop/reopen
   Photos, and select the cloud replacement's thumbnail. Its details show the
   exact target filename, Original quality, 2160 × 3840 AV1 and the explicit
   no-account-storage message. Cache charge remains zero after restart.
7. Download the replacement again. SHA-256 still matches. Android decodes
   **147 frames**, 2160 × 3840 AV1, duration 4,900,000 microseconds, with clean
   end-of-stream. An initial decoder invocation fails because its old temporary
   JAR is absent; pushing the existing external fixture and rerunning succeeds.
8. Restore the original local processed filename `VB-03.MAIN` in Camera. Delete
   the temporary local `VB-02.MAIN` download by its verified MediaStore identity.
   Both original local hashes match their pre-test values. The replacement remains
   active and zero-charge in the cache.

Processed-video SHA-256, identical before the experiment, after both cloud
downloads and after local restoration:

`b6fce21218455c8a4dec36fa1204a51f1c3ef0277d1aa9145833c9c80e3b8b1c`

Cover SHA-256, identical before and after:

`2fc88f2b99c2b4051ed0d6cae42ee2a54dde5ee2e3b5aef2b4d5c7b9d36440b9`

## Diagnosis and remaining work

The requested order works for this dummy without changing its bytes. It produces
an ordinary zero-charge cloud video; it does not preserve the original remote
processed Video Boost flag. After downloading that replacement, Photos displays
**Boosting video quality** despite successful decoding. The local cache still
marks the file format 2, while the remote format is NULL. This observed native
state mismatch is **not evidence of an actual new server Boost job**, nor proof
that the filename alone caused it. Restoring local `VB-03.MAIN` has not been shown
to repair native group state. The final local record still reports
`is_backup_processed = 0`, joined to an uploaded zero-charge remote record.

The automatic module workflow still needs validated account-bound native media
lookup, full downloads, source-only Trash/permanent deletion and upload scheduling.
A durable journal must preserve verified bytes before deletion and resume an
interrupted upload. Deletion must identify the selected source, never the whole
Trash. The native group/playback mismatch also needs resolution before this is
presented as a complete user-facing reclaim feature.

DEX inspection identifies `PhotoDownloadTask` and native Trash classes, but no
new task binding was implemented or exercised by PPE. ADB UI actions do not prove
in-module reflection calls or queue recovery. The existing scanner correctly
excludes the ordinary replacement because its remote processed flag is NULL.

Observed per-item charge changed from **15,935,452 to 0 bytes**. Account-wide meter
reconciliation, an independently queried fresh quota API, arbitrary videos, album
relationships, concurrent uploads, account changes, network failures and restart
recovery during the destructive sequence were **not tested**. No general storage
or relationship-preservation guarantee follows from this run.

External scripts, protected media and private UI/DEX artifacts are retained in
`D:/Codex/ppe-reclaim-20261028/`, outside the repository. See the
[machine-readable summary](reclaim-dummy-20261028.json).
