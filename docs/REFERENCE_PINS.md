# Pinned references

| Component | Exact pin | Use |
|---|---|---|
| Google Photos Toolkit research | `6db9ab355e4797327e4078cf87a2b6994d36cf73` | Web enumeration/metadata identity and quota concepts inspected for Reclaim; no code or browser authentication copied; Android cache access independently verified |
| Current XAX module SDK | `054262b0af4b40d45b61feafa07612cf87708e7d` | 1.2.2 compile and canonical roundtrip; `module_sdk` file hashes |
| Historical XAX policy/construction SDK | `0876b591f39908e98aa31f746ae2e26bb88c837e` | Frozen policy producer / initial construction; `policy_sdk` hashes |
| DexKit 2.3.0 | tag `2.3.0`, `c9cd12a14b75409bebd2f73e4dfc5ff575df3eb8` | Published AAR/JNI plus D8 dependency DEX; exact artifact hashes in lock |
| BBC checkout | `53783953fd87cbc9308b108d187b7f3fcfedc06d` | Updated 2026-10-29; format-2 frontend not substituted for frozen policy |
| XAX-MCP checkout | `27ffb9491bfe69000b3ce9744b2b689a4d594a3e` | Already current; immutable embedded XAX af376e8 pin unchanged; not used for this Android edit |
| BBC | `compiler/compiler.bf`, SHA-256 `89e87c42d870e879c4dbbf2ec578da2823351566d3e7d25801f29b5804446b2a` | Reproducible bounded BF → BFX frontend; historical producer pin; current Git checkout recorded separately |
| XAX BFX importer | entry `cbbd3d0c7dcc26908b6b967d8792b2dbc7c4cda8d3180276588ae04a8e1c50b5` | Historical BFX → canonical decision import |
| Vector | v2.2 / 3080, `88f8e1faa8b4e7ce20aefabe9c295cd746ea038e` | Actual device runtime, API 102 |
| libxposed API | `io.github.libxposed:api:102.0.0`, revision `39cac0845771547c9c67a3e3ce255af110a54a0e` | API table validation; no legacy module API |
| libxposed AAR | SHA-256 `423484a6e1807e7a423c4b88fcd8176d104318259d91791877fed88fe91479d0` | Pinned upstream API surface |
| Android SDK | platform `android-37.0`, build-tools `37.0.0` | Packaging target and official signature/manifest inspection |
| Pixelify Infinity | `c4094f597ad6f8e0eab3a3653c4108279470cf62` | DeviceProps, DeviceSpoofer, FeatureSpoofer, diagnostics and MIT attribution reference; no implementation copied |
| YouTubeHideAds | `8d059533c1ba12c27db46abb1eba9901a05df02d` | Canonical source/build organization, JNI boundary, policy ABI and test architecture reference; GPL implementation not copied |

All four required references were inspected. Current module builds use the current XAX
pin above; historical policy builds retain the older pin, verified against [toolchain.lock.json](../toolchain.lock.json),
rather than a different or dirty local working tree. The BBC frontend and
importer pins are unchanged from the validated policy baseline. The newer BBC
CLI was inspected but is not substituted for this reproducible pipeline.
The policy host is an executable, not a JNI library.

Reference repositories: [Pixelify Infinity](https://github.com/samson910022/pixelify-google-photos-modern),
[YouTubeHideAds](https://github.com/MrxSiN/YouTubeHideAds),
[BBC](https://github.com/MrxSiN/BBC), [XAX](https://github.com/MrxSiN/XAX).

## Pixel XL reference data

The current baseline applies these verified reference values at process startup:
BRAND google; MANUFACTURER Google; DEVICE/PRODUCT/BOARD/HARDWARE marlin;
MODEL Pixel XL; ID QP1A.191005.007.A3; INCREMENTAL 5972272;
SECURITY_PATCH 2019-12-05; TYPE user; TAGS release-keys;
FINGERPRINT `google/marlin/marlin:10/QP1A.191005.007.A3/5972272:user/release-keys`.
The runtime Android release and SDK are preserved. Five 2016 features are added
without removing native flags. Process-wide identity can still influence
capability decisions, so preserving flags alone does not prove editing works.

## Device and host

Pixel 8 Pro / Android 17 API 37, build
`google/husky/husky:17/CP3A.261005.005/16271449:user/release-keys`,
Photos 7.97.0.1000520730 / 52549361 for retained backend evidence;
Photos 7.98.0.1007591100 / 52591217 for 1.2.2 UI/DexKit checks. Vector v2.2 / 3080.
The build is observed; a specific QPR designation was not independently checked.
Windows host: Python 3.13, JDK 17, SDK at `C:/Android/Sdk`.
ADB is resolved from PATH. No conventional-language source or SDK copy is kept
inside this project.

The current module root and artifact hashes are recorded in
[build-1.2.2.json](../report/build-1.2.2.json). Installation support and limits
are in [installation](INSTALLATION_AND_TROUBLESHOOTING.md); reproducible build
steps are in [REPRODUCE.md](REPRODUCE.md). Reference pins record what was used,
not an assertion that those external projects are currently at these revisions.
