# Video Boost Storage Reclaim

Release **1.1.1 / 37** on Google Photos **7.98.0.1007591100**.

Videos processed with Video Boost count toward your Google Account storage, even when an
unlimited backup option is on. Reclaim downloads each selected video, deletes its cloud copy
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

## Finalization

After the upload, PPE asks Photos to record the new cloud copy and link the local video to it.
Photos checks that the reply's owner is an account known to Google Play services. For some
reuploads that lookup fails although the item is in the account (`NON_MATCHING_GAIA_BACKEND_
GAIA_ID_INVALID`). In 1.1.1 PPE accepts that check only for its own write, on the thread doing it;
every other caller in Photos gets the real result. If a future Photos build changes the verifier,
PPE leaves Photos' check in place and a failure stops the job as before.

## Results

On a Pixel 8 Pro with Photos 7.98, six boosted test recordings were reclaimed: each new copy is
charged 0 bytes and stored once in Photos' database. See the
[build record](../report/build-1.1.1.json) for what was and wasn't exercised on the device.
