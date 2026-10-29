# DexKit symbol resolution — 1.4.1-dev / 33

Checked 30 October 2026 on Pixel 8 Pro, Google Photos 7.98.0.1007591100.

## What changed

Before 1.4.0, every backend hook named obfuscated Photos classes that were pinned to one Photos
build. Each Photos update turned the features off until the names were remapped by hand. Now
the module resolves those classes at runtime with DexKit, from rules that do not depend on the
obfuscated names.

1.4.0 still pinned three classes to 7.98. 1.4.1 adds rules for them, so **no class depends on
a pinned name any more**:

| Class (7.98 name) | Role | Rule |
|---|---|---|
| `cqfs` (`cpmz`) | Router stage-4 client-info protobuf message | Its protobuf message-info string contains a piece no other class has. The piece is shipped JSON-escaped and matched with DexKit `Contains`, because DexKit cannot match strings that contain NUL characters |
| `bnwx` (`bnif`) | Router stage-4 client-info class | The only class with a non-abstract, non-static no-argument method returning `cqfs` |
| `abzm` (`abwr`) | Backup-offer caller | The type returned by method `p()` of the onboarding fragment, which is found by two of its own strings |

The rule counts are now:

| Rule | Count | Meaning |
|---|---:|---|
| String anchor | 50 | The class uses these strings, and no other class does (one matches a piece of a string) |
| Member signature | 16 | A method or field of an already-resolved class has this type shape (6 also use the member's name) |
| App-wide method signature | 7 | The only class declaring a method with this signature and abstract/static/constructor shape |
| Abstract-method count | 2 | The only class with exactly *k* abstract no-argument methods returning a resolved type |
| Caller / superclass / interface / subclass+string | 4 | Call-graph and hierarchy relations to resolved classes |

Every rule was derived from the Photos 7.97 and 7.98 DEX files and kept only if it gives the
correct class on **both** builds. The rules are in
[dexkit-rules-1.4.1.json](dexkit-rules-1.4.1.json).

Besides classes, DexKit also provides:
- the protobuf builder methods (copy-on-write and build), found by which methods they call;
- the backup-offer caller allowlists, taken from the callers of the generation provider. With
  `abzm` resolved, the list DexKit builds is complete, and the 7.98-only replacement list was
  removed.

Member lookups first try the known name. If that is missing, they fall back to the only declared
method with the same parameter types.

## Runtime

The symbol table is cached in Photos app data (`ppe_symbols`), keyed by Photos
`versionCode/lastUpdateTime` and the rule-set hash. DexKit scans only on the first start after a
Photos update or a rule change. The backend gate is Android API 37, ARM64, and every required
symbol resolved. If anything is missing, the backend stays off and the log lists the missing keys.
The verified 7.98 names are still compiled in, but only to count disagreements in the log and to
fill a gap on that exact build.

## Device result (7.98)

- **First start:** all 79 classes plus the 4 derived entries resolved through DexKit in
  **1671 ms**. The log reads `pinned fill 0, differ 0; missing []`.
- **Later starts:** cache load in 2 ms.
- **Features:** router, identity, Video Boost observer and backup offer hooks installed; backup
  probe passed.

## Limits

- `abzm` depends on the getter keeping the name `p`. That name is the same in 7.97 and 7.98, but
  it is the weakest of the new rules.
- A future Photos build can still change a string or signature that a rule depends on. The log
  then names the missing keys, and new rules can be derived with the same tooling.
- No Photos build newer than 7.98 was available to test against.
