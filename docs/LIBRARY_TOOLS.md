# Library Tools (1.2.0-dev)

Photos profile page → **Pixel Photos Evolved** → **Backup**, **Library Tools** or
**Compatibility & diagnostics** (moved here from the Backup page). Backup is the existing settings
page. Library Tools opens one page, **Smart Filter**, which reads the active account's metadata cache
Photos keeps on the phone (`gphotos<N>.db`, opened read-only) on a background thread. This is not a
scan of the whole Google Account. Nothing in the library is written or deleted.

Library rows are `remote_media` rows with `is_canonical=1 OR is_canonical_copy=1` (album copies
excluded); a Video Boost pair shows once (its `VB-02.MAIN`), as in Photos.

## Smart Filter
- The page has no title: it opens with the filter chips (type, storage, size, date taken, duration,
  resolution, album), each with a menu, combined with AND; sort row (newest, oldest, largest,
  smallest). First 200 matches. There is no search box: Photos' search (people, places, things) is
  server side and the phone's cache cannot answer it, so none is offered. A chip or sort change shows
  at once with a progress indicator while the query runs; the old results stay until the new ones
  fade in.
- **Summary card** under the chips, for the current result: the `size_bytes` total and item count,
  expandable to photos / videos / other (size and count each) and the number with unknown charged
  storage. A second line, "Using storage", shows the total of `quota_charged_bytes` above zero and its
  item count only when it is non-zero. `quota_charged_bytes` is Photos' own per-item figure and says
  nothing about how full the account is: on the main test account every library row has 0 while
  Photos' profile shows 6.08 GB of 17 GB used, so there the "Using storage" line never appears and the
  Storage chip's "Using storage" option returns nothing; on the second test account 3 photos have
  8,364,220 bytes charged (the card showed 8.4 MB, 3 items).
- **Album** chip: Any album, In an album, Not in any album, or Choose an album (a bottom sheet with a
  search field listing the visible albums, most recent photo first, with item counts; a ListView over
  an adapter whose own filter narrows it as you type, 439 rows are never rebuilt).
- The filter runs on TEMP tables of the read-only connection: the library rows (without the protobuf
  blob) and the album memberships are copied once when the page is opened (`sf_lib`, `sf_alb`), and
  every filter or sort change is one statement over them, with window aggregates (`COUNT(*) OVER()`,
  `SUM(...) OVER()`) for the card before `LIMIT 200`. Nothing is written to Photos' database; the
  temp tables live and die with the connection (kept while the page is in use, closed on Back and
  after 2 minutes without a request), so rows Photos adds meanwhile show after the next opening. The
  filter (SQL and bound arguments) is built on the main thread, the work runs on a single thread
  that times out when idle, stale requests are dropped, and a failure is reported as the answer
  instead of retried.
- **Opening** (Pixel 8 Pro, 31,852 library rows in a 615 MB database; times from `logcat` lines of a
  dev build): the last unfiltered result is kept in Photos' cache dir (`ppe-sf-<account>.bin`; our own
  file, written to a `.tmp` and renamed, files of removed accounts are deleted) as raw column values
  and painted 25-120 ms after opening, with dates and sizes formatted at paint time; it is used only
  while no newer request has started. The real read then refreshes it (nothing animates when the rows
  are unchanged). That read is bound by disk, not by SQL: with the page cache dropped, building the
  temp tables takes 10.3-10.7 s on this phone (db open, albums and thread start together 25 ms; the scan
  reads every `remote_media` row with its protobuf overflow pages), against 0.8 s on a PC with the
  file cached. The phone evicts the 615 MB file from the page cache quickly, so "warm" opens took 3-9
  s here. A background thread that read the whole file first (3.2 s) used to bring the cold refresh to
  3.8 s; it was removed (615 MB of page-cache churn per open): the cold refresh is now slower, but
  nothing waits for it except a filter change made before it finishes.
- **Filter and sort changes** after that take 35-150 ms (measured with the page cache dropped, tables
  built): Type Videos 102 ms, back to all media 117 ms, In an album 149 ms, Not in any album 111 ms,
  Using storage 34 ms; the old full scan took 0.45 s with the file cached and seconds without.

