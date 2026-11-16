# Library Manager (1.2.0-dev)

Photos profile page → **Pixel Photos Evolved** → **Backup**, **Library Manager** or
**Compatibility & diagnostics** (moved here from the Backup page). Backup is the existing settings
page. Library Manager (called Library Tools until 1.1.4-dev) opens one page, **Smart Filter**, which reads the active account's metadata cache
Photos keeps on the phone (`gphotos<N>.db`, opened read-only) on a background thread. This is not a
scan of the whole Google Account. Nothing in the library is written or deleted.

Library rows are `remote_media` rows with `is_canonical=1 OR is_canonical_copy=1` (album copies
excluded); a Video Boost pair shows once (its `VB-02.MAIN`), as in Photos.

## Smart Filter
- Under the page title: the busy bar (its own slot, so nothing moves), the summary card, then one
  controls row: a clear button at the left (only while a filter is on; it slides in and out), the
  filter chips in order Storage, Size, Format, the photo or video chips, Albums (scrolling), and the
  sort button fixed at the right (newest, oldest, largest, smallest; tonal when not newest first).
  The row is built once per page and changes in place: a chip's colour and check mark morph, chips
  that appear or leave slide, nothing is rebuilt. Menus are M3 Expressive (rounded surface, the
  selected row a tonal pill with a check mark; they unfold from the chip). Filters combine with AND.
  First 200 matches.
  - **Type** has no chip: the card's Photos / Videos legend selects it (a second tap clears it).
    Photos are Photos' type codes 1, 3 and 4 (panoramas and animations count as photos), videos 2.
  - **Format**: the format families found in the library, by name, most common first (JPEG =
    .jpg .jpeg, HEIC = .heic .heif, RAW = .dng .cr2 .nef ..., MP4 = .mp4 .m4v, MOV, PNG, GIF ...),
    listed for the current type. A format of one kind sets the type (MP4 sets Videos).
  - **Megapixels** (photos and panoramas only): 40 MP or more, 12 MP or more, under 12 MP,
    under 2 MP. **Duration** and **Resolution** (videos only). A chip that leaves its context is
    hidden and its filter cleared, so no filter applies unseen.
  - Storage, size and album as below. There is no date filter.
- There is no search box: Photos' search (people, places, things) is server side and the phone's
  cache cannot answer it, so none is offered. A filter or sort change shows at once. Every query
  shows the busy bar the same way: an indeterminate wave grows in; when the data is there (after at
  least 350 ms on screen) it turns determinate and fills to the end, holds, and folds away. The old
  results stay until the new ones fade in.
- The first read after opening builds the temp tables from a full scan of `remote_media`: the
  columns it needs sit after the `protobuf` blob (column 15, about 194 MB on the main test account),
  so SQLite walks every row's overflow pages, i.e. the whole ~600 MB file. The read-only connection
  uses memory-mapped reads (`PRAGMA mmap_size`), so the kernel reads ahead: 11.3 s before, 3.9 s
  with a dropped page cache and 0.35 s warm on the Pixel 8 Pro.
- **Summary card** under the title, for the current result: the `size_bytes` total with "Showing n of
  m", a bar of the photos / videos share of the filtered library, and the Photos / Videos legend with
  size and count of each (the type filter). The legend always shows both types' real numbers for the
  other filters; the type not selected is only dimmed. A footnote shows "Using storage" (the total of
  `quota_charged_bytes` above zero and its item count) only when non-zero. The Storage chip offers
  any, using and not using storage; there is no "unknown" option: the column may be NULL, but not
  one row of either test account was (75,058 rows, 2026-11-15), and a NULL row would still show
  under any storage. `quota_charged_bytes` is Photos' own per-item figure and says
  nothing about how full the account is: on the main test account every library row has 0 while
  Photos' profile shows 6.08 GB of 17 GB used, so there the "Using storage" line never appears and the
  Storage chip's "Using storage" option returns nothing; on the second test account 3 photos have
  8,364,220 bytes charged (the card showed 8.4 MB, 3 items).
- **Album** chip: Any album, In an album, Not in any album, or Choose an album (a bottom sheet with a
  search field listing the visible albums, most recent photo first, with item counts; a ListView over
  an adapter whose own filter narrows it as you type, 439 rows are never rebuilt).
