# Reclaim implementation and acceptance report

Development preview **1.1.0-dev / 25**, 27 October 2026 (UTC+08:00).

**The requested complete storage-reclaim feature is not finished.** A real
account-scoped cache audit and native review interface are implemented. Fresh
full-cloud scanning and automatic mutations remain blocked. No original was
uploaded, changed, moved to Trash or deleted during these tests.

## Implementation

The canonical module adds native Android UI routines and an asynchronous,
read-only SQLite scanner within the existing Google Photos process. It replaces
Latest video with Video Boost Storage Reclaim and retains the native latest-state
label below the new page. The existing Photos-themed navigation/back stack is
reused. No launcher, WebView, service or new hook was added.

The worker reads Photos' active account through verified pinned native classes,
opens its existing database read-only and keyset-paginates the **remote_media**
table in 200-row pages. This covers cached cloud records independently of local
MediaStore files; it is not a server scan. It classifies native processed format-2
videos with active, uploaded, playable and non-hidden/non-shared state, retaining
positive, zero and unknown quota separately. Only positive cached candidates
with media/dedup identity can be selected for review. A filename alone has no
effect on classification. In particular, a processed cloud output can retain a
VB-02 filename; native format/state must distinguish it from the raw input.

The list displays filename, recorded time, duration, resolution, physical size
and cached quota. A checkbox stores media identity rather than filename or list
position. Select all/invert operate on the active filter's complete cached result
set. Deselect all also clears hidden selections. Date/charge/filename sorting,
zero/positive/unknown filters and explicit rescan are functional. Display pages
contain at most 50 candidates. Candidate retention is bounded and an interrupted,
failed or capped scan is labeled incomplete. Account changes invalidate results
and selections; page generations prevent an old completion repopulating a newly
opened page. Account checks enumerate no media. Review state is process-memory
only; it does not survive closing the page or process restart.

Cloud thumbnails and a cloud viewer have no validated Android binding. Rows
show the capability as unavailable. A trusted local MediaStore URI can offer
the normal Photos viewer, but that branch remains untested with actual candidates.
There is no download handler, reclaim upload scheduler, replacement verifier,
Trash caller, journal or queue. **Reclaim selected** is disabled at all times.

All project implementation remains canonical XAX and Brainfuck. The policy
source/BFX/graph, policy-process graph, ARM64 executable and pinned toolchain
are unchanged. External SDK transport and host test fixtures remain outside
all four repositories. The existing native routing callbacks, operation tokens,
ordinary backup identity and processing protocol are not modified.

## Repository synchronization

| Repository | Checked remote revision | Result |
|---|---|---|
| PPE | `694ebce3741ccdca5602476b785650f07ed65e1a` | Local 0.6.1 snapshot lacked Git metadata; preserved externally, restored tracking and updated to remote 1.0.0 before editing |
| XAX | `af376e8a8a1ac5635bcad459cb7063ef0b326430` | Current, clean; no source changes |
| BBC | `b96dd52752bffd497364d89562bd77eb39f071fc` | Local snapshot lacked Git metadata; preserved externally, restored tracking, current; no source changes |
| XAX-MCP | `27ffb9491bfe69000b3ce9744b2b689a4d594a3e` | Current, clean; no source changes |

The module continues to build with historical SDK pin
`0876b591f39908e98aa31f746ae2e26bb88c837e`, validated against every locked file.
Current XAX/XAX-MCP are not substituted for this Android profile. The original
local directories are preserved under `D:/Codex/ppe-reclaim-20261027/`.

## Validation and limits

- Canonical store verification, carrier roundtrip and Vector API 102 static
  checking pass. Both retained APK inputs are built with the pinned SDK; the
  signed APK adds the existing resources, aligns resources.arsc and uses the
  public development fixture key. See [build hashes](build-1.1.0.json).
- **224 executed compiled JVM checks** cover positive/zero/unknown/negative
  quota, missing identity, ordinary/raw/cover/non-active/partial/unplayable/
  hidden/shared media, extreme long values, five sort modes, comparator ordering,
  filters and identity-based selection. Host fixtures are not cloud tests.
  See [compiled evidence](reclaim-offline-1.1.0.json).
- Existing regressions passed: **18,187 independent Brainfuck vectors**,
  **14 compiled filename checks**, **8 compiled compatibility checks**,
  **60 compiled router invariants** and **400 concurrent host router operations**.
- **128 fresh ARM64 device vectors** passed using the exact unchanged packaged
  policy executable. The pinned BBC frontend freshly reproduced the packaged
  **3,279-instruction BFX** byte for byte.
- A rooted Pixel 8 Pro was controlled with `C:/platform-tools/adb.exe`; Photos
  remained on the pinned build. The module itself requires no root. Existing
  startup policy self-tests, native router setup and Pixel XL backup probe pass.
- The genuine device scan inspected **74,145 cached cloud rows** and found
  **four active processed chargeable candidates**, totaling **528,120,956 cached
  charged bytes**. A separate non-active processed record was excluded. These
  are cache observations, not fresh server quota, guaranteed recovery, ownership
  proof or full-library completeness.