### How album membership is read
A media in an album is a *second* `remote_media` row (an "album copy": `is_canonical=0`) whose
`collection_id` is the album's `collections.collection_media_key` and whose `dedup_key` equals the
library row's. The library row's own `collection_id` is not an album key, and `item_collection_data`
is empty. "Visible albums" are `collections` rows with `type=1`, `is_hidden=0`, `is_soft_deleted=0`
(what the Albums tab lists; Photos' hidden automatic "Trip to ..." collections do not count).

- In an album: `dedup_key IN (copy rows whose collection_id is a visible album)`.
- Not in any album: the same with `NOT IN`.
- One album: copy rows with that `collection_id`.

Limit: a copy row shares only the `dedup_key` with the library row (its `media_key` and
`remote_media_key` are its own; no column links the two exactly). When the library holds duplicates of
one file (same `dedup_key`; 327 keys, 655 rows on the main account) all of them count as "in an
album" even if only one was added. 633 of those rows sit in keys where the album rows are fewer than
the library rows, so "Not in any album" can miss up to that many duplicates, and an album list can
include a duplicate that is not itself in the album.

Checked against a copy of the account database: for all 439 visible albums the number of copy rows
equals `collections.total_items` (32,961 rows), and for the four newest albums the library items
reached through `dedup_key` equal `total_items` (45, 518, 73, 42). Of 31,852 library items, 31,486
are in a visible album and 366 are not (mostly the last months' uploads; 147 of them are only in
hidden automatic collections). Items of an album that belong to someone else's library are not shown
(72 copy rows have no library row).

## Grid, viewer, selection, download
Media show in a Photos-style grid: day headers, month headers from 6 columns, pinch for 2–9
columns, video length badge. Thumbnails and full images come from the item's lh3 URL with the
account's OAuth token (`photos.image.readonly`). Grid thumbnails keep the photo's aspect and are
sized by the short side (`=s<1.5 x tile x long/short>-no`, at most 1280 px, from the row's width and
height; the tile crops them), so the bitmap in the tapped cell is also the viewer's placeholder.

- Tap: a full-screen viewer over the grid's own items (the stock viewer resolves stacks and swipes
  the whole library). Opening is a shared-element zoom: the image starts covering the cell, clipped
  to what the cell shows, and grows to fit the screen; the cell's own bitmap is shown at once and
  cross-fades to the sharp image (no blank frame; Back or swipe-down reverses the zoom when the
  first item is still showing). Swipe between results, pinch / double-tap zoom, swipe down or Back to
  close. Videos are copied to Photos' cache, then played. "Open in Google Photos" opens the stock
  viewer through the `link/photo` deep link; a one-shot hook keeps Photos' Home (and this page)
  alive.
- Viewer images are screen sized (`=s<longest screen edge>-no`, 2992 px here, about 0.4-1.5 MB, not
  the original), decoded with `ImageDecoder` (hardware bitmaps, EXIF applied) into an in-memory LRU
  (a byte budget of five screen-sized 4:3 bitmaps, 15 x edge^2 = 134 MB: the current image and two on
  each side; they are hardware bitmaps, i.e. graphics memory, so `maxMemory` is not the unit). The
  cache is emptied and its bitmaps recycled when the viewer closes, and dropped on trim-memory
  (UI hidden) through a registered `ComponentCallbacks2`. The neighbours (+-1, then +-2) are prefetched on
  a 3-thread pool and loads that fall out of the window are cancelled. Measured: first sharp image
  about 0.6-1.1 s after opening (fetch 0.3-1 s, decode 70-120 ms, until then the grid thumbnail),
  every swipe afterwards shows the sharp image at once (0 ms, from the cache) and going back within
  the same viewer fetches nothing again (the cache does not survive closing the viewer, so reopening
  fetches again). Graphics memory of the Photos process (`dumpsys meminfo`): 370 MB before the
  viewer, 432 MB open, 453 MB after five swipes, 418 MB after closing (the EGL part returns to its
  baseline, the GL texture caches keep about 48 MB until the system trims). Zoom works on the screen-sized image (no separate original is loaded).
- Hold: selection mode; **Download** saves each original (`=d`, videos `=dv`) to
  `Download/Pixel Photos Evolved`; **Download as ZIP** saves one archive there.

## Viewer chrome and Info (Photos 8.0 one-up)
- Top: back, centred date with a chevron (opens Info) over "time • place" (the day's place from Photos'
  location headers), overflow menu with **Download**, and the item's album as a chip (cover and title,
  the most recently active visible album that holds it).
- Bottom: **Share**, **Edit**, **Add to**, **Trash** with Photos' own labels and icons. While the viewer
  is open the selection handlers act on the shown item. Edit opens Photos' editor on the on-device copy
  (Photos' EDIT entry refuses its own FileProvider URIs), and a cloud-only item opens in the stock
  one-up, whose Edit downloads it. Add to lists Photos' own albums. Trash asks with Photos' text, then
  runs Photos' MoveToTrash for the item (device and Google Account, scope `LOCAL_REMOTE`).
- Info: **People** (face clusters of the item, `search_clusters` type 0) and **Albums** (cover, title,
  item count) after the caption, as in Photos. Dragging the sheet down at its top closes it.
- Not built: the favourite star (no verified write path) and the inline map (the Maps view's lifecycle
  methods are obfuscated); "Open in Maps" stays. Trash was checked up to its confirmation only.

## Not built
- Search: see above.
- Creating albums, adding or removing media, moving to Trash, permanent deletion: no verified write
  path in Photos 7.99.
- Backup-quality and regular-expression filters.

## Checked on a Pixel 8 Pro, Photos 7.99
Against copies of the account databases: 31,852 library items and 327 GB; the album filter shows
31,486 / 366 for In an album / Not in any album, 518 for "2026 Kemasik", 16 for videos not in any
album and 39 for videos in "2026 Kemasik"; videos alone 1,117 items / 249 GB; the second account's
card 8.4 MB, 3 items. All equal the SQL results. Also on device: the album sheet and its search (typing narrows the list at once) work in dark and light
theme, Back on Smart Filter, Backup and
Compatibility & diagnostics (also pressed twice quickly), viewer, zoom, video playback, selection,
Download (re-tested after the viewer rework: one original saved, 2.1 MB) and Download as ZIP (earlier,
before the rework).
Not exercised: other UI languages, TalkBack, landscape, font scale, long videos. The chip spring uses
an overshoot interpolator: androidx `SpringAnimation` is in Photos' dex but its helper classes are
not under their names.

The idea of reading media metadata and albums comes from Google Photos Toolkit (MIT, xob0t); no
code or browser RPC from it is used (see [ATTRIBUTION.md](ATTRIBUTION.md)).
