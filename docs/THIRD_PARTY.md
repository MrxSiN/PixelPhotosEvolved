# Bundled third-party dependencies (1.2.2-dev)

PPE application logic is canonical XAX and Brainfuck. Precompiled third-party
DEX and native libraries are dependency inputs, kept separate from authored source.
The lock records exact upstream artifacts and the compiled DEX/native SHA-256.

| Dependency | Copyright / terms | Source and use |
|---|---|---|
| DexKit 2.3.0 | Copyright 2022-2023 LuckyPray; root Apache-2.0 notice and Core LGPL-3.0 notice retained below; API file headers specify LGPL-3.0-or-later; published POM declares LGPL-3.0 and Apache-2.0 | [Release source](https://github.com/LuckyPray/DexKit/tree/2.3.0), [source JAR](https://repo.maven.apache.org/maven2/org/luckypray/dexkit/2.3.0/dexkit-2.3.0-sources.jar). Unmodified upstream ARM64 JNI and API classes; readonly method/state discovery. This does not relicense the entire dependency as Apache-2.0. |
| FlatBuffers Java 23.5.26 | Copyright Google Inc.; Apache-2.0 | [Source](https://github.com/google/flatbuffers/tree/v23.5.26/java); required by DexKit queries |
| Kotlin stdlib/common 1.5.0 | Copyright JetBrains s.r.o. and Kotlin contributors; Apache-2.0 | [Source](https://github.com/JetBrains/kotlin/tree/v1.5.0/libraries/stdlib); dependency runtime only |
| JetBrains annotations 13.0 | Copyright JetBrains s.r.o.; Apache-2.0 | [Published source JAR](https://repo.maven.apache.org/maven2/org/jetbrains/annotations/13.0/annotations-13.0-sources.jar); dependency bytecode |
| Rikka cxx 1.2.0 / LLVM libc++ | LLVM contributors; libc++ Apache-2.0 with LLVM exceptions and legacy notices retained | [cxx source](https://github.com/RikkaW/libcxx-prefab), [libc++ notices](https://github.com/llvm/llvm-project/blob/llvmorg-17.0.0/libcxx/LICENSE.TXT). Upstream native build dependency; no separate cxx shared library is packaged. |

License copies: [Apache 2.0](licenses/Apache-2.0.md),
[LGPL 3.0](licenses/LGPL-3.0.md), [GPL 3.0](licenses/GPL-3.0.md),
[DexKit root notice](licenses/DexKit-Root-2.3.0.md),
[DexKit Core notice](licenses/DexKit-Core-2.3.0.md),
[libc++ notices](licenses/LLVM-libcxx.md).
The same texts and this notice are included under `META-INF/ppe/` in the signed APK.
The dependency DEX combines the unmodified published Java bytecode using Android
D8; the JNI shared object is extracted unchanged from the published AAR.
To replace dependencies, use the explicit digest inputs described in
[REPRODUCE.md](REPRODUCE.md), rebuild the canonical target with the new digests,
then package and sign with your own key. The development fixture key is public.
No release or upstream licensing clearance is asserted by this local build.
See [ATTRIBUTION.md](ATTRIBUTION.md) for the existing XAX policy-host boundary.
