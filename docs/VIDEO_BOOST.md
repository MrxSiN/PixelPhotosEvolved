# Video Boost behavior — 0.6.1

Ordinary uploads retain the process-start Pixel XL baseline. Verified temporary
Video Boost uploads use captured real-device headers/client information. Global
Build values never toggle per upload. The module does not alter media or force
processing flags; Google Photos owns the upload protocol and cloud workflow.

## Eligibility and scope

Routing requires the supported Photos/API/ABI gate, captured physical Pixel 8 Pro
profile, master and detection controls, Photos' native **BLANFORD** job hint,
a trusted `content://media` asset, strict **VB-02.MAIN** filename grammar,
nonempty video/mp4 metadata and actual compiled ARM64 BF decision 2.
Filename candidates alone never authorize native identity.

The bounded MediaStore scan groups VB-01/02/03 candidates by recording ID, up to
500 rows. This diagnostic scan is separate from upload authorization. The native
observer hooks uxk.c(caly):uxi, preserves its return value, and decodes NeedsUpload,
Uploading, Processing, ReadyToPlay and PermanentlyFailedProcessing. Its status is
the last recognized process state, not a per-file job/completion tracker.

## Native boundaries

All six signatures, return types and instance modifiers are checked before
activation. Hooks use stable IDs and PROTECTIVE mode. Before startup spoofing,
the module captures actual model/manufacturer and a host-generated Cronet user
agent. It then installs the normal Pixel XL baseline.

| Boundary | Scoped behavior |
|---|---|
| ccdb.c(cccq,ccai):void | Reset reused provider context and mark eligible new upload |
| cdbs.a():Map | Copy marked uploader headers and replace only User-Agent |
| ccdb.j(ccbx,cccx):void | Retain verified job and opaque operation token after native finalization |
| ccad.c(ccbu,Runnable):void | Give verified job a private native queue; preserve session, job and callback |
| bnwx.g():cqfs | Clone matching singleton request/client; retain all media entries and other metadata |
| ccdb.f(cccx,String,cccj):ccbx | Restore eligible resumed-upload context; retain marked in-flight identity |

Synchronized weak maps follow provider, job, token and request-owner lifetimes.
Correlation uses immutable native **cqfp.e upload tokens**, never media
fingerprints. Tokens are not decoded, logged, exported or rewritten. The immutable
client snapshot follows the request owner across native RPC retries. Missing
tokens and unknown mixed batches pass through unchanged. The private queue keeps
ordinary items out of a native-identity finalization batch.

Disabling controls prevents new decisions; marked in-flight operations retain
their native identity through finalization. Covers, processed outputs and other
ordinary inputs are not routed as temporary raw assets.

## Verified results

Genuine manual and automatic temporary uploads completed with remote Blanford
format 1 and native routing events. Ordinary generated JPEG controls completed
with matching reported size/dimensions and zero charged bytes. The automatic
test verified native backup on / queue complete and left backup enabled.

The later independent two-recording comparison found:

| Module | Original charged bytes | Boosted charged bytes |
|---|---:|---:|
| Disabled | 11,401,750 | 8,176,531 |
| Enabled | 0 | 7,039,859 |

Both completed native format-2 outputs decoded fully at 2160×3840 AV1, with
128 and 134 frames and clean end-of-stream. Original means the retained unboosted
VB-01.COVER version, not temporary raw VB-02.MAIN. Temporary raw quota does not
determine the final boosted output charge.

The user identified capture-time module states. The agent independently checked
the selected quota records and decoded outputs; Original quality labeling remains
user-reported. See [independent validation](../report/INDEPENDENT_VALIDATION_0.6.1.md)
and the [evidence index](EVIDENCE.md) for provenance and limits. Live failure/retry/
cancel injection and simultaneous ordinary/Boost network uploads remain untested.
