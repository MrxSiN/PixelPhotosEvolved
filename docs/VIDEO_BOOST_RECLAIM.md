# Video Boost Storage Reclaim

Release **1.1.1 / 37** on Google Photos **7.98.0.1007591100**.

Videos processed with Video Boost count toward your Google Account storage, even when an
unlimited backup option is on. Since 1.1.4 the same engine also re-uploads ordinary photos and videos that use
storage, started from Library Manager's **Recover storage** (see [Library Manager](LIBRARY_TOOLS.md)); their file
name, MediaStore table and MIME type come from the item. Reclaim downloads each selected video, deletes its cloud copy
(also from Trash) and uploads the same bytes again with your Backup setting, so the new copy
stops using storage. Reuploaded videos keep their full quality but lose their Video Boost tags
and links. Videos are not re-encoded.

## Use

1. Open Photos → profile picture → **Pixel Photos Evolved** → **Video Boost Storage Reclaim**.
2. Tap **Scan Video Boost**. A wavy indicator runs while Photos' cached cloud records are read;
   afterwards the summary shows how many photos and videos were checked.
3. The **Videos** section appears when the scan finds boosted videos that use storage. Sort them
   with **Newest**, **Oldest**, **Largest** or **Smallest**.
4. Select videos. The bottom bar has **Select all**, **Deselect all** and **Invert selection**
   (long-press an icon to see its name) and **Reclaim selected**, which is enabled once a video is
   selected. The summary shows **Using storage** and, with a selection, **Selected**.
5. **Reclaim selected** opens a confirmation with the amount to free, the four steps and the
   cautions. **Start reclaim** begins the job.
6. The **Progress** card shows the current video's thumbnail, its step (of seven) and the bytes
   being copied. Its circular indicator fills during download and upload and spins on steps
   that have no measurable amount. **Pause reclaim** and **Resume reclaim** are in the card;
   the bottom bar is hidden while a job runs or can be resumed.
7. **History** lists finished videos with their date, size, whether a copy is on the phone and
   the result.

## Safety

- One video at a time. A safe copy stays on the phone until each video is done, and a journal
  lets an interrupted job resume from where it stopped.
- Only the selected cloud video and its own Trash copy are deleted. Other Trash items are never
  touched.
- The last step checks Photos' records for the new copy's storage use. Google decides the final
  storage use, and Google's storage page can take a while to update.

## Download step (1.1.5)

Step 2 (download) takes the original from, in order:
1. a copy already on the phone (Photos' `local_media` row with the same dedup key and size);
2. PPE's own signed-in download of the original (`=d`, videos `=dv`; 20 s connect and 60 s read
   timeouts, 3 tries 2 s and 4 s apart). It is used only when the file's SHA-1 equals the item's
   dedup key and its length equals the item's size, so it is the original file, byte for byte
   (Google's `=d` bytes hash to Photos' `dedup_key`, checked on the phone 2026-11-23);
3. Photos' own download task, waited for up to 5 minutes, as before.

When step 2 downloads the whole file and its bytes are not the original, Google Photos has only an
edited or compressed version of the item (for an edited photo `=d` serves the edited render: checked
on the phone 2026-11-25, 186,586 bytes and another SHA-1 for an item whose original is 178,566
bytes). Photos' download task would save those same bytes as one more copy on the phone on every
run and never match, so it is not started: the item is `excluded` at once with the reason "Excluded:
Google Photos only has an edited or compressed version of this item, not the original. Nothing was
deleted."

Nothing has been deleted at this step. If it fails for a reason other than Pause or an account
switch, the item is **skipped**: it keeps step 0, its journal entry records the reason (`status`)
and the number of failed runs (`fails`), and the next item starts. The run ends with "Done. N items
were skipped and left unchanged. Tap Resume to retry them." Resume retries them first. After 3 failed
runs an item is marked `excluded`: it stays in the journal unchanged (never counted as done) and no
longer keeps Resume or a new Recover storage waiting; select it again to retry it. From step 3 on
(a verified copy exists, deletes follow) a failure still stops the job, as before.

