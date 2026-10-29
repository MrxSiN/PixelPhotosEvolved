# Settings and Reclaim UI — 1.3.1-dev / 30

Checked 29 October 2026 on Pixel 8 Pro, Android 17 API 37, Google Photos
7.98.0.1007591100, in dark and light themes. Fixture-signed development build; see
[build-1.3.1.json](build-1.3.1.json).

## Settings

- The back arrow is gone from every PPE page. System back is unchanged: it still goes through
  the page's `OnBackInvokedCallback`. That callback now registers at `PRIORITY_OVERLAY`; at
  priority 0, the account sheet's own handler (re-registered when Photos resumed, for example
  after returning from the media viewer) closed the whole sheet.
- **Pixel model** is greyed out and ignores taps while Unlimited Original Quality is on. It
  updates as soon as either backup switch changes.
- Video Boost description: "Only available on Pixel 8–11 Pro series, including XL and Fold
  models."

## Video Boost Storage Reclaim

| Area | Implementation |
|---|---|
| Header | Title with the selection/sort/filter overflow menu at top right (Photos' `gs_more_vert` icon, 48 dp target) |
| Progress | Existing seven-step reclaim progress in a card; Pause appears only while a reclaim is running; duplicate status line removed |
| Summary | Scanned cloud items, chargeable boosted videos with total charge, selected count with potential recovery, last scan time in the locale's format, scan completeness or error |
| Scan | Primary Material button; shows "Cancel scan" while scanning |
| List | Default filter is chargeable videos, sorted newest first. Each row has a thumbnail, filename (middle-ellipsized), date · resolution · duration · on this device/cloud only, storage used · file size, status and a checkbox. Tapping the row or the checkbox selects it; tapping the thumbnail opens the Google Photos viewer and never starts a reclaim. 50 per page; Previous/Next appear only when needed |
| Bottom bar | Pinned outside the scroll view, above the navigation bar, shown once something is selected, a reclaim is resumable, or one is running: count, recoverable size, **Reclaim selected** (or Resume). The page reserves space so the last row stays reachable. Removed on back |
| Empty states | Scanning; canceled; incomplete; unsupported Photos or no account; account changed; no network; storage metadata unavailable; every boosted video already uses no storage; no chargeable videos; no match for the current filter. "None found" is shown only after a finished scan |
| Theme | Colours come from Photos' Material attributes (`colorSurfaceContainer*`, `colorOnSurfaceVariant`, text appearances), and Photos' own `MaterialButton`/`AppCompatCheckBox`. Light and dark both checked |

Row metadata comes from the scanned `remote_media` record: filename, `capture_timestamp`,
duration, width/height, size and charged bytes. `capture_timestamp` holds local wall-clock
time stored as UTC, so dates are formatted in UTC; this matches the PXL filename date.
Thumbnails load off the main thread: the local `content://` URI comes from the record or,
failing that, `local_media` by dedup key and size, then `ContentResolver.loadThumbnail`. When
no local copy exists, the row keeps a video placeholder and says "Cloud only".

Device check: a scan read 74,145 records and listed 2 chargeable videos. One resolved to a local
thumbnail; one is cloud-only. Selecting a video showed the bar ("1 selected · 37.10 MB
recoverable"). The thumbnail opened the Photos viewer. Back went viewer → Reclaim → settings →
profile menu. Preferences and the reclaim journal hash were unchanged. No reclaim, upload or
deletion was started.

## Limits

Cloud-only videos have no thumbnail: Photos' cloud thumbnails need its authenticated image
loader, which is not reached here. Codec, frame rate, upload date, album warning and
per-item reclaim history are not shown, because the scanned record does not carry them. The
"no network" and "metadata unavailable" empty states were not triggered on device.
