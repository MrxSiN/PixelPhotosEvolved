# Policy ABI

The policy is `pixel_photos_policy.bf`, compiled by current BBC (`bbc compile android-arm64 -O1`)
to a static ARM64 stdio executable (`module/libppepolicy.so`); see the `bbc` pin in
[toolchain.lock.json](../toolchain.lock.json). ABI 1 and the policy source are unchanged since
the validated 0.4.0 baseline. On the device, 21,480 vectors give byte-identical output to the
earlier BFX-1 build. The XAX bridge requires an array of exactly eleven bytes, exit status zero
and exactly two output bytes within two seconds. Bridge errors keep native behaviour.

| Byte | Field | Meaning |
|---|---|---|
| 0 | v | ABI version, exactly 1 |
| 1 | op | 1 backup; 2 Boost cover; 3 temporary job; 4 processed result; 5 local offer |
| 2 | mc | 1 cover; 2 main; 3 confirmed processed main; 4 unknown |
| 3 | ws | 1 metadata validated; 2 temporary request confirmed; 3 result confirmed |
| 4 | cap | 1 native capability; 2 verified modern path |
| 5 | m | master switch, exactly 1 |
| 6 | x | Unlimited-backup preference (Original Quality or Storage Saver; 0.6.5+), exactly 1 |
| 7 | s | smart routing preference, exactly 1 |
| 8 | b | verified operation boundary: local offer for op5, scoped request for op3/4 |
| 9 | xb | distinct verified Pixel XL upload boundary, exactly 1 |
| 10 | e | 1 observed native editing; 2 verified override; otherwise none |

| Output | Values |
|---|---|
| 0 | 0 pass-through; 1 Pixel XL upload policy; 2 native; 3 modern compatibility; 4 local offer eligibility |
| 1 | 0 none; 1 native editing; 2 override eligible |

Policy 1 requires v=m=x=xb=1 and one of:

- op=1;
- op=2, mc=1, ws=1;
- op=4, mc=3, ws=3, s=b=1.

Policy cap+1 requires v=m=s=b=1, op=3, ws=2, mc in {2,3}, cap in {1,2}.
Capability 1 therefore returns policy 2; capability 2 returns policy 3.

Policy 4 requires v=m=x=b=1 and op=5. This authorizes the **local backup offer**
override only, not upload identity. It does not assert xb. Other fields are
irrelevant for this operation. The runtime keeps xb zero: Pixel XL identity is
applied at process startup, not at a distinct per-upload Pixel XL boundary.
The verified temporary native-upload path uses op3 with b=1 and actual input
bytes [1,3,2,2,1,1,1,1,1,0,0], producing policy 2. It does not introduce a
per-upload Pixel XL decision or change the ABI. See
[Video Boost boundaries](../docs/VIDEO_BOOST.md).

The editing output is e only when v=1 and e is 1 or 2, independently of the
backup gate. All unmatched inputs output policy zero. The BF program reads
exactly eleven bytes and ignores trailing bytes. BF EOF reads as zero; it cannot
distinguish a missing byte from a literal zero. Truncation is rejected by the XAX
array-length check rather than inferred by BF.

The original cell layout is documented in the source header. The local-offer
extension reuses consumed input/scratch cells after the upload/editing terms
are calculated. The program uses 3,279 of the bounded BBC frontend's 3,840
command limit, 25,814 source bytes and at most two nested loops. Comments must
avoid all eight Brainfuck command characters; punctuation can otherwise become
executable code. The current BBC record is 3,289 bytes.

Current retained independent policy verification: **18,187 BF vectors and
128 exact packaged ARM64 vectors**, zero failures. The 0.6.1 native temporary
upload also exercised actual compiled policy 2 on-device. Smaller scaffold counts
were superseded and their reports removed during cleanup.

From 0.6.5 the runtime sets x when either unlimited backup option is on. The policy bytes and ABI
are unchanged: the compiled decision still only says whether the startup identity applies. Which
profile (Pixel XL, or the selected Storage Saver model) applies is chosen in XAX from the settings.
