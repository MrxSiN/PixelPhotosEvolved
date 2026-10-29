# Reclaim on Photos 7.98 — 1.3.2-dev / 31

Checked 29 October 2026 on Pixel 8 Pro, Google Photos 7.98.0.1007591100, with the
user-prepared test video `PXL_20261028_091730539.VB-02.MAIN.mp4`, using the flow
scan → select → reclaim → download from cloud → delete cloud copy → reupload.

## Result

| | Before | After |
|---|---|---|
| Cloud record | `remote_media` 275843, 37,104,159 bytes, Video Boost format 2 | 275917, 37,104,159 bytes, no Video Boost format |
| Storage charged | 37,104,159 bytes | **0 bytes** |
| Content identity | dedup key `7mrrFJOCf-W0HX7_CyWuDICTv8U` | same bytes; local SHA-1 `8be7222a…` unchanged |

1. The scan listed the video as chargeable. Only that video was selected.
2. The engine downloaded and verified the full-quality output (SHA-256 recorded in the
   journal), kept a protected copy, deleted the cloud original, and published the local
   replacement.
3. The first native upload attempt failed ("Photos operation failed or timed out"). The
   cloud copy was already deleted at that point; the protected copy, the published file and
   the original local file were all intact. **Resume reclaim** retried the upload, which
   completed with a server media response.
4. After Photos synced, its cache showed the new cloud record with 0 charged bytes.

## Why the cloud copy is deleted before re-uploading

A byte-identical copy written to `DCIM/Camera` received the **same dedup key** as the source.
In about 5 minutes Photos created no new cloud item for it, and the only cloud row for that
content stayed the charged source. While the source exists, a re-upload resolves to the
same cloud object, so the source must be removed first. The probe file was deleted
afterwards; it was never uploaded.

## Findings

- **Completion is reported early.** The journal said "Reclaim complete" before Photos' cache had
  the replacement record; zero charge was confirmed only by the later sync. Completion
  should wait for the cache record with 0 charged bytes.
- **First-attempt upload failure.** This was transient; Resume succeeded. The failure handler
  now logs its reason (`Reclaim stopped: …`) so the next failure is diagnosable.
- **Two local copies remain.** The original `VB-03.MAIN.mp4` and the published
  `VB-02.MAIN.mp4` are byte-identical. Cleanup is left to the user.
