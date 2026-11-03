# Library Tools (1.2.0-dev)

Photos profile page → **Pixel Photos Evolved** → **Backup** or **Library Tools**. Backup is the
existing settings page, unchanged. Library Tools has three read-only pages.

All three read the active account's metadata cache that Photos keeps on the phone
(`gphotos<N>.db`, opened read-only) on a background thread. This is **not** a scan of the whole
Google Account, and every page says so. Nothing is written, uploaded or deleted. If Photos' classes
or the cache cannot be resolved, a page says the records are not available.

## Storage Analyzer
Lists only media whose `quota_charged_bytes` is above zero (media that use storage), with totals
per photo, video and other, a count of records with unknown storage, and the number of records
checked. Sort: largest, smallest, newest, oldest. Show: all, photos, videos. First 50 rows.

## Smart Filter
Filters over the same records, combined with AND: type, storage, size, date taken, duration,
resolution, name contains (bound, escaped `LIKE`, case-insensitive) and sort. Size, date, duration
and resolution are presets that cycle on tap. First 50 matches.

## Album Organizer
Lists visible albums (collections of type 1 that are not hidden or soft-deleted) with item count,
private/shared and, for shared albums, whether you own them (linked envelope owner). Opening an
album shows its first 50 items. Per-album counts match Photos' stored `total_items`.

## Not built, on purpose
- Creating albums, adding or removing media: no verified write path in Photos 7.99.
- "Not in any album": a media record holds one `collection_id`, so membership in several albums,
  or in none, cannot be confirmed from the cache.
- Album, backup-quality and regular-expression filters; thumbnails and selection.
- Move to Trash and permanent deletion, the confirmation flow and the operation journal. No
  general-media code path touches Video Boost Reclaim or uploads.

## Checked on a Pixel 8 Pro, Photos 7.99
Totals and filters were compared with a copy of the account database (74,181 records): 4K or
higher 38,444; before 2025 64,479; name "elden" 112; albums 439 (363 private, 76 shared); an
album of 518 items showed 518. Not exercised: other UI languages, TalkBack, landscape, font scale.

The idea of reading media metadata and albums comes from Google Photos Toolkit (MIT, xob0t); no
code or browser RPC from it is used (see [ATTRIBUTION.md](ATTRIBUTION.md)).
