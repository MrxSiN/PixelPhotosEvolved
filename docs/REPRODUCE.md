# Current build — 1.2.2-dev / 28

The current module uses XAX **054262b0af4b40d45b61feafa07612cf87708e7d**.
Extract that exact Git revision outside this repository, and validate every file
under `module_sdk.files` in [toolchain.lock.json](../toolchain.lock.json).
The older `policy_sdk` pin reproduces the unchanged BFX-1 policy/process only.
Use Python compiler transport externally with bytecode caches disabled. Authored
application logic remains canonical XAX/Brainfuck; no transport or foreign-language
source belongs inside this repo, including ignored paths.

1. Verify all three canonical stores. The module root is recorded in
   [build-1.2.2.json](../report/build-1.2.2.json); export/construct on the current SDK
   preserves that root exactly. The initial edit transport used the older SDK.
2. Supply these exact binary inputs to `xax_android_libxposed_jvm.build_module`,
   keyed by each file's BLAKE3 digest: `module/libppepolicy.so`,
   `module/libdexkit.so`, `module/deps/dexkit-2.3.0.dex`. Compare the raw output with
   `module/pixel_photos_module-unsigned.apk`. Run the pinned Vector API 102 checker.
3. Package `module/res` with aapt2 36.0.0 and platform android-37.0. Manifest:
   package `io.github.mrxsin.pixelphotosevolved`, min SDK 33, target SDK 37,
   versionCode 28, versionName `1.2.2-dev`, application hasCode true,
   label `@string/app_name`, description `@string/module_description`, icon and
   roundIcon `@mipmap/ic_launcher`. Preserve every XAX entry except replacing the
   manifest; append the linked resources. Include `docs/THIRD_PARTY.md` as
   `META-INF/ppe/THIRD_PARTY.md` and each `docs/licenses/*.md` under
   `META-INF/ppe/licenses/`. Write entries stored, date 1980-01-01, Unix mode 100644;
   preserve original XAX/resource entry order and sort license names.
4. Align using build-tools 37.0.0 `zipalign -P 16 -f 4`, then sign using the pinned
   SDK fixture with `sign_apk_v2` for the exact development artifact. Verify v2
   signature, alignment, retained entry equality and installed APK hash. Use a
   private signing capability for a release. No release was published by this task.

DexKit bytes come from the exact Maven artifacts in `dexkit.artifacts` in the lock.
Extract `classes.jar` from DexKit and cxx AARs. Run D8 37.0.0 outside the repo with
`--min-api 33 --lib android-37.0/android.jar`, in order: DexKit classes, FlatBuffers,
cxx classes (empty), Kotlin stdlib, stdlib-common, annotations. Its classes.dex must
match the committed dependency DEX. Extract ARM64 `libdexkit.so` unchanged from
the DexKit AAR. Do not compile upstream conventional source inside this project.
Dependencies and their source/notice links are in [THIRD_PARTY.md](THIRD_PARTY.md).

`libppepolicy.so` is ET_EXEC and runs through stdio. `libdexkit.so` is ET_DYN JNI
and is loaded by absolute module-library path. These are different boundaries.
Current BBC uses BFX format 2 (END FF, no count); the retained policy is format 1.
Updating the BBC checkout does not migrate the validated policy automatically.

Current external tools on the original machine: `D:/Codex/ppe-profile-20261029/`
contains `build-candidate.py`, `test-profile.py`, `test-reclaim.py`, `test-progress.py`,
`test-direct.py`, `test-router.py`, `device-check.py` and canonical construction
transport. The module builds directly from XAX; D8 is used only for third-party
dependency bytecode. Host fixtures do not prove Google cloud behavior on 7.98.

## Historical instructions (through 1.2.1; use policy_sdk for old pins)

# Reproducing a build

## Reclaim development build (1.2.1-dev / 27)

Start with the [portable handoff](RECLAIM_HANDOFF.md). The canonical module and both APKs
include native SDK reupload and persistent seven-step/byte progress. Current roots,
hashes and API 102 checks are in [build-1.2.1.json](../report/build-1.2.1.json).
Use versionCode **27**, versionName **1.2.1-dev**. The signed APK uses the public fixture key.

External original-machine transport lives in `D:/Codex/ppe-reclaim-20261029/`: `edit.py`,
`direct-upload.py`, `progress.py`, `build-candidate.py`, `test-candidate.py`,
`test-progress.py`, `test-direct.py`, `test-router.py`, `final-device.py`. The edit transport
loaded the baseline graph, constructed and fully verified the canonical store, checked
carrier roundtrip equality, then saved atomically with `Workspace.save`. No current
native XAX-MCP transaction edit is claimed for this historical Android graph.

Keep transport, carriers, host fixtures and all conventional tooling outside the repo,
including ignored files. XAX and Brainfuck remain authoritative; router functions,
Brainfuck policy, native executable and SDK lock are unchanged. See the
[audit](../report/reclaim-audit-1.2.1.json), [repair/device report](../report/reclaim-1.2.1.md)
and [compiled progress checks](../report/reclaim-progress-offline-1.2.1.json).
Older reports retain their dated scope. General reproduction follows below.

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
5. Sign externally with a chosen capability. The committed signed APK uses
   the SDK's **public fixture test key**; the [release workflow](../.github/workflows/release.yml)
   re-signs it with the release key on a `v*` tag, publishes the GitHub release and
   mirrors it to the Xposed Modules Repository. Verify with Android apksigner v2 checks.
6. Compare roots/hashes with [build evidence](../report/build-1.0.0.json), then
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
