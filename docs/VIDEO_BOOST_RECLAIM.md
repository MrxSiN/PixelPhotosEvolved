# Video Boost Storage Reclaim — development preview

Version **1.1.0-dev / 25** adds a working, read-only **cached cloud record audit**.
The requested automatic reclaim workflow is **not complete**. Full server-side
library scanning, downloads, replacement uploads and Trash operations are disabled.
No storage recovery is claimed.

Open Photos → profile picture → Pixel Photos Evolved → Video Boost →
**Video Boost Storage Reclaim**. This replaces **Latest video**. The last observed
native processing state remains below the new page's capability explanation.
Existing backup settings and temporary Video Boost routing are unchanged.

## Using the preview

1. Press **Scan for boosted videos**. The page explicitly explains that it reads
   Photos' existing account-scoped cloud metadata cache; it does not refresh the
   complete cloud library. Opening the page starts no media scan.
2. Review the cached processed candidates. Rows show the stored filename,
   capture time, duration in milliseconds, dimensions, physical file size and
   cached charged storage separately. Missing dimensions/duration show Unknown.
3. Check chargeable candidates for review. The summary shows selected count
   and their **cached charge**, not promised recoverable storage.
4. Use the three-dot menu to select all, invert or deselect; sort by date, charge
   or filename; filter by positive, zero or unknown cached charge; or rescan.
   Select all/invert cover all completed cached results in the active filter,
   including candidates beyond the current 50-row display page. Deselect all
   clears hidden selections too. Sorting preserves selection by media identity.
5. **Reclaim selected — unavailable** remains disabled regardless of selection.

The list renders at most 50 candidates at once. Previous/Next change the display
page; selection applies to the full result set. Back or closing PPE cancels the
scan and clears review state. Reopening starts with no scan or selection. A cheap
account observer invalidates cached results and selection if the account changes
or account access becomes unavailable while this page is open. It enumerates no
media. No selected item is authorized for an upload or deletion.

## Verified Android access path

The pinned Photos **7.97.0.1000520730 / 52549361**, Android **API 37**, ARM64
compatibility gate runs before reading metadata. Within the Photos process,
reflection resolves its existing `cdmo.a(Context).h(Class,Object)` service scope
and `noz.i():int` active account lookup. Pinned DEX inspection established that
Photos names its databases `gphotos` + internal account number + `.db`.
The module opens the corresponding existing database through Android
`SQLiteDatabase.openDatabase` with **OPEN_READONLY**. It creates no database and
does not modify Photos' schema or cache.

Enumeration uses `remote_media`, ordered by its numeric primary key, in keyset
pages of 200 rows. It does **not** reuse the 500-row local MediaStore diagnostic
scan. Cloud metadata rows do not require a local file or MediaStore match.
The worker checks account identity and cancellation between pages, closes its
cursors/database on normal completion and handled failures, deduplicates candidate
media keys, and bounds retained candidates to 2,000 (checked after each page,
so one page can exceed that threshold). Reaching the bound reports an incomplete
scan. UI publication is separated from worker mutation; a page generation check
discards completion from a page that has been closed/reopened.

This is **cache enumeration**, not authenticated network pagination. It cannot
establish full library coverage, current server state, network availability,
current ownership, download accessibility, or deletion independence. The scan
timestamp is when PPE inspected the cache, not the cache's server freshness.
The cache may be populated or changed by Photos while PPE is scanning; this is
not a transactionally frozen full-library snapshot. There are no network retries,
rate-limit claims, cached transaction journals or automatic restart/resume.

## Classification and storage accounting

Cached review candidates require all of:

- Photos' native `blanford_format = 2` (processed output), video type `2`;
- active media state `0`, upload status `100`, playable video flag `1`;
- no partial backup, hidden or shared flags;
- nonempty cloud media key, deduplication key and filename.

