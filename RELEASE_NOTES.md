First stable release of Pixel Photos Evolved: unlimited backup and Video Boost controls for Google Photos, inside Google Photos itself (profile picture → **Pixel Photos Evolved**).

### Features
- **Unlimited Original Quality** — Pixel XL (2016) identity inside Google Photos only.
- **Unlimited Storage Saver** — identity of a selected older Pixel (Pixel 2 to Pixel 5a). Mutually exclusive with Unlimited Original Quality.
- **Video Boost** — Video Boost recordings upload with the phone's real identity so Google can process them; other backups keep the backup identity.
- **Compatibility & diagnostics** — module, system and per-feature compatibility, with optional diagnostic logging.

### Requirements
Android 17 (API 37) ARM64, libxposed API 102 (tested with Vector 2.2), Google Photos 7.97.0.1000520730. Scope: `com.google.android.apps.photos`. Force-stop Google Photos after enabling.

Google decides backup eligibility and storage accounting on its servers. Check your account storage after enabling a backup option.
