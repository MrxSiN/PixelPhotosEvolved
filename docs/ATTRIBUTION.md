# Attribution and dependency boundaries

Google Photos Toolkit, xob0t/Google-Photos-Toolkit, revision
6db9ab355e4797327e4078cf87a2b6994d36cf73, was inspected for paginated web RPCs,
media/deduplication identity, extended metadata, quota and physical size parsing.
It is MIT licensed, copyright (c) 2024 xob0t. No implementation or authentication
code was copied or bundled. Its browser RPCs are not used by PPE; the Android
preview independently reads Photos' existing account-scoped metadata cache.

Pixelify Infinity, samson910022/pixelify-google-photos-modern, revision
c4094f597ad6f8e0eab3a3653c4108279470cf62, was inspected for device profiles,
feature checks, Android 17 compatibility and backup verification. Its MIT notice
credits BaltiApps (2021) and samson910022 (2026). No implementation was copied.

YouTubeHideAds, MrxSiN/YouTubeHideAds, revision
8d059533c1ba12c27db46abb1eba9901a05df02d, was inspected for XAX/BF/API 102
architecture. Its GPL implementation was not copied.

BBC is an external compiler. The pinned compiler/compiler.bf carries an MIT
notice, copyright 2026 BrainfuckCC contributors. Policy binaries are compiler outputs.

The policy process host was adapted from XAX's integration fixture
compiler/integration/bfx/standalone_arm64.xax by binding the compiled decision
through an expected-root semantic edit. This host is derived material. The
inspected XAX checkout did not provide an identified root license, so upstream
redistribution terms remain unresolved. This project's LICENSE does not relicense
upstream XAX material. Release APKs are published on GitHub and mirrored to the
Xposed Modules Repository. XAX, Android, Vector and libxposed have separate dependency terms.

Exact reference and toolchain pins are in [REFERENCE_PINS.md](REFERENCE_PINS.md)
and [toolchain.lock.json](../toolchain.lock.json). The repository's
[LICENSE](../LICENSE) is retained unchanged. Cleanup of obsolete development
reports does not change these attribution or upstream licensing boundaries.

Bundled DexKit 2.3.0, FlatBuffers, Kotlin runtime, annotations and native dependency
notices are recorded in [THIRD_PARTY.md](THIRD_PARTY.md), with full license copies.
The application remains XAX/Brainfuck; upstream conventional source stays external.