- The filter runs on TEMP tables of the read-only connection: the library rows (without the protobuf
  blob) and the album memberships are copied once when the page is opened (`sf_lib`, `sf_alb`), and
  every filter or sort change runs two statements over them: per-type totals for the filters without
  the type (cached per filter until the temp tables are rebuilt, so a Photos / Videos toggle skips
  it) and the shown rows with the type, `LIMIT 200`, whose location-label subquery runs for those
  rows only. (It was one statement with eleven window aggregates and the label subquery for every
  matching row: 83 ms, now 30 ms on the main library, PC, warm.) Nothing is written to Photos' database; the
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
A tile still loading is a square grey cell, as in Photos (the rounded shape is only the selection clip).

- How many results: tapping "Showing 200 of 32,248" on the card (it carries the chips' chevron) opens the chips'
  own menu, right-aligned under it: Show 100 / 200 / 500 / 1,000 / 2,000 / Show all N, the options at or above the
  filtered total folded into that "Show all N" (on Videos: 100, 200, 500, 1,000, Show all 1,137). The pick re-runs the
  query with that limit and is kept in `pixel_photos_evolved.xml` (`lt_limit`, default 200).
- The grid keeps only the rows near the screen (2026-11-17). The result is laid out once as numbers (each row's top,
  first item, item count or "header"), and the grid holds a spacer, the rows within one screen of the viewport (kept
  until they are two screens away) and a spacer, about five screens of rows whatever the result size. Rows are made
  as they come near and dropped (with their queued thumbnail requests) as they leave; the selection, the day check and
  the pill read the item list, not the rows. Show all (32,248 items) opens at once and scrolls smoothly.
  History: Show all first built every tile at once (seconds of view creation on the UI thread, then an ANR kill);
  then the grid was built ahead of the viewport only, but as one long list of rows: 14-15% janky frames in a 40-fling
  test deep into the library (2,000 items: 2.7-3.9%).
- Frames, 40 flings deep into Show all (`dumpsys gfxinfo`, Pixel 8 Pro, 120 Hz, 2026-11-17): day layout 0.02% and
  0.03% janky (1 of 5,766 and 2 of 5,754 frames), 99th percentile 10-11 ms; comfortable layout 0.00% (0 of 2,075),
  10 ms. Before: 14-15%. With the scrubber added (it follows every scroll): 0.11% and 0.09% (6 of 5,316, 5 of
  5,401), 99th percentile 11-12 ms.
- Refresh (2026-11-17), the round icon at the right of the title: re-reads Photos' records and runs the current
  filters, sort and result limit again (nothing is reset). The page keeps a snapshot of the library (temporary tables
  made once per database connection), so items Photos added or removed after the page first opened only showed after
  Photos restarted; Refresh rebuilds that snapshot first. Checked: Videos filter on, Refresh, still "Showing 1,137 of
  1,137" and the grid filled again.
- Scrubber, like the Photos tab (measured on the stock 8.0 app 2026-11-17: screen recordings, lossless screenshots and
  Photos' own `photos_list_fastscroll_new_scrubber_*` dimensions): a thumb at the right edge (46 dp tall, 35 dp on
  screen, rounded on the left, up / down arrows) appears once the list leaves its top and stays (no fade-out, as in
  Photos); its place follows the scroll on a track at Photos' screen positions. Dragging it scrolls the list to the
  same place; while held, a "Mar 2025" bubble (14 sp, 16 / 8 dp padding) rides 24 dp left of the thumb and the years
  stand in a column at their place on the track (12 sp pills; a year that would overlap the one above is left out, as
  Photos does), and a tick (the VIRTUAL_KEY haptic Photos uses) marks every month change. Letting go fades bubble and
  years (150 ms). The page's own thin scroll indicator is gone. Side by side with the stock app the thumb sits at the
  same height and the year column lines up (2026 at the same row, 2020 dropped in both); the thumb and bubble grey is
  the nearest dynamic colour to Photos' (#33302f here against #323136; this page's own surfaces are warmer).
  Frames while dragging the thumb top to bottom and back (40 px steps): 1.1-1.6% janky, 99th percentile 23-24 ms
  (stock Photos, same drag: 9.1%, 27 ms); while held only the rows on screen are made.
