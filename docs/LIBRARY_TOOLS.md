# Library Tools (1.2.0-dev)

Photos profile page → **Pixel Photos Evolved** → **Backup**, **Library Tools** or
**Compatibility & diagnostics** (moved here from the Backup page). Backup is the existing settings
page. Library Tools has three pages that read the active account's metadata cache Photos keeps on
the phone (`gphotos<N>.db`, opened read-only) on a background thread. This is not a scan of the
whole Google Account. Nothing in the library is written or deleted.

Library rows are `remote_media` rows with `is_canonical=1 OR is_canonical_copy=1` (album copies
excluded); a Video Boost pair shows once (its `VB-02.MAIN`), as in Photos.

## Storage Analyzer
Total of `quota_charged_bytes` above zero, a card with photos / videos / other / unknown, the
number of library records checked, and the media that use storage. Sort pill: Size or Date taken
(tap again to flip the direction). Show: all media, photos, videos. Refresh.

## Smart Filter
Name search plus filter chips (type, storage, size, date taken, duration, resolution), each with a
menu, combined with AND; sort row. First 200 matches.

## Album Organizer
Visible albums (collections of type 1, not hidden or soft-deleted) as covers with item counts and
"Shared", filtered All / Shared with me / My albums (envelope owner = viewer) and sorted by most
recent photo, last modified or title (Photos' own labels). An album opens as its own page.

## Grid, viewer, selection, download
Media show in a Photos-style grid: day headers, month headers from 6 columns, pinch for 2–9
columns, video length badge. Thumbnails and full images come from the item's lh3 URL with the
account's OAuth token (`photos.image.readonly`).

- Tap: a full-screen viewer over the grid's own items (the stock viewer resolves stacks and swipes
  the whole library). Swipe between results, pinch / double-tap zoom, swipe down or Back to close.
  Videos are copied to Photos' cache, then played. "Open in Google Photos" opens the stock viewer
  through the `link/photo` deep link; a one-shot hook keeps Photos' Home (and this page) alive.
- Hold: selection mode; **Download** saves each original (`=d`, videos `=dv`) to
  `Download/Pixel Photos Evolved`; **Download as ZIP** saves one archive there.

## Not built
- Creating albums, adding or removing media, moving to Trash, permanent deletion: no verified write
  path in Photos 7.99.
- "Not in any album": a media record holds one `collection_id`.
- Album, backup-quality and regular-expression filters.

## Checked on a Pixel 8 Pro, Photos 7.99
Counts against a copy of the account database: 31,857 library items; Video Boost item using
6.4 MB; 439 visible albums; an album of 518 items showed 518. Viewer, zoom, video playback,
selection, Download and Download as ZIP (archive verified) tested on device. Not exercised: light
theme, other UI languages, TalkBack, landscape, font scale, long videos.

The idea of reading media metadata and albums comes from Google Photos Toolkit (MIT, xob0t); no
code or browser RPC from it is used (see [ATTRIBUTION.md](ATTRIBUTION.md)).