- See [device evidence](reclaim-device-1.1.0.json) for individually executed UI
  checks and their artifact provenance, including selection, sorting, filtering,
  cancellation and navigation. The final installed-build smoke and theme evidence
  are recorded separately in [final device checks](reclaim-final-device-1.1.0.json).

Fresh full-cloud enumeration, cloud thumbnails, download fidelity, actual
re-upload/deduplication, replacement playback/independence, fresh zero quota,
Trash/restore, album/linked-object preservation, live wrong-account injection,
restart/reboot transaction recovery, network retry/rate-limit/error injection,
and simultaneous ordinary/Boost network uploads remain **unverified or blocked**.
The zero/unknown filter UI was exercised on this cache; adversarial zero/unknown
classification data was tested offline. No artificial media was presented as
real account data. Existing Storage Saver profile/network and modern editing
tests were not repeated; earlier dated evidence remains historical.

## Acceptance checklist

| Major requirement | Status |
|---|---|
| Inspect/synchronize four repositories and pinned tools | Implemented and tested |
| Canonical XAX / Brainfuck only, unchanged ABI 1 | Implemented and tested |
| Replace Latest video, native subpage/back/scroll | Implemented and tested |
| Explicit user scan, progress, cancellation and no automatic media scan | Implemented and tested |
| Paginated cached cloud metadata, charge classification | Implemented and tested |
| Historical/cloud-only coverage beyond this cache | Blocked |
| Native processed-state classification | Implemented and tested for cached records; live eligibility blocked |
| Complete fresh server library enumeration and quota | Blocked |
| Real metadata rows and review selection/sorts/filters | Implemented and tested |
| All cloud thumbnails / cloud viewer | Blocked |
| Local viewer fallback | Implemented but untested |
| Live account invalidation observer | Implemented; normal observer exercised, live account-switch/error injection untested |
| Last-scan display and cache/completeness warnings | Implemented and tested |
| Sticky bottom action / complete requested layout | Partially implemented; current disabled action scrolls with page |
| Batch confirmation and processing engine | Not implemented |
| Complete original-quality download and integrity proof | Blocked |
| Controlled ordinary Pixel XL reclaim upload | Blocked |
| Mandatory single-video independent zero-charge replacement experiment | Blocked; not performed |
| Source-specific safe Trash/restore and final revalidation | Blocked; no mutation code |
| Persistent journal, retry, reboot/restart queue recovery | Not implemented |
| No unsafe deletion or claimed quota recovery | Implemented and tested by absence of mutation implementation |
| Build, offline regressions and real device cache/UI checks | Implemented and tested; detailed scope above |
| Documentation, limitations, reference attribution | Implemented |

## Safety gate

There is **no enabled automatic source deletion**. There is no evidence of an
independent zero-charge replacement and no mutation implementation to authorize.
The new feature's only database operations are SELECT queries on a read-only
connection and cursor/database closure. Review checkboxes cannot start an upload
or removal. No cookies, tokens, credentials, cloud URLs or media contents are
exported. Delivered evidence uses aggregate counts, capability states and build
hashes, not account identities or media filenames/keys.

Google Photos Toolkit's web RPCs were inspected as a technical reference, not
assumed usable from Android. The missing pieces require validated native
authenticated interfaces and an actual non-destructive upload experiment.
Different filenames or media keys alone are insufficient. Until independence,
fresh explicit zero charge and source-specific safety are demonstrated, source
Trash remains unavailable. This preview cannot preserve relationships through
a replacement because no replacement is made.

## Changed files

| File | Change |
|---|---|
| `module/pixel_photos_module.xax` | Canonical native page, account-bound read-only scanner, classification/review/selection/sorting/filter/cancel/lifecycle routines |
| `module/pixel_photos_module-unsigned.apk` | Direct pinned XAX build input |
| `module/pixel_photos_module-signed.apk` | Resource-packaged, aligned development-signed installable APK |
| `README.md`, `docs/VIDEO_BOOST.md` | Entry name, preview scope and navigation |
| `docs/VIDEO_BOOST_RECLAIM.md` | Usage, Android access path, accounting and capability limitations |
| `docs/REPRODUCE.md`, `docs/REFERENCE_PINS.md`, `docs/ATTRIBUTION.md` | Reproduction transport, toolkit pin and reference boundary |
| `docs/EVIDENCE.md`, `report/STATUS.md`, this report | Current test scope, acceptance status and remaining work |
| New `report/*1.1.0.json` evidence | Build, source/safety audit, compiled regressions, policy reproduction and device results |
| `docs/screenshots/reclaim-dark.png`, `docs/screenshots/reclaim-light.png` | Metadata-free native page screenshots |
| `SHA256SUMS` | Refreshed checksums for retained deliverables |

No changes are required in XAX, BBC or XAX-MCP for this preview. See the
[cross-machine handoff](../docs/RECLAIM_HANDOFF.md) and semantic symbol index for
continuing from the committed canonical source. No GitHub release or cloud media
mutation was performed.