- Switching layout keeps its place (2026-11-17): the row under the fingers (pinch) or at the list's top (grid
  controls menu) stays where it was, found in the new layout's row list. Before, the pinch guessed by 1 / columns^2
  and missed by weeks between the comfortable and day layouts (Mar 23 -> Feb 7); the menu did not anchor at all
  (Day at July 2025 -> Month at April 2023). Checked: Day -> Month -> Day by pinch and by the menu, the same
  Sep 21, 2023 rows under the fingers / at the top each time.
- A day's date and place are one line each, ending in "..." when too long (the row model gives every header the same
  height).
- Performance pass over the grid, pill and scrubber (2026-11-17), measured on the same Pixel 8 Pro:
  - Per tile built: the selection look (two reflective scale animations) only runs while something is selected; the
    rounded image outline is one shared drawable (no reflective corner radius per tile); the day thumbnail size is
    computed once per fill, not from the display metrics twice per tile; `gRows.indexOf` (a 32k-item scan, twice
    per tile) is an identity-map lookup.
  - Per scroll pass: the window pass reads the row model instead of `Class.forName` / `isInstance` per row, rows
    leaving the grid are told apart by the model, and the screen-position array, screen height and header colour
    are reused instead of re-read or re-allocated.
  - Day check and header tap: the day's items come from the model (its first and next header), not a scan of every
    row comparing date strings; the month layout's check now reads the month (it compared the day before).
  - Scrubber: the thumb moves by an integer `scrollTo` of its holder (no reflective float setter per move), the
    finger's y is one cached reflective call (was two, with a key string built each time), its arithmetic is plain
    64-bit integer math (was boxing through `Integer`), and a month or year label is formatted only when the position
    leaves the current month / year (a calendar span check; was a `Date` and a format on every move). The year column
    formats once per year instead of once per header row.
  - Memory: the model's four arrays are trimmed to their size (they are built at 2n + 3 entries).
  - Measured after: 40 flings deep into Show all 0.09% and 0.10% janky (5 of 5,355, 3 of 3,060), 99th percentile
    12 ms; scrubbing top to bottom and back 0.75-1.25% (was 1.1-1.6%), 99th percentile 24-30 ms. Executable
    (`classes*.dex`): 3,454,528 bytes, 1,036 more than before the pass (the model-based day functions).
- Thumbnail loading (2026-11-16): stack samples of a cold open showed the three loader threads waiting on the network
  nearly all the time and the UI thread idle. Now eight loader threads at background priority, and grid
  thumbnails are kept on disk (`cacheDir/ppe-th`, one file per thumbnail URL, about 150 KB each; trimmed at start
  when over 150 MB). First screen filled after a cold process start: about 4.4 s before, 3.0 s with an empty disk
  cache, 1.5 s with it filled; after a fling, about 3 s of grey cells before, none now.
- Memory: a tile more than two screens above or three below the viewport lets its bitmap go and reloads it when it
  comes near; items after the first 200 are requested only near the viewport, by the window pass (at most every 90 ms; asking
  from every row made mid-fling queued the rows passed by: about 12 s of grey cells after a long fling, 3 s without). Flinging through 2,000 items kept
  the native heap at about 295-322 MB (200 loaded tiles used to add about 150 MB, never released).
- Frames during a cold open with scrolling (page cache dropped): 0.73-1.01% janky, 99th percentile 28-34 ms
  before; 0.71-0.74%, 21-23 ms now; with 2,000 items 3.9%, 32 ms (building the tiles).

- Tap: a full-screen viewer over the grid's own items (the stock viewer resolves stacks and swipes
  the whole library). Opening is a shared-element zoom: the image starts covering the cell, clipped
  to what the cell shows, and grows to fit the screen; the cell's own bitmap is shown at once and
  cross-fades to the sharp image (no blank frame; Back or swipe-down zooms back into the tile of the
  item now shown while that tile is on screen, else fades). Swipe between results, pinch / double-tap zoom, swipe down or Back to
  close. Videos are copied to Photos' cache, then played (see Video below).
- Motion copied from screen recordings of the stock one-up (2026-11-15): open / close zoom 200 ms
  fast-out-slow-in; bars fade linearly in 200 ms, a single tap toggles them only after the 300 ms
  double-tap timeout; double tap zooms 2.5x around the tapped point and hides the bars. Swiping is a
  pager: both pages follow the finger with a 24 dp gap and settle in 260 ms (half a page or a quick
  flick goes on). Dragging down shrinks the image with the finger, fades only the black backdrop
  (the grid shows through) and hides the bars; letting go past 32 dp closes into the tile, otherwise
  it springs back. The Info sheet carries the image on its top edge while it opens, closes or is dragged.
