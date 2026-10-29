# Profile settings and DexKit — 1.2.2-dev / 28

Checked 29 October 2026 on Pixel 8 Pro, Android 17 API 37, Photos
7.98.0.1007591100 / 52591217, Vector API 102. The delivered development APK is
installed and matches the hash in [build evidence](build-1.2.2.json).

## Result and compatibility boundary

Photos updated from 7.97 to 7.98. The old exact-version guard blocked the profile
entry itself; its resource IDs were also numeric constants from 7.97. The entry now
resolves native resources by name and inserts one card above **Your data in Google
Photos**, with the existing structural checks and duplicate tag retained.

The full PPE settings page and diagnostics open on 7.98. A banner explains the
unsupported features, and the Storage Reclaim row is disabled. Opening settings
does not enable the module or call old obfuscated compatibility probes on this host.
Back and reopen work. Preferences and the reclaim journal retain their original
hashes across APK replacement and these page checks.

**Backup identity, selective Video Boost upload routing and Storage Reclaim remain
inactive on 7.98.** Their native gate remains pinned to Photos
7.97.0.1000520730 / 52549361, Android API 37 and ARM64. This task did not initiate an upload,
delete, reclaim, change native backup settings or retest cloud quota accounting.
Earlier 7.97 upload/reclaim reports retain their dated scope; unchanged function
bodies and host regressions do not establish live service compatibility on 7.98.

## DexKit integration

The APK bundles the unmodified DexKit 2.3.0 ARM64 JNI library and dependency DEX.
All authored application logic remains canonical XAX. A once-per-process background
scan opens the installed Photos base APK, finds a unique ReadyToPlay state label,
its singleton and state contract, then the unique resolver that references it.
Public/static/final field, method shape and five distinct recognized state-class
associations must agree before installing the observer. Ambiguous or failed scans
leave the observer unavailable. The bridge closes on success and failure.

The 7.98 runtime discovered resolver `Luvp;->c(Lbzyb;)Luvn;`. State labels map to
NeedsUpload, Uploading, Processing, ReadyToPlay and PermanentlyFailedProcessing.
The separate real-device probe found one ReadyToPlay label and one resolver in
1,182 ms. The actual module then installed `ppe.boost.state.dexkit.v1` through API
102. On the supported 7.97 host it retains the pinned observer, avoiding duplication.

This observer calls the native chain once, returns its original result or exception,
and records the recognized status/time only when detection is enabled. It changes
neither the upload identity nor reclaim authorization. No live media state event
was deliberately exercised on 7.98; native discovery/installation and compiled
callback behavior are the evidence available here.

Final startup at 17:19:26–17:20:01 UTC+08:00 reported the unsupported backend gate,
successful read-only observer installation, bridge cleanup and profile insertion.
These are sanitized events from the final Photos process, not older log buffers.

## Build and verification

The canonical module has 235 functions, root
`b3e0625442a4cb43cd0b4206abd05dda0c2d5b7981299ddf9ccf9fdd65a08c34`.
Seven existing bodies changed for profile UI/version display, safe UI refresh and
isolated discovery startup; sixteen helpers were added. Existing native backend
gate, routing and reclaim worker bodies and policy artifacts are preserved.
The initial construction transport used XAX 0876b59; the final store verifies,
roundtrips and builds with current XAX 054262b. No native XAX-MCP Android edit is
claimed. [Semantic audit](profile-audit-1.2.2.json) and
[function index](profile-symbols-1.2.2.json) identify the source.

All 392 compiled checks pass under JVM verification: 67 profile/DexKit, 225 reclaim,
25 progress, 15 callback/cancel and 60 router checks; 400 concurrent router operations
also pass. Fixtures and their limits are recorded in [regressions](regression-1.2.2.json).
The direct-upload fixture substitutes a no-op for Android UI posting. Host fixtures
do not emulate Google's cloud. The unchanged Brainfuck policy was not retested.

Raw unsigned and final signed APKs reproduce exactly. API 102 validation, v2
signature and 16 KiB native-library alignment pass. Every original XAX APK entry
except the intentionally replaced resource manifest is preserved. Third-party
notices/license copies are packaged. The signer is XAX's public development fixture.
Validation preceded the user's subsequent commit/push request; no release or tag
was created. See [device checks](profile-device-1.2.2.json),
[reproduction](reproduction-1.2.2.json), [build instructions](../docs/REPRODUCE.md)
and [dependency notices](../docs/THIRD_PARTY.md).

BBC was fast-forwarded to 5378395, XAX to 054262b; XAX-MCP was already at 27ffb94.
Their working trees are clean. Current BBC emits BFX format 2; the validated BFX-1
policy remains frozen to its historical producer instead of silently changing ABI.
Exact revisions and artifact hashes are in the lock and
[dependency update record](dependency-update-20261029.json).
