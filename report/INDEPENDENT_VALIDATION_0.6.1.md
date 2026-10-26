# Independent completion and quota check — 2026-10-23

The two completed recordings independently match the user's report. The user
identified the approximately 4:03 PM recording as module disabled and the
4:21 PM recording as module enabled. Capture-time switch states come from that
confirmation; the asset records and decoding below were checked directly.

| Recording | Original charged bytes | Boosted charged bytes | Boosted output |
|---|---:|---:|---|
| A — module disabled | 11,401,750 | 8,176,531 | Complete, fully decodable |
| B — module enabled | **0** | 7,039,859 | Complete, fully decodable |

All four selected remote records have upload status 100 and partial_backup 0.
The retained original videos are 11,401,750 and 11,704,640 bytes respectively;
their reported remote sizes match their local files. The original here is the
retained unboosted **VB-01.COVER** version, distinct from the temporary raw
VB-02.MAIN processing input. The boosted outputs are VB-03.MAIN with native
local and remote **Blanford format 2**, not merely matching filename suffixes.
Both boosted remote records report can_play_video 1 and match local byte sizes.

The actual downloaded boosted files were decoded **on the phone** with Android
MediaExtractor and MediaCodec, draining the decoder to end-of-stream:

| Recording | Codec | Dimensions | Duration | Decoded frames | End-of-stream |
|---|---|---|---:|---:|---|
| A | AV1 | 2160×3840 | 4.267 s | 128 | Clean |
| B | AV1 | 2160×3840 | 4.467 s | 134 | Clean |

This independently establishes completed, decodable boosted outputs for both
recordings and the expected per-item quota split. The boosted files' hashes
were unchanged during the read-only decode. No media content or decoded frames
were exported. The decoder test tooling and its Java source stayed outside this
repository; its temporary device DEX was removed after the checks. No module
source, APK, backup setting or module setting changed.

The installed APK still matches the delivered 0.6.1-dev artifact, SHA-256
`8164434d2126ba7498492bc71abc47261d5022a5072c83c93fac65cb1be7865b`.
The active Photos build is 7.97.0.1000520730 / 52549361 on API 37, Pixel 8 Pro.

Quota evidence is Photos' **remote_media.quota_charged_bytes** for these exact
local/remote pairs. This was not an independent account-meter reconciliation or
a fresh cloud download/byte comparison. The Original quality UI label remains
from the user's report; this check independently verified original quota and
reported size. The native ReadyToPlay enum was not captured during this run;
completed native format-2 records and full output decoding provide the completion
evidence. Visual enhancement quality was not assessed. The boosted local
is_backup_processed flags are 0; these flags are distinct from the completed
remote records and successful decoding of cloud-produced outputs.

Machine-readable evidence: [independent-validation-0.6.1.json](independent-validation-0.6.1.json).
See the [evidence index](../docs/EVIDENCE.md) for related current and baseline
checks, and [Video Boost behavior](../docs/VIDEO_BOOST.md) for routing boundaries.
Personal filenames, paths, media fingerprints, keys, tokens and account data
are excluded.
