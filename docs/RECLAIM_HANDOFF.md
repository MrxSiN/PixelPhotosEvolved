# Reclaim cross-machine handoff

Development build: **1.1.0-dev / 25**. Read
[the implementation and acceptance report](../report/reclaim-1.1.0.md) and
[feature documentation](VIDEO_BOOST_RECLAIM.md) before continuing.

## What is committed

The authoritative implementation is `module/pixel_photos_module.xax`, with
module root `9602b4fff270db1b05c7a10c6ccf2c52f93d8f92b3885520eae133d030a44277`.
It contains 140 functions, including 35 new Reclaim routines. The
[semantic symbol index](../report/reclaim-symbols-1.1.0.json) maps the construction
aliases to canonical function identities for this exact root. Aliases are
navigation metadata, not another source language; re-exporting a store can
renumber generic `fN` handles. Query the canonical graph by the recorded CID.

Both development APKs, unchanged policy inputs, build/test evidence and native
light/dark screenshots are included. `SHA256SUMS` covers the shipped files.
The signed APK uses the public development fixture key, not a release key.

## Starting on another machine

1. Clone or pull PPE, XAX, BBC and XAX-MCP from the owner's GitHub repositories.
   The implementation is on PPE's `main` branch; the other three needed no
   implementation changes. The inspected revisions are in the acceptance report.
2. Verify `SHA256SUMS` and the build report. Keep authored application code in
   canonical XAX and Brainfuck. Do not add other programming-language sources,
   runtime helpers or disguised executable metadata to these repositories.
3. Obtain the historical XAX SDK revision
   `0876b591f39908e98aa31f746ae2e26bb88c837e` from XAX Git history into an external
   tooling directory. Validate every file listed in `toolchain.lock.json`.
   Current XAX/XAX-MCP does not replace this historical Android/libxposed profile.
4. Follow [REPRODUCE.md](REPRODUCE.md) to load/verify the canonical stores, rebuild
   the unchanged ARM64 policy executable and direct XAX APK, package the existing
   resources, align the APK and sign it. Conventional host tooling stays outside
   the repositories. The compiler emits DEX directly; no Java/Kotlin application
   source or Gradle/D8 project is required.
5. ADB tests require a separately connected intended device. The tested device
   ran Photos `7.97.0.1000520730 / 52549361`, Android API 37, ARM64, and Vector
   API 102. Select the device explicitly and preserve accounts, settings and media.

The absolute `D:/Codex/...` paths in reproduction notes and evidence identify
tools used on the original machine. Those temporary edit/build/test drivers,
private logs, UI dumps and installed-APK backups are **not in Git**. They are
not required runtime components or authoritative application sources. Recreate
external transport/tests with the pinned SDK when needed; do not assume those
paths exist on the next machine. Evidence JSON describes its dated test run;
the source audit's `github_push_or_release: false` describes the pre-handoff run.

## Where to continue

The native page, account-scoped **cached cloud** scan, review selection, sorting,
filters, cancellation and navigation work. This is not a complete fresh cloud
scan. It found four cached processed candidates during device validation; those
counts and charges must not be treated as current server state on another device.

The next investigation is a validated Android-side authenticated interface for
fresh cloud enumeration, quota metadata, full-quality download and controlled
ordinary-backup scheduling. The feature document records the verified cache
schema and native account lookup. Google Photos Toolkit was inspected only as
a reference; its browser RPCs/authentication are not bound into PPE.

Before enabling mutation, perform the specified **non-destructive single-video
upload experiment**, prove a full-quality independently manageable zero-charge
replacement, and resolve deduplication, account binding and relationship safety.
Then add and test journaling/recovery and source-specific Trash/restore. Until
that proof exists, keep **Reclaim selected** disabled and preserve every original.
No replacement upload, Trash operation or actual quota recovery has been verified.
