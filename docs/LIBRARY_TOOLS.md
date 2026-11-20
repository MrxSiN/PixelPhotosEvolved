# Library Manager (1.2.0-dev)

Photos profile page → **Pixel Photos Evolved** → **Backup**, **Library Manager** or
**Compatibility & diagnostics** (moved here from the Backup page). Backup is the existing settings
page. Library Manager (called Library Tools until 1.1.4) opens one page, **Smart Filter**, which reads the active account's metadata cache
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
- The snapshot the filters read (`sf_lib`, `sf_alb`, see below) comes from a full scan of `remote_media`:
  the columns it needs sit after the `protobuf` blob (column 15, about 194 MB on the main test account),
  so SQLite walks every row's overflow pages, i.e. the whole ~600 MB file (memory-mapped reads: 3.9 s with
  a dropped page cache, up to 10 s on a busy phone). Since 2026-11-18 that scan no longer runs on every
  opening: the snapshot is kept in its own small file (see **Opening**).
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
- **Album** chip: Any album, In an album, Not in any album, or Choose an album, which opens the album sheet
  below.
- **Album sheet** (Choose an album, and Add to in the viewer and the selection sheet), copied from the stock
  8.1 app on the Pixel 8 Pro (screenshots and uiautomator bounds, 2026-11-18): drag handle; a "Search all
  albums" pill with a back arrow; All / Shared with me / My albums as a connected chip group (40 dp, 2 dp
  gaps, the chosen one round with a check); a sort row (Last modified, Album title, Most recent photo, in
  Photos' "Sort by" sheet) and, at its right, the Albums page's list / grid toggle; then the albums. Grid:
  two columns of square covers (28 dp corners), title and "N items · Shared" under each. List: 72 dp
  covers, title and count. Every label is Photos' own string. The picker opens on Last modified and the
  filter on Most recent photo, as in Photos; each remembers its own sort and view (`lt_alb_sort1/2`,
  `lt_alb_grid1/2`). Rows are recycled (a GridView over a `java.lang.reflect.Proxy` ListAdapter).
  Not built: New album (no verified write path).
  Albums as Photos lists them: the `collections` rows (type 1, not hidden or deleted) and the shared albums
  that only exist as `envelopes` rows (joined, titled, normal display mode: Photos' Shared with me showed
  exactly the two such albums owned by others, My albums three more of the user's own; an unjoined invite
  and a display-mode-1 envelope were not listed). Their items are `shared_media` rows, which the snapshot
  adds to the album memberships: choosing "Noor Evelyn Airra Luna" (2,492 items, shared by someone else)
  shows the 2,454 of them in the user's library. Shared with me = the envelope's owner is not the viewer.
- The filter runs on the snapshot tables: the library rows (without the protobuf blob) and the album
  memberships (`sf_lib`, `sf_alb`), and
  every filter or sort change runs two statements over them: per-type totals for the filters without
  the type (cached per filter until the temp tables are rebuilt, so a Photos / Videos toggle skips
  it) and the shown rows with the type, `LIMIT 200`, whose location-label subquery runs for those
  rows only. (It was one statement with eleven window aggregates and the label subquery for every
  matching row: 83 ms, now 30 ms on the main library, PC, warm.) Nothing is written to Photos' database. The
  filter (SQL and bound arguments) is built on the main thread, the work runs on a single thread
  that times out when idle, stale requests are dropped, and a failure is reported as the answer
  instead of retried.
- **Opening** (2026-11-18, Pixel 8 Pro, Photos 8.1, 32,247 library items in a 635 MB database, result limit
  "Show all"). Stack samples of an opening showed where its seconds went: about 8 of 9.6 s formatting a
  description (type, date, size, storage) for every row, twice (`Formatter.formatShortFileSize` builds an
  ICU formatter per call), the rest Java (de)serialisation of the 9 MB startup cache, and behind it the
  ~600 MB scan above on every opening. Now:
  - the description is made when a tile or the viewer first needs it, and the day / month labels once per
    calendar day instead of once per row;
  - the snapshot lives in Photos' cache dir as our own SQLite file (`ppe-lib2-<account>.db`, 14 MB, built
    from a second read-only connection and renamed into place), ATTACHed read-only to the page's
    connection; the startup cache file is gone (old files are deleted at opening, as are snapshots of
    accounts no longer on the phone);
  - once per opening a low-priority thread compares a change key (row count and highest id of
    `remote_media` and `shared_media`, the albums' and envelopes' counts and last activity: 9 ms) and,
    when Photos' records changed, rebuilds the file in the background and re-runs the current filters.
    Photos' sync token is not part of the key: it changed between two openings a minute apart with
    nothing else changed. An edit in place of a row's size or charged bytes shows after Refresh.
  - Refresh rebuilds the snapshot before re-running the filters; the first opening without a snapshot
    builds it (the old cost, once).
  Measured (query worker busy, from the tap; stack samples every 0.25 s): 0.75 s with the snapshot current,
  1.5-2.3 s while a background rebuild competes for the disk, against 9.6 s and more before. A photo taken
  meanwhile showed up on the next opening without Refresh.
  Second pass (same day): each row is one String[14] (it was copied twice: three arrays per row, 64k extra for 32k
  items); the row description (type, date, size, storage: an ICU size formatter each) is made only when accessibility is
  on, since it is only ever a content description; the album sheet keeps each album's "N items · Shared" after its first
  bind; the pull gesture reads the finger's position (a reflective call, a boxed Float) only when a pull is possible, not
  on a normal scroll's move events; code nothing reaches is pruned at build time (18 functions, 4 State fields, 5 strings
  in 10 languages). After it: 1-1.25 s from a cold process start with 32,247 items, no ICU formatting in the samples,
  start-up unchanged (symbol cache 1 ms).
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
- Refresh: pull down at the top of the page (2026-11-18; until then a round icon at the right of the title). It
  re-reads Photos' records and runs the current filters, sort and result limit again (nothing is reset). A 40 dp
  round surface with the refresh arrow follows the finger (half its travel, at most 96 dp, the arrow turning); let go
  past 64 dp (as SwipeRefreshLayout's default) and it spins until the new result is in (4.7 s on the test phone: the
  whole snapshot is rebuilt), otherwise it slides away. It is our own gesture on the page's scroller (a
  NestedScrollView of Photos' account menu window): Photos' SwipeRefreshLayout keeps its class name but not its
  members. Not reachable with TalkBack yet (no accessibility action). The page keeps a snapshot of the library (temporary tables
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
- **Recover storage** (2026-11-18, Photos' own label and cloud-upload icon, after Download as ZIP): reads which selected
  items use account storage (`quota_charged_bytes > 0` in the snapshot, 500 keys per statement, on the query thread) and
  says how many and how much ("1 of the selected items use 3.4 MB of your storage."). Items that use none are left out.
  - **Re-upload** keeps them: they become a Reclaim job, the engine Video Boost Reclaim uses (see
    [Video Boost Reclaim](VIDEO_BOOST_RECLAIM.md)): one item at a time, journaled and resumable, download the original (a
    safe local copy stays until the item is done), delete the cloud copy and only its own Trash copy, upload the same
    bytes again with the Backup setting, then check Photos' records for the new copy's storage use. Progress, pause /
    resume and History are on the Backup page's Reclaim card. The engine was video-only in three places (the safe copy's
    `.mp4` name, the MediaStore video table and `video/mp4` it is published with, and the upload's `video/mp4`); they now
    come from the item (extension and MIME type from its file name; Video Boost items keep the old values). New copies
    leave their albums, shared links and edits behind, which the dialog says.
  - **Move to trash** runs Photos' MoveToTrash for each item (device and Google Account), as the viewer's Trash.
  - Nothing starts while a reclaim is running or can be resumed (the dialog says so). The toast names where progress is:
    Backup > Video Boost Storage Reclaim.
  - Run on the phone on ONE item (2026-11-18/19, Photos 8.1): `P1374376-ANIMATION.gif`, 3,391,061 bytes, charged 3,391,061.
    Download, cloud + own-Trash delete and MediaStore publish worked; PPE's finalization then failed with
    `NON_MATCHING_GAIA_BACKEND_GAIA_ID_INVALID`, because the owner-verifier hook looked the class up by a 7.98 name that
    has meant another class since 7.99. Meanwhile Photos' own backup uploaded the published copy: the DB then held exactly
    one row for the item's dedup key, new remote key, `quota_charged_bytes` 0, `upload_status` 100, and no row for the old
    key. The item was closed without a second upload (journal marked upload-complete, then Resume ran only the check):
    History says "Cloud copy replaced.", the safe copy stays in `files/ppe_reclaim_recovery`. The verifier is now found by a
    DexKit rule ([Video Boost Reclaim](VIDEO_BOOST_RECLAIM.md#finalization)); on the phone the rule resolved, but the
    hook itself has NOT RUN yet (it installs only on PPE's own finalization write).

## Viewer chrome and Info (Photos 8.0 one-up)
- Top: back, centred date with a chevron (opens Info) over "time • place" (the day's place from Photos'
  location headers), overflow menu with **Download**, and the item's album as a chip (cover and title: the user's
  own albums first, then shared ones, most recent activity first) with "+N" beside it when the item is in more albums,
  as in Photos (a connected pair: 4 dp gap and inner corners; shared albums without a collections row count too).
- The Add to album, Trash and Delete from device confirmations take Photos' colorPrimary for their buttons (their
  DeviceDefault alert theme gave the system accent, nearly invisible on the dark dialog).
- Bottom: **Share**, **Edit**, **Add to**, **Trash** with Photos' own labels and icons. While the viewer
  is open the selection handlers act on the shown item. Edit opens Photos' editor on the on-device copy
  (Photos' EDIT entry refuses its own FileProvider URIs), and a cloud-only item opens in the stock
  one-up, whose Edit downloads it. Add to opens the album sheet (the albums Photos lets you add to). Trash asks with Photos' text, then
  runs Photos' MoveToTrash for the item (device and Google Account, scope `LOCAL_REMOTE`).
- Info: **People** (face clusters of the item, `search_clusters` type 0) and **Albums** (cover, title,
  item count) after the caption, as in Photos. Dragging the sheet down at its top closes it.
  Both open Photos' own pages (2026-11-18), and Back comes back here: an album through
  `https://photos.google.com/album/<key>` (an album made on the phone has a `localc:` key Photos refuses, so
  its remote key comes from `media_collection_key_proxy`), a shared album through its share link
  `https://photos.google.com/share/<key>?key=<auth_key>` (the `photos.app.goo.gl` short link relaunches
  Photos as a new task), a named person through `https://photos.google.com/search/<name>` (Photos shows
  that person's photos) and an unnamed one through `https://photos.google.com/people`. Albums also list
  the shared albums that hold the item, and counts have grouped digits ("2,492 items").
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

## Library Manager tools (1.1.4, 2026-11-19)

Generators ui169-ui172 (and ui154 / ui163 for the filters and the snapshot). Every write below is one the user picks and
confirms; nothing runs on its own.

### Smart Filter 2.0 and search
- New chips: **Kind** (Screenshots: file name `Screenshot*`, `Screen_Recording*`, `Screenrecord*`; Creations: Photos'
  `composition_type` is set, i.e. animations, collages, cinematic photos; Favorites: `is_favorite`), **Camera** (make and
  model, a list like Format), **Location** (has / no capture location: `latitude IS NULL`), **Uploaded** (Photos'
  `server_creation_timestamp`: last 7 days, 30 days, 12 months, or over a year ago). **Albums** adds "In 2 or more albums".
- Camera: Photos keeps each item's camera in its record (`remote_media.protobuf`): a message that starts with the image's
  pixel width and height (fields 1 and 2) holds make and model as fields 1 and 2 of its field 5. The snapshot (`ppe-lib4-`,
  table `sf_cam`) finds that message by its first bytes (width, height, or height, width for rotated photos) and reads it
  field by field, bounded; no fixed path. A Python prototype over the device DB matched a full protobuf walk on every
  sampled row once both orders were tried. Makes are merged by case ("google" / "Google") and a model that already starts
  with its make is shown alone.
- **Search**, a bar floating at the bottom of the page as on Photos' search results (8 dp over the navigation bar or
  the keyboard; Back closes the keyboard first): file names, capture dates typed as `YYYY-MM-DD` (or a prefix like `2024-05`),
  album titles and camera names, 350 ms after the last key. All filters, the search included, start empty on every opening.
- Device (Pixel 8 Pro, Photos 8.1, main library, 32,247 items), EXECUTED: Kind > Screenshots = 71 (the DB count);
  Camera list read from the snapshot, Google Pixel 8 Pro = 2,352; search "P1374376" = the 2 matching items. Then
  each one on the device, EXECUTED, every count equal to Photos' DB: Location no location 18,383 / has location 13,864;
  Creations 124; Uploaded last 7 days 16, 30 days 467, 12 months 2,826, over a year 29,421; "In 2 or more albums" 5,600
  (shared albums included). Favorites: no favorites in this library, NOT RUN.

### Duplicates (tools menu > Find duplicates)
- **Exact copies**: the same dedup key (Photos' content hash) in more than one library row: 327 groups, 655 items on the
  main library (= the DB). Photos shows each such group as ONE item and its trash removes every copy, so this level only
  lists them (no removal).
- **Same name and date**: same file name (any case) and capture time, different content: 42 groups.
- **Similar photos**: a 64-bit difference hash of a small thumbnail (`=s64`) for every photo taken within 60 s of
  another; consecutive photos within 8 bits of their group's first form a group. RAW files and photos with a RAW partner
  (same name stem) are left out, so RAW + JPEG pairs stay whole. Hashes are fetched by 48 threads and cached per dedup key
  in `cacheDir/ppe-dup-<acct>.db` (a cache: written without a disk sync per row); the first scan of the main library is
  about 25,300 photos, later scans only fetch new photos. Closing the page stops the scan; what was fetched stays cached.
- Each group shows its items side by side (thumbnail, resolution, size, format), the suggested best first with a
  "Best" badge: most pixels, then largest file, then earliest upload.
- Removal is reviewed: nothing is pre-selected, the user taps the items to remove, the last item of a group cannot be
  marked ("Keep at least one item in each group."), and Move to trash asks first, then runs Photos' MoveToTrash
  (device and account trash, restorable).
- Device, EXECUTED: both SQL levels as above; marking, the keep-one rule and the trash button. Move to trash, EXECUTED
  on one test copy (`DSC00308.JPG`, the non-best of its group, restored from Photos' trash afterwards): the first try
  failed Photos' argument check. Trash asked for "device and account" (`LOCAL_REMOTE`), which Photos refuses for an item
  with no copy on the device. Items with no device copy now use "account only" (`REMOTE_ONLY`, found by its own DexKit
  rule). After the fix, Photos' DB showed both rows of the item trashed and the best copy untouched. The same fix applies
  to the viewer's Trash and Recover storage's Move to trash for cloud-only items (NOT RUN again there).
- Refresh after Move to trash, EXECUTED (2026-11-20, same test item, restored again afterwards): the page still listed
  the trashed item. Two causes: Photos applies the trash a moment after the call returns, and a trashed library row keeps
  `is_canonical_copy=1`, so the snapshot counted it as a library item. The snapshot now leaves out rows with
  `trash_timestamp` set (file prefix `ppe-lib4-`, so older snapshots are rebuilt), and the page re-reads 3 s after Move
  to trash. Device: toast "Moved 1 item to trash", then "41 groups, 82 items" without the group; the page showed
  32,246 items while the item was in Photos' trash and 32,247 again after it was restored, equal to Photos' DB both times.
- Similar photos, EXECUTED (2026-11-20, main library, Photos kept open): 20,646 photos hashed in under 14 minutes
  (4,540 already cached; about 26 photos/s with 16 threads): **1,735 groups, 3,863 items**. Thumbnails and Best badges
  shown.

### Export (tools menu > Export)
- Exports what the filters currently match (all matches, not only the rows shown): originals as stored in Google Photos
  (`=d`, videos `=dv`, as Download), into `Download/Pixel Photos Evolved/Export <date time>/`: one folder, `<year>/<month>`
  of the capture date, or one folder per album (an item in several albums is written to each; items in none go to
  "No album").
- Journaled in `filesDir/ppe_export` (`items.json` once, `progress.log` one line per finished file). Pause stops after
  the current file; Resume, also after Photos was closed, continues at the first file not in the log. Each file is streamed
  through SHA-256 into MediaStore (pending until complete); a failed file's row is deleted, the failure is logged and the
  job goes on.
- At the end: `manifest.csv` and `manifest.json` (path, name, capture time, size, SHA-256, width, height, type, camera,
  latitude, longitude, albums, remote key, status, error), `SHA256SUMS.txt` (`sha256sum -c` format) and `report.txt`
  (counts and every failure). An export before Recover storage is a checked local copy of what is about to be re-uploaded.
- Device, EXECUTED: 2 items "By album" -> 3 files (one item is in two albums), sizes equal to Photos' `size_bytes`
  (3,782,399 and 3,391,061 bytes), `sha256sum -c SHA256SUMS.txt` on the phone: all OK; the manifests list the albums and
  remote keys. Pause / Resume and a failing download, EXECUTED: 9 items "Year and month"; Pause stopped after the
  current file (2 of 9); Photos force-stopped; the reopened page showed "Paused. Exported 2 of 9". One item's URL was
  corrupted in the job file on purpose. Resume: 8 exported, 1 failed, listed in `report.txt`; `sha256sum -c
  SHA256SUMS.txt` all OK; no partial file left. Fixed during this test: counters and layout are now restored from the
  journal after a restart. Originals can take about 90 s each.

### Organize albums (removed 2026-11-20)
- Taken out of the tools menu (the generator no longer runs): the Albums filter chip already offers "No album" and "In 2
  or more albums", and Add to album is in the selection sheet. Remove from album and add-to-several went with it. The
  record of what was built and tested is kept below.
- Works on the selection (touch and hold items first; at most 900 per action): which albums the selected items are in
  ("k of n"), **Remove** from the user's own albums (after a confirm; the items stay in the library and in their other
  albums), **Add to albums** (several at once: the existing Add to album path once per album), and "Show items in no
  album" / "Show items in 2 or more albums" as filters.
- Remove uses Photos' own `RemoveFromCollectionTask` (kept class name), given the same media list and album object Add to
  album builds from DexKit symbols, run through the same synchronous task runner with the same failure check.
- Device, EXECUTED (album "Aay", with the user's permission): the preview, and Add to 1 album
  (`P1374376-ANIMATION.gif`; the preview then read "Aay, 1 of 1" from Photos' records). Remove from "Aay", EXECUTED after two fixes found on the device: Add to album's
  album object wraps the album's media collection (the task needs the collection itself: taken from the wrapper's only
  field of that type), and the collection must carry the task's features (Photos' media loader, its one static
  (Context, collection, FeatureSpec) method, with the task's own static FeatureSpec). Log "Remove from album: 1 removed";
  Photos' DB afterwards: no row of the item in the album, the album back to its 10 items, the item still in the library.
  The page now re-reads the albums 3 s after a write (an immediate re-read still showed the album; NOT RUN since).
- Smart organization rules (automatic moves) are not offered.

- First similar-photos scan, faster (2026-11-20, EXECUTED, main library, 25,300 photos, hash cache emptied for each run):
  before, 16 threads and a disk-synced cache row per photo: about 24 photos/s, about 18 minutes extrapolated. Every
  write waited for a sync while holding the cache file's single lock. Now 48 threads, no per-row sync (`PRAGMA
  synchronous=0`; it is a cache) and a 10 s read timeout on the scan's own threads (a ThreadLocal; downloads and exports
  keep 60 s), after one stuck request held the end of a scan for a minute. Measured: 122 to 151 photos/s (the network
  varies), the whole first scan in under 3 min 36 s. Result 1,736 groups, 3,863 items; the 1,735 / 3,863 of the earlier
  run came from a partly filled cache. Exact copies opens in under a second after a Photos restart (unchanged).

### Performance pass (2026-11-20)
- Float setters (alpha, translation, scale, rotation, corner radius, elevation: about 60 call sites) go through
  reflection, because XAX has no float type yet. Each call used to build a 4-String cache key, and `f70` (an older
  helper) looked the method up on every call; every value was a fresh `Float` parsed from a String. Now the method
  cache is three nested maps (no allocation on a hit), `f70` uses the same cache, and Floats come from a 256-slot cache.
  These per-call savings are read from the code, not measured on the phone.
- The pruner now runs last, so code the later Library Manager steps leave unreferenced is dropped too: 19 functions,
  5 State fields and 10 strings.
- Measured on the Pixel 8 Pro, EXECUTED: cold Photos start 179 ms to first frame (`am start -W`), PPE's symbol cache
  4 ms and hook installation about 20 ms (log timestamps). Library Manager grid flings (`dumpsys gfxinfo`, 120 Hz):
  frames p50 5 ms, p90 8 ms, p99 12 ms, 0.18 % janky, the same before and after; the day pill, scrubber, viewer,
  pull to refresh and search bar checked on screen afterwards.
- Not changed: the remaining reflection itself (blocked on float support in XAX).

## Not built
- Creating albums and permanent deletion: no verified write path. (Add to album, Trash and Recover storage are
  built; see above. Remove from album was built and verified, then removed with Organize albums.)
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
