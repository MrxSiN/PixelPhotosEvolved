## Unreleased: 1.2.2-dev / 28

Development build **1.2.2-dev / 28** restores the profile entry and full settings
page on Photos **7.98.0.1007591100 / 52591217**. DexKit 2.3.0 discovers and installs a
read-only native Video Boost state observer. Backup identity, selective upload routing
and Storage Reclaim remain gated to **7.97.0.1000520730 / 52549361**; on 7.98 they are
inactive. The settings page shows this limitation and disables the reclaim action.
No upload, deletion or reclaim was initiated by this compatibility check.

- Resolve profile resource IDs by name and preserve single-card placement.
- Show saved settings and diagnostics with an unsupported-host banner; prevent old
  native probes and disable the reclaim action on unsupported hosts.
- Bundle DexKit 2.3.0, native ARM64 JNI and dependency DEX; discover state signatures
  asynchronously and close the bridge on success/failure. Observe state without
  changing the original return value or native upload/reclaim gates.
- Build with XAX 054262b; fast-forward BBC/XAX and verify XAX-MCP is current.
- Preserve the historical BFX-1 policy binaries. Include dependency notices/licenses.
- 392 compiled checks, 400 concurrency cases and profile/settings device checks pass.

## Retained 1.0.0 release notes

First stable release of Pixel Photos Evolved: unlimited backup and Video Boost controls for Google Photos, inside Google Photos itself (profile picture → **Pixel Photos Evolved**).

### Features
- **Unlimited Original Quality** — Pixel XL (2016) identity inside Google Photos only.
- **Unlimited Storage Saver** — identity of a selected older Pixel (Pixel 2 to Pixel 5a). Mutually exclusive with Unlimited Original Quality.
- **Video Boost** — Video Boost recordings upload with the phone's real identity so Google can process them; other backups keep the backup identity.
- **Compatibility & diagnostics** — module, system and per-feature compatibility, with optional diagnostic logging.

### Requirements
Android 17 (API 37) ARM64, libxposed API 102 (tested with Vector 2.2), Google Photos 7.97.0.1000520730. Scope: `com.google.android.apps.photos`. Force-stop Google Photos after enabling.

Google decides backup eligibility and storage accounting on its servers. Check your account storage after enabling a backup option.
