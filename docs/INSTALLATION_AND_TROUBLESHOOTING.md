# Installation and troubleshooting

Install the APK from the [latest release](https://github.com/MrxSiN/PixelPhotosEvolved/releases/latest)
or the [Xposed Modules Repository](https://modules.lsposed.org/module/io.github.mrxsin.pixelphotosevolved).
Tested with Vector 2.2 / API 102 on a Pixel 8 Pro, Android 17 API 37 and Photos
7.97.0.1000520730 / 52549361. Enable the module in Vector and scope it to
`com.google.android.apps.photos` for the intended Android user. Force-stop and
reopen Photos after installation or updates.

Release APKs are signed with the release key. Version 1.0.0 changed the package
from `io.github.pixelphotosevolved` to `io.github.mrxsin.pixelphotosevolved`:
uninstall the old package before installing. Settings live in Photos' data and
are kept. Unsupported host combinations retain native behavior; the
temporary-upload native profile additionally requires the captured physical
Pixel 8 Pro model.

## In-Photos controls

Open Photos → profile picture → **Pixel Photos Evolved**, its own card above
**Your data in Google Photos**. There is no separate launcher or settings
Activity. Preferences persist in Photos' pixel_photos_evolved namespace.

| Control | Effect |
|---|---|
| Unlimited Original Quality | Pixel XL startup identity, local backup offer, property reads and additive feature flags; changes require a Photos restart |
| Unlimited Storage Saver | Same, with the identity of the selected **Pixel model** (Pixel 2 to Pixel 5a); turns Unlimited Original Quality off and the reverse |
| Video Boost | Detection, native state observation and operation-scoped native routing for verified temporary Video Boost uploads |
| Latest video | Last Video Boost state Photos reported |
| Compatibility & diagnostics | Module, system and per-feature compatibility; **Diagnostic logging** adds sanitized policy messages |

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
