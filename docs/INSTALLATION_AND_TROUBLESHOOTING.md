# Installation and troubleshooting

Use the [0.6.6-dev APK](../module/pixel_photos_module-signed.apk) with Vector
2.2 / API 102 on the tested Pixel 8 Pro, Android 17 API 37 and Photos
7.97.0.1000520730 / 52549361. Enable the module in Vector and scope it to
`com.google.android.apps.photos` for the intended Android user. Force-stop and
reopen Photos after installation or updates.

The APK uses a public development test key. It is not a production release.
Unsupported host combinations retain native behavior; the temporary-upload
native profile additionally requires the captured physical Pixel 8 Pro model.

## In-Photos controls

Open Photos → profile/account menu → **Pixel Photos Evolved**, immediately
before **Your data in Google Photos**. There is no separate launcher or settings
Activity. Preferences persist in Photos' pixel_photos_evolved namespace.

| Control | Effect |
|---|---|
| Enable module | Master for overrides and scanning; startup identity already applied persists until Photos restarts |
| Pixel XL backup identity | Startup identity, local backup offer, property reads and additive feature flags; changes require Photos restart |
| Video Boost detection and native uploads | Candidate diagnostics, native state observation and experimental operation-scoped native routing for verified temporary assets |
| Verbose diagnostics | Extra sanitized policy messages |

Native Google Photos **Backup** is a separate setting. Automatic backup was
tested with it on; manual per-recording backup was tested with it off. The module
does not require switching account-wide backup off. Native Boost uploads/output
may count toward quota. The tested enabled original was uncharged while the
boosted result was charged; this is not a universal entitlement.

The native state label reports the last recognized state in this Photos process.
A Processing label alone is not completion evidence. Disabling detection/routing
prevents new decisions; already marked work retains its native identity through
finalization. Restart after code updates; hot reload is unsupported.

## Recovery and diagnostics

If the entry is missing, check the exact Photos build, Android user and Vector
scope, then restart Photos. Failed signature/policy checks retain native behavior.
If Photos cannot open, disable the module in Vector and restart Photos. Do not
clear Photos data as a troubleshooting step.

For ADB checks, select the intended device explicitly when USB and wireless
connections coexist. Filter by the current Photos PID and PixelPhotosEvolved tag;
old buffers can contain earlier candidates and the small ring can roll quickly.
Capture sanitized events continuously when testing. Keep account identifiers,
authentication values, media paths and upload tokens out of reports.

See [Video Boost](VIDEO_BOOST.md), [status](../report/STATUS.md) and
[evidence](EVIDENCE.md) before interpreting quota or state messages.
