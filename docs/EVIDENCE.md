# Evidence index

Current development build: **1.2.0-dev / 26**, checked 28 October 2026. It implements
automatic selected-video download, protection, source-only permanent deletion and ordinary
reupload, with native backup and zero-charge completion checks. Scan results and selections
use logical content identity. Reuploaded videos lose their Video Boost processing flag.
The [current report](../report/reclaim-1.2.0.md) distinguishes final UI checks, a temporary
development artifact's automatic dummy transaction and retained older backend evidence.

## Current build

The [automatic native dummy transaction](../report/reclaim-automatic-device-1.2.0.json)
completed with zero cached charge; the published 4K AV1 file matches the protected copy's
SHA-256. It began with
an ordinary zero-charge dummy after the [earlier charged-dummy UI experiment](../report/reclaim-dummy-20261028.md).
The final artifact removes the development entry and was separately checked for scan,
selection, enabled action, confirmation notices, preserved settings and artifact identity.

| Report | What it establishes |
|---|---|
| [Automatic reclaim report](../report/reclaim-1.2.0.md) | Final implementation, native boundaries, tests and limitations |
| [Build 1.2.0](../report/build-1.2.0.json) | Final root, artifact hashes and Vector API 102 check |
| [Source audit 1.2.0](../report/reclaim-audit-1.2.0.json) | Verified canonical source, removed test controls, read-only SQL surface, unchanged router/policy |
| [Compiled reclaim 1.2.0](../report/reclaim-offline-1.2.0.json) | 225 actual compiled classification, sort/filter and logical-selection checks |
| [Router 1.2.0](../report/router-offline-1.2.0.json) | 60 compiled invariants and 400 concurrent host operations |
| [Automatic dummy 1.2.0](../report/reclaim-automatic-device-1.2.0.json) | Native transaction, restart recovery, exact SHA-256, full decoding and zero cached charge; temporary test artifact |
| [Final device 1.2.0](../report/reclaim-final-device-1.2.0.json) | Exact installed final APK, unique rows, button state, notices, navigation and settings |
| [Earlier Reclaim acceptance report](../report/reclaim-1.1.0.md) | Actual implementation, modified files, blocked stages and requirement checklist |
| [Build 1.1.0](../report/build-1.1.0.json) | Verified canonical root, development artifact hashes, unchanged pinned SDK, API 102 check |
| [Reclaim source/safety audit](../report/reclaim-audit-1.1.0.json) | Baseline-root check, atomic canonical save, unchanged routing/policy, read-only SQL, no mutation bindings |
| [Reclaim compiled checks](../report/reclaim-offline-1.1.0.json) | 224 actual JVM classification, comparator, filter and identity-selection checks; host fixtures |
| [Current router checks](../report/router-offline-1.1.0.json) | 60 compiled invariants and 400 concurrent host operations |
| [Current regression checks](../report/regression-1.1.0.json) | 18,187 BF vectors, 14 filename vectors and eight compatibility vectors; tested subjects unchanged in final build |
| [Fresh policy device vectors](../report/policy-device-1.1.0.json) | 128 executed vectors on the exact packaged ARM64 stdio executable |
| [Fresh BBC reproduction](../report/bbc-1.1.0.json) | Byte-identical 3,279-instruction BFX from pinned BBC frontend |
| [Reclaim device UI](../report/reclaim-device-1.1.0.json) | Real cache scan and selection/sort/filter/cancel/back checks; exact tested development artifact provenance |
| [Final installed build](../report/reclaim-final-device-1.1.0.json) | Final artifact match, cache/UI smoke, account observer normal path, themes, settings and startup probes |
| [Build 1.0.0](../report/build-1.0.0.json) | Release version and package, artifact hashes, on-device load check, 0.6.3-0.6.6 change history |
| [Storage Saver sweep](../report/storage-saver-0.6.5.json) | All eight profiles applied on-device; probe result per model; Pixel 5a ineligible per Photos |
| [Settings 0.6.5](../report/settings-0.6.5.json) | Photos type scale, new sections, exclusive switches, model picker, transitions |
| [Settings 0.6.4](../report/settings-0.6.4.json) | Segmented tiles, diagnostics values, Back from both pages, row-tap persistence, light/dark, App info icon and label |
| [Settings 0.6.3](../report/settings-0.6.3.json) | Own profile card, distinct icon, rewritten copy, Back/reopen, persistence, light/dark and 1.3 font scale |
| [Build 0.6.1](../report/build-0.6.1.json) | 0.6.1 canonical roots and artifact hashes, Vector API check, v2 signing, exact unsigned rebuild and installed artifact match |
| [Offline](../report/offline-0.6.1.json) | Actual compiled classifier 14, runtime gate 8, native state decoder 10 and labels 10; JVM verification |
| [Router](../report/router-offline-0.6.1.json) | 60 invariants and 400 concurrent host operations; ordinary pass-through, request copies, queue isolation, settings, retry identity and token isolation |
| [Semantic edit](../report/semantic-edit-0.6.1.json) | Verified canonical graph/root, 69 functions, source hash and atomic carrier-edit workflow |
| [Settings](../report/settings-0.6.1.json) | Combined routing control, persisted switches, status, Back/reopen and one profile entry |
| [Manual native upload](../report/video-boost-0.6.1.json) | New genuine raw upload, remote format 1, native routing stages, unchanged original hashes/sizes/mtimes, ordinary JPEG control |
| [Automatic backup](../report/automatic-backup-0.6.1.json) | User-confirmed fresh recording uploaded automatically with native routing; cover/JPEG completed; native backup on and queue complete |
| [Independent completion/quota](../report/independent-validation-0.6.1.json) | Four selected remote records and full native decoding of both completed 4K AV1 boosted outputs |

The [independent validation narrative](../report/INDEPENDENT_VALIDATION_0.6.1.md)
contains the exact quota values and decoding results. The user identified which
capture used each module state; the agent independently read the resulting
per-item quota records and decoded both outputs. Original quality UI labeling
was user-reported. No account-wide quota entitlement is inferred.

The upload reports describe their own earlier checkpoints. Their Processing
observations and unverified-output fields remain valid snapshots of those tests;
the independent report supplies the later completion evidence.

## Retained baseline checks

These files are from **0.4.0 / 15**, not the current APK. The policy/helper hashes
still match current inputs. UI/editor results are historical and were not rerun.

| Baseline report | Retained reason |
|---|---|
| [BBC](../report/baseline/bbc-0.4.0.json) | Fresh bounded BBC compilation exactly matched current BFX |
| [Policy vectors](../report/baseline/offline-0.4.0.json) | 18,187 independent BF vectors and authored policy hash |
| [ARM64 vectors](../report/baseline/device-policy-0.4.0.json) | 128 vectors on the identical packaged stdio executable |
| [Device/editor/UI](../report/baseline/device-0.4.0.json) | Controls, native editing saves, original preservation, themes and rotation; its old Boost limits are historical |
| [Ordinary uploads](../report/baseline/uploads-0.4.0.json) | Generated JPEG/MP4 remote records, quality UI and per-item quota checks |

Obsolete builds, redundant narratives, old screenshots and superseded user-only
validation notes were removed. The latest independent validation incorporates
the user's capture identification while keeping agent-observed results separate.

## Integrity and privacy

[SHA256SUMS](../SHA256SUMS) covers every other retained file. Rebuild instructions
are in [REPRODUCE.md](REPRODUCE.md). Reports omit personal filenames, paths,
media fingerprints, accounts, authentication data, upload tokens, keys and service
URLs. Generated fixture names/hashes and public artifact hashes are retained.
