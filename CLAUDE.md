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
- BBC: `D:\GitHub\BBC`
- XAX: `D:\GitHub\XAX`
- XAX-MCP: `D:\GitHub\XAX-MCP`
- adb: `D:\Android\platform-tools` (module log: logcat tag `PixelPhotosEvolved`)
