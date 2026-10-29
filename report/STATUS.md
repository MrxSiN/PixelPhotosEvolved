# Status — 1.2.1-dev / 27

Checked 29 October 2026 via wireless ADB on Pixel 8 Pro. The failed real-video reclaim
is recovered: the exact 64,743,523-byte file uploaded through Photos' native SDK, and
its ordinary cloud record reports zero charged bytes. The protected and published
SHA-256 match. No deletion was repeated from the persisted post-deletion journal.

The page now shows seven steps, current file/queue position, measured copy/upload
bytes, waiting state and persisted status. Completion survives APK update/restart
without resubmitting the video. Reuploaded videos lose their Video Boost processing
flag. Scan deduplication, selection, canceled confirmation and preserved settings pass.

Final source/APKs pass canonical and API 102 checks, v2 signature verification,
225 reclaim checks, 25 progress checks, 15 callback/cancel fixture checks, 60 router
invariants and 400 concurrent host operations. Seventeen final device checks pass.
The policy/router remain unchanged. Read the [repair report](reclaim-1.2.1.md) for
candidate provenance, the local identity distinction and limits. Full fresh enumeration,
account-wide quota audit and exhaustive live failure injection remain unproven.

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