## Progress and items (1.1.5)

- **Progress card:** under the current item, seven step bars (done, now, stopped, paused) and a checklist of what
  is already proven for it: where the original came from ("Copy found on this phone", "Downloaded from Google, checked
  byte for byte" or "Downloaded by Google Photos"), "Same SHA-1 as Google's original", "Safe copy kept on this phone",
  "Old cloud copy removed" and "Uploaded again".
- **Items** (was History): "k of n done", a bar of done / skipped / left, and filter chips with counts (All, In
  progress, Done, Skipped). Each row shows the thumbnail, name, size and state ("Step 3 of 7 · Removing from cloud",
  "Waiting", the reason it was skipped), the item's own step bars, a status pill and, for the item being downloaded,
  its download bar. 40 rows at a time; Show more adds 40. The list refreshes while a job runs (at most once a second, so a fast queue does not freeze the page).
  When nothing runs or can be resumed, the Progress card is hidden.
- **Tap an item:** its seven steps with what each did (the source, the SHA-1 check) or why it stopped, and its
  details: file, size, dedup key, SHA-256 of the safe copy, the safe copy's path (or "Not created yet"), source,
  failed attempts and last update; all selectable. For an item still at step 1 while nothing runs, **Skip this item**
  excludes it (as after 3 failed runs) and **Retry** clears its failures. Nothing else on the page changes the journal.

Items are identified by account and dedup key everywhere (journal, recovery file name
`<account>_<sha256(dedup)><ext>`, download source), never by file name, so different photos with
the same name (`IMAG0002.jpg` three times) are separate items. The direct download's staging file
is one path in Photos' cache (one item at a time) and is deleted after every item. Logcat tag
`PixelPhotosEvolved` shows `Reclaim download: ...` for the chosen source and `Reclaim skipped ...`
with the reason. While the worker runs, progress text is written to the journal at most once a second (every
step's own result is still committed at once); the end of a run writes the rest. Item thumbnails look up the cloud copy by
its dedup keys only; the file-name fallback is kept for Video Boost names (`.VB-`), so a same-name photo never lends its
thumbnail.

## Finalization

After the upload, PPE asks Photos to record the new cloud copy and link the local video to it.
Photos checks that the reply's owner is an account known to Google Play services. For some
reuploads that lookup fails although the item is in the account (`NON_MATCHING_GAIA_BACKEND_
GAIA_ID_INVALID`). In 1.1.1 PPE accepts that check only for its own write, on the thread doing it;
every other caller in Photos gets the real result. If a future Photos build changes the verifier,
PPE leaves Photos' check in place and a failure stops the job as before.

Until 1.1.4 the verifier class was looked up by its 7.98 name, which names another class from Photos 7.99
on, so finalization failed there (seen on 8.1, 2026-11-18). It is now the only class using the string
"Account store GAIA ID does not match backend GAIA ID" (a DexKit rule, symbol `actor.v`; 8.1 resolves it
on the phone). PPE still checks the method's shape (two parameters, an enum result with `VERIFIED_OK`)
before hooking; no match or no symbol leaves Photos' check in place.

After the cloud delete, PPE now waits up to 30 seconds for Photos' records to drop the old copy before
it reports "Delete not finished yet" (once it stopped a job that would have passed a few seconds later).

## Results

1.1.5 (2026-11-23, Pixel 8 Pro, Photos 8.1): an animation (4.5 MB) and a cinematic video (780 KB) from Library
Manager > Recover storage both took the direct download (exact SHA-1), finished all seven steps, and Photos' records show
0 bytes charged for each; see [build record](../report/build-1.1.5-dev.json).

On a Pixel 8 Pro with Photos 7.98, six boosted test recordings were reclaimed: each new copy is
charged 0 bytes and stored once in Photos' database. See the
[build record](../report/build-1.1.1.json) for what was and wasn't exercised on the device.
