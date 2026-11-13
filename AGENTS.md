# Pixel Photos Evolved: rules for agents

## Languages
- The whole project is written in **Brainfuck and XAX only**. Module code is an XAX carrier
  (`module/pixel_photos_module.xax`); the backup policy is Brainfuck compiled with BBC
  (`policy/`, `module/libppepolicy.so`). Add no other source language to this repository.
- Build and porting helpers are transport tooling and live outside the repository.

## No hard-coded Photos names
- Never hard-code obfuscated Google Photos names (classes, methods, fields, builder letters,
  stack-trace allowlists) anywhere in the project.
- Find every Photos symbol at runtime: DexKit rules (anchored on strings, kept class names,
  signatures, enum constant names), the declared type of a field on a class already found,
  or a protobuf field number read from the message's own message info.
- A symbol that is not found stays missing and its feature fails closed (logged, pass-through).
- Kept (non-obfuscated) framework, SDK and protobuf runtime names are fine.

## Core principles (SOLID)
- **Single Responsibility:** a function or module has one, and only one, reason to change.
- **Open/Closed:** open for extension, closed for modification.
- **Liskov Substitution:** subtypes must be substitutable for their base types.
- **Interface Segregation:** clients do not depend on interfaces they do not use.
- **Dependency Inversion:** depend on abstractions, not on concrete implementations.

## General practices
- **DRY:** every piece of knowledge has one unambiguous representation.
- **KISS:** keep it simple; avoid unnecessary cleverness.
- **YAGNI:** do not add functionality until it is necessary.
- **Law of Demeter:** talk only to immediate friends, not to the innards of other objects.
- **Boy Scout Rule:** leave the code cleaner than you found it.
- **Separation of Concerns:** each part addresses one concern.

## Tools
- BBC, XAX and XAX-MCP (XAX pinned in `toolchain.lock.json`); adb (module log: logcat tag `PixelPhotosEvolved`)

<!-- ecosystem-policy v1 (2026-11-13): identical in every MrxSiN first-party repository. Change it everywhere in one coordinated set of PRs, never in one repository alone. -->
## Ecosystem rules (v1)

Shared by MrxSiN's first-party repositories. Any other rule in this file that is stricter or more specific to this repository wins.

- **Who owns what.** XAX owns the semantic graph, verifier, compiler, ABIs, backends, targets and artifacts. BBC owns the Brainfuck frontend, BFX and Brainfuck-specific optimization. XAX-MCP owns MCP transport, tool schemas, sandbox and permissions. Dependencies point one way: consumers -> XAX-MCP / BBC -> XAX.
- **New production logic** is XAX, or Brainfuck + XAX, wherever the toolchains reach the target; this repository's own language rules say where that is. Existing code in other languages is tracked migration debt, not permission to add more. Declarative config, assets, fixtures and licenses are not code to convert.
- **Upstream first.** When a toolchain lacks something this repository needs: reproduce it on the toolchain's latest `main`, search its issues and PRs, then fix a small bounded gap with a PR in the owning repository, or open (or link) an issue for a large one and mark only the affected work blocked-upstream. No consumer-side shims, private toolchain forks or local toolchain patches.
- **Pins.** Build against exact toolchain commits, recorded in one machine-readable place. Check the toolchains' latest commits before nontrivial work; move a pin by reviewed PR once checks pass, and write down why when an older pin stays.
- **No hardcoding** of secrets, personal or machine paths, toolchain locations, obfuscated host names or version-specific offsets. Machine-local paths belong in your own `~/.claude/CLAUDE.md` or `CLAUDE.local.md`, never in the repository. Specification constants (opcodes, ABI layouts, protocol markers, security limits) are fine when named and documented.
- **Design.** SOLID, DRY, KISS, YAGNI, Law of Demeter, Boy Scout Rule and Separation of Concerns, applied with judgment. They never override correctness, safety, verified state or evidence quality.
- **Evidence.** Report only what actually ran: EXECUTED, MEASURED, NOT RUN or BLOCKED, with the reason. Emulator, Wine or qemu runs are not device runs. Never rewrite old evidence; add new.
- **Git.** Work on a branch from the default branch and land it by pull request; the owner reviews and merges. No force-push to the default branch, no history rewrites. No AI attribution in commits, PRs or comments; commits use the repository's git identity. PR titles say what changed in plain words.
- **Security.** Report vulnerabilities privately, never in a public issue. Never print or commit tokens.
<!-- /ecosystem-policy v1 -->