- Grid pinch, like the Photos tab (2026-11-16): spread/pinch with two fingers anywhere on the grid (tiles,
  headers or gaps). The grid scales with the fingers; past 0.8x / 1.25x it steps between three layouts: large
  (two photos per row sized by their real aspect ratios, a wide item or a day's odd last item full width), day
  (4 columns, day + place headers) and month (5 columns, month headers). Spreading on the large layout opens the
  touched photo, as in Photos. Once a day's header scrolls under the top of the page, its date and place float
  in a pill there, with Photos' round grid-controls button (Comfortable / Day / Month, Photos' own labels) beside
  it; both fade away when the first header is back in view. The old layout shrinks
  or grows and fades out over the new one, 250 ms, with the content under the fingers kept in place. There is
  a rubber band when no layout exists in that direction. Tiles keep their picture across the switch (both
  layouts use the day-size thumbnail).
- Selection sheet, like Photos' action panel (2026-11-16): it opens to a peek (actions + "Share To", 209 dp)
  and is as tall as the screen minus 114 dp. A drag from anywhere on it moves it between collapsed (actions
  only, 120 dp), peek and full; a fling goes one stop, a slow release goes to the nearest. Touching the grid
  collapses it, and X or Back slides it away. "Open in Google Photos" opens the stock
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
- Map previews (2026-11-16), as in Photos: under the place row of Info and under "Location / View Map" in the selection
  sheet, a lite-mode Google map: 156 dp card, 24 dp corners, the item's photo in a round dark marker whose pointer marks
  the place (the selection map adds a white ring dot), the attribution kept in a clipped overhang as on the stock card.
  Photos' own night style (raw `photos_mapexplore_dark_style`) is applied when the map is ready (lite mode ignores the
  options' colour scheme); Info is always dark, the selection map follows the sheet's surface colour. Scale: Info zoom
  12, selection fitted to the selected items' places, at most 9 (same towns and labels as the stock maps on the
  device). Tapping a map does what Open in Maps / View Map does. Found without obfuscated names: MapView,
  GoogleMapOptions, CameraPosition and LatLng keep theirs (public constructors); MapView's create step and
  getMapAsync are DexKit member rules (#map.create: the void() calling a void(Bundle); #map.async: the method with
  "getMapAsync() must be called on the main thread"); the style call is GoogleMap's only method taking a Parcelable
  made from a String. Not built: the pencil (edit location) next to the place, no verified write path.
- Not built: the favourite star (no verified write path); earlier note on the inline map (the Maps view's lifecycle
  methods are obfuscated); "Open in Maps" stays. Trash was checked up to its confirmation only.

## Video (Photos 8.0 one-up, 2026-11-16)
Measured on the stock one-up (uiautomator bounds and screen recordings) and matched to the pixel on a
Pixel 8 Pro (button row, time, track and action row at the same y as stock):
- No play button in the middle. A video plays as soon as it is shown; a video opens with the bars hidden,
  and they hide when playback starts. The thumbnail stays on screen until the first frame.
- Controls above the action row, fading with the bars: play / pause (48 dp, 4 dp from the left), mute
  (48 dp, 4 dp from the right), "0:19 / 0:40" centred between them, and a slider: 8 dp track (white
  played, #999999 left, outer corners 4 dp, inner 2 dp), a 4 x 44 dp white bar thumb with a 2 dp gap on
  each side, a 4 dp stop dot at the end. Dragging the slider seeks. Photos' own strings for Play, Pause,
  Mute and Unmute.
- While it plays, the bars hide 5 s after the last interaction (stock measured 4.9 s). At the end the
  bars come back with Play. With the bars hidden, a tap on a control only brings the bars back.
- The video follows the image's pager, zoom and drag-down moves.
- Downloads run one at a time and a request the user already swiped away is skipped; the last file is
  reused when the same video is shown again. The whole file still downloads before it plays (MediaPlayer
  cannot range-read the signed `=dv` stream): about 3 s for a 7 s clip, under 6 s for 40 s, here.
- Not built: Key Moments (not in the cache database), Save as photo, playback speed, hour format for
  videos of an hour or more.

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
