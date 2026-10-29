# Reclaim upload repair and progress — 1.2.1-dev / 27

Implemented and checked on 29 October 2026 through wireless ADB using
`C:/platform-tools/adb.exe`. The connected Pixel 8 Pro runs API 37, Photos
7.97.0.1000520730 / 52549361 and Vector/libxposed API 102.

## Result and cause

`PXL_20261024_145453763.VB-02.MAIN.mp4` had reached journal stage 6 under 1.2.0:
its original cloud copy was already permanently deleted, while the protected and
published **64,743,523-byte** copies remained. Repeated native background-backup
requests returned without transferring the file. Photos' cached backup status was
finished despite no cloud record. Native local mapping still used the old processed
asset identity, which differed from the physical file's actual fingerprint.

The repair sends the verified physical file through Photos' native uploader SDK with
an ordinary Original-quality blueprint and its full-file fingerprint. Authentication,
network operations and response processing remain native to Photos. The upload returned
an authenticated media response; native finalizers populated a new cloud identity.
The journal now records stage **7**. After restart the new cloud record reports:

| Field | Observed value |
|---|---:|
| Active state | 0 |
| Upload status | 100 |
| File size | 64,743,523 bytes |
| Charged bytes | 0 |
| Processed Video Boost format | NULL (ordinary) |

Protected and published SHA-256 remain
`5f2f6916faee0526c9f13885d99d222753573d2e1d38e9f6e2190a3e6350102b`.
The same complete file is uploaded: no re-encoding, remux or metadata stripping is part
of this fix. The local file keeps its VB-02 name. Photos lists the restored cloud copy
as **`PXL_20261024_145453763.VB-03.MAIN.mp4`**, with playable flag 1, **3840 × 2160**
dimensions and **35,266 ms** duration. A temporary filename-only diagnostic was restored
before the successful upload. Local rows may retain their old Boost identity/processing flags;
completion follows the server-returned identity and acknowledged native upload instead.

## Implementation

Canonical XAX remains the application source. Native `cccb`/`ccxa` construct and run
the uploader; `cccp` describes the ordinary file, `cbzj.d` receives its full-file
fingerprint, and `ccbz.r` provides transferred bytes. The returned `ccbt.h` / `cnfl`
is finalized by `tvo.a` within Photos' `abiy.c` transaction. The journal saves the
server-returned `direct_key` separately from the published local mapping and sets
`direct_complete` only after native finalization. Completion still requires active
uploaded cloud metadata with exact size and explicit zero charge. No direct Photos
SQL writes, account-credential extraction or handcrafted network requests are used.

Only selected stale queued backup work is canceled before direct upload. The native
client is closed after success or handled failure. Account/pause checks cancel its
active request at progress callbacks without throwing from the native network callback.
Interrupted attempts keep the journal and verified copies; a completed upload is not
submitted again when resuming final verification. Earlier experimental cache-reset
helpers and all test controls are absent from the delivered graph.

The page now shows a seven-step progress bar, current file/queue position, measured
copy/hash and upload bytes, an indeterminate bar for waits, elapsed attempt time,
persistent safe status and restored completion after restart. The lost Video Boost
processing-flag notice remains on the page and confirmation.

## Validation and limits

- Real upload succeeded from the existing stage-6 journal. The original cloud deletion
  was **not repeated**. Recovery and published bytes remained exact; unrelated videos
  and Trash items were not submitted for reclaim.
- Live UI showed **58.73 MB / 64.74 MB** during transfer, then step 7 completion.
- Final installed APK identity, APK update/restart, persisted completion, scan,
  enabled/disabled action, canceled confirmation, unchanged journal and six preserved
  settings passed **17 device checks**. Two remaining cached chargeable videos were
  available; one was selected only for a canceled confirmation.
- **225** compiled classification/sort/filter/selection checks, **25** progress/resume
  checks, **15** callback/cancel checks, **60** router invariants and **400** concurrent
  host operations passed. Callback tests isolate Android UI dispatch using an external
  no-op seam; they do not simulate Google's service or inject live network failures.
- Canonical store verification, carrier roundtrip, Vector API 102 checks and Android
  v2 signature verification passed. Brainfuck policy, native policy executable,
  existing router CIDs and SDK pin are unchanged.
- Full network-loss, process-kill, disk-full and account-switch matrices are not
  demonstrated. The upload receipt and Photos' per-item cache establish this result;
  no independent account-meter audit or cloud redownload checksum comparison is claimed.
  A standalone decoder helper exited before producing a result; no new full-decode
  claim is made. Local byte identity was verified independently.

The successful upload used candidate root
`93718184c11cd214772f1de38a7456fd53d08c440d23180ff89b696f252a52cf`.
The final build adds cancellation/cleanup handling and clearer wait text; that final
installed root is `e7501c953cfa6b8927405d184fb44408d4a30f56aa4297e0ab6a4087283f82d6` (**219 functions**). It passed the restart/UI checks without
reuploading the already-completed video. The full download/deletion path retains its
earlier [1.2.0 dummy evidence](reclaim-1.2.0.md); this repair's scope is recovery after
that path had already deleted the user's source.

Repository baseline was local commit `5aca34b`. A fresh fetch left `origin/main` at
`49b08b091229b278f7b2d24f00e9177123b9a7c3`; local work was already ahead. No push or
release was requested. External tooling, logs, private identities and video backups
remain outside Git in `D:/Codex/ppe-reclaim-20261029/`.

Evidence: [build](build-1.2.1.json), [source audit](reclaim-audit-1.2.1.json),
[recovery receipt](reclaim-recovery-1.2.1.json), [device checks](reclaim-final-device-1.2.1.json),
[reclaim checks](reclaim-offline-1.2.1.json), [progress checks](reclaim-progress-offline-1.2.1.json),
[callback checks](reclaim-upload-offline-1.2.1.json), [router checks](router-offline-1.2.1.json)
and [semantic index](reclaim-symbols-1.2.1.json).
