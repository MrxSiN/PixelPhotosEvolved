# Reproducing 0.6.1

The repository's application source is canonical XAX and Brainfuck. Keep all
compiler/edit/build/test drivers, fixtures and temporary carriers **outside** it,
including anything that would otherwise be ignored. Documentation, JSON evidence
and generated binary artifacts are retained here.

## Toolchain

Use XAX revision **0876b591f39908e98aa31f746ae2e26bb88c837e**, including its
historical android-libxposed JVM profile. Extract the committed revision into an
external directory and validate every file against
[toolchain.lock.json](../toolchain.lock.json): 75 SDK source hashes, Vector table
and public test signer fixture. A different/dirty working tree is not equivalent.

The tested external SDK is D:/Codex/ppe-work-20261023/build/xax-sdk. Python 3.13
is compiler transport; JDK 17 runs host fixtures. Android SDK platform android-37.0
and build-tools 37.0.0 supply inspection and signature tools. The module build uses
XAX directly, without Java/Kotlin application source, Gradle or D8. Conventional
languages used by external test tooling are not application source.

## Canonical sources and build

1. Load and verify all three stores with the pinned StoreReader/verify_store:
   module/pixel_photos_module.xax, module/policy_process.xax and
   policy/pixel_photos_policy.xax.
2. Resolve the policy-process module entry/function/AArch64 target and call
   xax_linux_aarch64.compile_linux_aarch64_executable. Its bytes must exactly
   match module/libppepolicy.so.
3. Call xax_android_libxposed_jvm.build_module with that executable supplied under
   its BLAKE3 digest. Compare with module/pixel_photos_module-unsigned.apk and run
   xax_vector against the pinned API 102 table.
4. Add the label, description, icon and versionName. The pinned XAX target emits a
   manifest without them and no resource table, so compile [module/res](../module/res)
   with aapt2 (build-tools 36.0.0, android-37.0 android.jar), link it with a manifest
   that repeats the XAX manifest values plus `android:label`, `android:description`,
   `android:icon`/`roundIcon` and `versionName`, and replace only AndroidManifest.xml
   while adding resources.arsc and res/. Every XAX entry stays byte for byte.
5. Sign externally with a chosen capability. The supplied installable APK uses
   the SDK's **public fixture test key**. Verify with Android apksigner v2 checks.
6. Compare roots/hashes with [build evidence](../report/build-0.6.1.json), then
   verify [SHA256SUMS](../SHA256SUMS). The unsigned artifact and native executable
   reproduce exactly; signed and unsigned APKs serve different purposes.

The `.so` is **ET_EXEC / AArch64**, extracted and invoked through stdio.
It has no JNI/native module entry and must not be passed to System.loadLibrary.

## Brainfuck pipeline

The pinned BBC bounded frontend is compiler/compiler.bf, SHA-256
89e87c42d870e879c4dbbf2ec578da2823351566d3e7d25801f29b5804446b2a.
Run it with a 65,536-cell wrapping-byte reference interpreter, EOF-as-zero,
u16le source length + exact policy bytes + final byte 1. Reject errors. The result
must match the included 3,289-byte BFX: BFX NUL, format 1, status 0, 3,279 commands.

This is the historical reproducible frontend, not BBC's newer native CLI.
The pinned historical importer entry
cbbd3d0c7dcc26908b6b967d8792b2dbc7c4cda8d3180276588ae04a8e1c50b5
produced the canonical policy. The process store contains the same decision
function. The APK executes the compiled ARM64 decision, not an interpreter.
See [ABI](../policy/ABI.md) and [baseline BBC evidence](../report/baseline/bbc-0.4.0.json).

## Editing and tests

Canonical stores are authoritative; JSON carriers are only SDK transport. The
verified editing path exports a carrier, edits/constructs the graph, verifies
typing/structure and round-trip root equality, then saves atomically with
Workspace.save. The newer transaction scanner rejected the historical BUILD
layout; no successful transaction-edit claim is made for that attempted path.

External drivers under D:/Codex/ppe-work-20261023/tools/ include bootstrap_sdk.py,
build.py, verify_bbc.py and verify.py. Build with an external output directory;
build.py's --check-reproducible compares the retained unsigned APK. verify.py
--skip-native runs the independent BF model and compiled classifier/gate. The
pinned Windows byte-arithmetic backend is unsuitable for native-policy evidence;
use the exact ARM64 executable on the phone instead.

External video-boost/check.py runs 42 compiled vectors; check-router.py runs
60 invariants and 400 concurrent host operations under JVM verification. The
router test's positive ARM64/network evidence is recorded separately in the real
upload reports. Host fixtures do not emulate Google's service. External
decode-check.py verified the actual completed outputs on-device using Android's
decoder, without exporting video content. See the [evidence index](EVIDENCE.md).

Baseline device reports are preserved as dated evidence. New reproduction runs
should write results outside the repository first, rather than overwrite those
historical snapshots. Phone tests must select the intended ADB device, preserve
settings/media and exclude private identifiers from delivered evidence.
