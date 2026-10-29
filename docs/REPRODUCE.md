# Release 1.1.0 / 36

The 1.5.0-dev carrier from the steps below is passed through `release.py IN OUT 1.5.0-dev 1.1.0`. This
replaces the in-app version text and the manifest versionName. It is then built with
`build.py OUT out 1.1.0`. The release workflow requires the tag to equal `v` plus the APK versionName.
Root and hashes are in [build-1.1.0.json](../report/build-1.1.0.json).

## 1.5.0-dev / 36

1.4.1 plus three steps:
- `ui135.py`: localization;
- `ui136.py`: device optimizations, and sets versionCode 36;
- `ui137.py`: the Restart now prompt.

The run order is `port798.py` → `ui130.py` → `ui132.py` → `ui133.py` → `ui134.py` → `ui135.py` →
`ui136.py` → `ui137.py` → `build.py`. The cold-start A/B rebuilt 1.4.1 unchanged as versionCode 35
(`abbench.py`).

`ui135.py` uses `i18nscan.py` to find user-visible string constants and the translation table
`i18n_tr.py`. It writes `module/res/values/ui_strings.xml` and `module/res/values-*/strings.xml`
(pass `module/res` as its third argument). Root and hashes are in
[build-1.5.0.json](../report/build-1.5.0.json).

## 1.4.1-dev / 33

1.4.0 with three more DexKit rules (no pinned classes left) and the new Reclaim screens
(`ui134.py`). `dexparse.py` now decodes DEX strings as modified UTF-8. `derive.py` adds a last-resort
anchor: a NUL-free piece of a non-printable string, matched with `Contains`. `rules2str.py` ships
it as a JSON literal. The rules are [dexkit-rules-1.4.1.json](../report/dexkit-rules-1.4.1.json).
The run order is `port798.py` → `ui130.py` → `ui132.py` → `ui133.py` → `ui134.py` → `build.py`.
Root and hashes are in [build-1.4.1.json](../report/build-1.4.1.json).

## 1.4.0-dev / 32

1.3.2 plus `ui133.py` (DexKit symbol resolution). Rules come from `derive.py`, run against the
7.97 and 7.98 DEX models (`dexparse.py`), and are encoded by `rules2str.py`. The committed copy
is `dexkit-rules-1.4.0.json` (superseded by 1.4.1). The run order is
`port798.py` → `ui130.py` → `ui132.py` → `ui133.py` → `build.py`. `callcheck.py` verifies
`call.direct` types before building. Root and hashes are in
[build-1.4.0.json](../report/build-1.4.0.json).

## 1.3.2-dev / 31

Same as 1.3.1, with `ui132.py` in place of `ui131.py`. It is `ui131.py` plus the cuts: it
drops the header back button and its wiring with renumbering, and removes functions that are
no longer reachable. Root and hashes are in [build-1.3.2.json](../report/build-1.3.2.json).

## 1.3.1-dev / 30

1.3.0 plus `ui131.py`, which applies the UI edits with `jb.py`. `jb.py` is a small builder
that emits carrier blocks with automatic JVM checkcasts, and new functions are placed callees
first. The run order is `port798.py` → `ui130.py` → `ui131.py` → `build.py`. Root and hashes
are in [build-1.3.1.json](../report/build-1.3.1.json).

## 1.3.0-dev / 29

Same XAX pin, inputs and packaging as 1.2.2 below; only the canonical module changed
(root in [build-1.3.0.json](../report/build-1.3.0.json)). The 1.2.2 store, raw APK and
signed APK were first rebuilt bit-for-bit as a toolchain check. The external transport is in
`D:/Codex/ppe-798-20261029/tools/`: `dexparse.py`, `match.py`, `mapall.py`, `verify.py`,
`chain.py` (7.97→7.98 symbol mapping), `port798.py` (constant retarget), `ui130.py`
(UI edits), `staticcheck.py` (lookup replay against a dex model) and `build.py`
(construct → build → aapt2 → notices → zipalign → fixture sign). The symbol map is
committed as [symbols-7.98-1.3.0.json](../report/symbols-7.98-1.3.0.json).
Use versionCode **29**, versionName **1.3.0-dev**.

## 1.2.2-dev / 28

The current module uses XAX **054262b0af4b40d45b61feafa07612cf87708e7d**.
Extract that exact Git revision outside this repository, and validate every file
under `module_sdk.files` in [toolchain.lock.json](../toolchain.lock.json).
The policy executable is built by current BBC; see "Policy executable" below.
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

## Policy executable (Brainfuck, current BBC)

The policy source is `policy/pixel_photos_policy.bf`. Build it with BBC at the revision in
[toolchain.lock.json](../toolchain.lock.json) (`bbc`), from the BBC checkout:

```text
build\bbc.exe compile android-arm64 -O1 ppepolicy < pixel_photos_policy.bf
build\bbc.exe emit-bfx -O1 < pixel_photos_policy.bf > pixel_photos_policy.bfx
```

`ppepolicy` is `module/libppepolicy.so`, a static ARM64 stdio executable (not JNI).
`ppepolicy.xax` is BBC's verified XAX build snapshot, kept as `policy/pixel_photos_policy.xax`.
The BFX is format 2 (`-O1` fold). The stdio ABI is unchanged ([ABI](../policy/ABI.md)). On the
device, 21,480 input vectors give byte-identical output to the retired BFX-1 executable.
The module build takes the executable by its BLAKE3 digest.

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