Only a known positive `quota_charged_bytes` permits review selection. Explicit
zero-charge records can be displayed with the zero-charge filter and cannot be
selected. NULL or negative quota is unknown and cannot be selected. Ordinary
videos, cover/raw formats, pending/non-active records and missing identity fail
closed. Filenames are display metadata, never completion evidence.

`size_bytes` describes the media file. `quota_charged_bytes` describes the charge
stored by Photos for that record. They are never substituted for one another.
A backup quality label, Pixel model or filename does not establish quota.
Even these strict cached matches are **not automatic reclaim eligibility**:
ownership, live metadata and replacement safety still need fresh verification.

The current Android integration has no verified cloud thumbnail loader or cloud
viewer binding. Such rows explicitly say that thumbnail/preview is unavailable.
For a trusted `content://media/` local URI, the page can offer the normal Photos
viewer; this branch has not been exercised with the detected cloud-cache rows.
No media URLs, cookies or credentials are extracted, requested or exported.

## What blocks automatic reclaim

| Capability | Status |
|---|---|
| Native PPE page and explicit scan | Implemented; device tested |
| Account-scoped cached cloud enumeration / quota parsing | Implemented; device tested |
| Cached native processed-output classification | Implemented; compiled and device tested |
| Review selection / sorting / filters | Implemented; see current device report |
| Complete, freshly authenticated cloud enumeration | Blocked: no validated Android API binding |
| Actual cloud thumbnails and cloud viewer | Blocked: no validated Android binding |
| Original-quality download and integrity verification | Blocked: no validated download binding |
| Controlled ordinary Pixel XL upload of a selected copy | Blocked: no validated scheduling/correlation binding |
| Independent zero-charge replacement / deduplication proof | Blocked: no upload experiment or server proof |
| Source-specific safe Trash / restore | Blocked; no mutation implementation |
| Persistent reclaim journal, batch/retry/reboot recovery | Not implemented; depends on the preceding gates |

The existing Pixel XL identity is process-wide and applied at startup. It is not
a separately verified per-item reclaim upload boundary. Temporary Video Boost
uploads retain their established native identity route. No global identity
toggles, media rewriting, transcoding, token rewriting or new hooks were added.
The existing Brainfuck policy and ABI 1 are unchanged.

Identical reuploads may resolve to the original logical cloud object. Separate
filenames or media keys would not prove safe independent deletion. A successful
upload would not prove zero charge. A future implementation must demonstrate a
full-quality independent replacement, fresh explicit zero quota, correct account,
protected device copies and safe relationships **before** adding source Trash.
There is no evidence for that gate in this preview, so neither Trash nor permanent
deletion is callable. Trash is never emptied. No album/Video Boost relationship
preservation or account-meter reconciliation is claimed.

Cancellation or an error leaves every original untouched. If metadata access
fails, the page reports an incomplete/unavailable scan, never a successful empty
full-cloud scan. Retry starts a fresh cache inspection. Closing/restarting Photos
discards this read-only review state; there is no partial mutation to recover.

## Reference research and evidence

[Google Photos Toolkit](https://github.com/xob0t/Google-Photos-Toolkit/tree/6db9ab355e4797327e4078cf87a2b6994d36cf73)
was inspected at revision `6db9ab355e4797327e4078cf87a2b6994d36cf73`:
`src/api/api.ts` and `src/api/parser.ts`, specifically `EzkLib`, `EWgK9e`,
`fDcn4b`, media/dedup keys and file size versus quota metadata. Its browser RPCs
are not invoked by PPE. No toolkit implementation or authentication code was
copied. See [attribution](ATTRIBUTION.md).

See [implementation and acceptance report](../report/reclaim-1.1.0.md),
[build evidence](../report/build-1.1.0.json),
[compiled checks](../report/reclaim-offline-1.1.0.json) and
[device checks](../report/reclaim-device-1.1.0.json). Device results describe the
cache audit, not Google server refreshes or actual storage recovery.
