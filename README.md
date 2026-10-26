# Pixel Photos Evolved

Google Photos Xposed module written in **canonical XAX and compiled Brainfuck**.
Current development build: **0.6.5-dev / versionCode 22**, ARM64, libxposed API 102.

The module applies the Pixel XL (2016) backup baseline at Photos startup and
uses the real device identity for verified temporary Video Boost uploads.
Both completed boosted outputs in the disabled/enabled comparison decoded fully
on-device. Per-item quota records confirmed:

| Module | Original video | Boosted result |
|---|---|---|
| Disabled | Charged | Charged |
| Enabled | Uncharged | Charged |

These results cover two recordings on the tested account/build. Capture-time
module states were identified by the user; quota records and full output decoding
were independently checked. Original quality for the enabled original was
reported by the user. This is not a general unlimited-storage guarantee.
See the [independent validation](report/INDEPENDENT_VALIDATION_0.6.1.md).

## Install

Install [the development APK](module/pixel_photos_module-signed.apk), enable it
in Vector for `com.google.android.apps.photos`, then force-stop and reopen Photos.
Open Photos → profile menu → **Pixel Photos Evolved**. Settings live inside
Photos; there is no launcher or separate settings Activity.

Tested: **Pixel 8 Pro**, Android 17 **API 37**, Photos
**7.97.0.1000520730 / 52549361**, Vector **2.2 / 3080 / API 102**.
Hooks are version pinned. Native Video Boost routing additionally requires the
captured Pixel 8 Pro profile. Unknown combinations retain native behavior.
The APK uses XAX's **public fixture test key** and is for local development.

## Behavior and limits

- Pixel XL identity is applied once per Photos process. Upload routing never
  toggles global Build values; SDK/release and existing feature flags are retained.
- Temporary Video Boost routing requires Photos' BLANFORD hint, trusted media
  metadata, strict VB-02.MAIN grammar and actual compiled Brainfuck approval.
  Native headers and immutable client identity stay scoped to that operation.
- Manual per-recording and automatic backup paths were tested. Completed boosted
  outputs were AV1, 2160×3840, with clean decoder end-of-stream.
- Media is never renamed, rewritten, re-encoded or deleted by the module.
  Google decides service eligibility and storage accounting.
- Restart Photos after code or startup-identity changes. Hot reload is unsupported.
  Account-meter reconciliation, downloaded-original byte comparison, HEIC, and
  live simultaneous ordinary/Boost uploads remain untested.

## Repository

| Location | Contents |
|---|---|
| [module/](module/) | Canonical 69-function module, policy process host, current signed/unsigned APKs and exact ARM64 executable input |
| [policy/](policy/) | Authored Brainfuck, BBC BFX output, canonical imported policy and ABI |
| [docs/](docs/) | Installation, Video Boost behavior, reproduction, evidence index, pins and attribution |
| [report/](report/) | Current machine evidence, status and independent validation; necessary older checks under baseline/ |
| [toolchain.lock.json](toolchain.lock.json) | Exact compiler/reference hashes |
| [SHA256SUMS](SHA256SUMS) | Every other retained file's checksum |

Only Brainfuck and canonical XAX are source code here, including ignored paths.
Compiler, edit, build and test tooling stays outside the repository. Both APKs
are retained deliberately: one installs, the other supports exact rebuild checks.
The `.so` is an extracted **stdio executable**, not a JNI library.

Read [installation](docs/INSTALLATION_AND_TROUBLESHOOTING.md),
[Video Boost](docs/VIDEO_BOOST.md), [status](report/STATUS.md),
[evidence](docs/EVIDENCE.md), [reproduction](docs/REPRODUCE.md),
[pins](docs/REFERENCE_PINS.md), [policy ABI](policy/ABI.md) and
[attribution](docs/ATTRIBUTION.md).
