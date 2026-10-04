# CLI::Simple 2.2.5 Release Notes

## Overview

This release focuses on build system robustness and a compatibility
fix for `List::Util`. The module itself receives a targeted bug fix
and the test suite gains a graceful skip for optional dependencies.

---

## What's New

### Bug Fix: `get_args` Rewritten for Compatibility

The `get_args` method previously used `List::Util::zip`, which was
introduced in `List::Util` 1.56. This has been replaced with a direct
hash slice assignment, eliminating the dependency on that newer
`zip` function while preserving identical behaviour.

```perl
# before (required List::Util 1.56+)
my %args = map { @{$_} } zip \@vars, [ @{$command_args}[ 0 .. $#vars ] ];

# after (compatible with List::Util 1.33+)
@args{@vars} = @{$command_args}[ 0 .. $#vars ];
```

`List::Util` is now pinned to version 1.33 in both `requires` and
`cpanfile`.

Thanks to David Pottage for the PR https://github.com/rlauer6/CLI-Simple/pull/19

### Test Suite: Graceful Skip for Optional Dependency

`t/02-cli-simple-logging.t` now skips cleanly when
`Log::Log4perl` is not installed, rather than failing. Since
`Log::Log4perl` is a suggested (optional) dependency, this prevents
spurious test failures in environments where it is not present.

---

## Build System Changes

This release includes substantial updates to the
`CPAN::Maker::Bootstrapper`-managed build infrastructure. Notable
changes include:

- **Syntax checking decoupled from code generation.** `.pm` and `.pl`
  files are now generated and syntax-checked via separate sentinel
  targets (`%.pm.checked`, `%.pl.checked`), making incremental builds
  more correct and avoiding unnecessary rebuilds.
- **`deps.mk` is now a hard `include`** (not `-include`) when syntax
  checking is enabled, and depends on `.pm.in` source files rather
  than built `.pm` targets, eliminating the previous chicken-and-egg
  problem during `make clean`.
- **Dependency scanning** (`requires`, `recommends`, `suggests`,
  `test-requires`) is now fully gated on `SCAN=ON`. When scanning is
  disabled, targets fail explicitly if the files do not exist rather
  than silently succeeding.
- **`builder` script refactored** to accept a project directory
  argument (defaulting to the current directory) instead of cloning a
  repository. Branch checkout logic has been removed. The script now
  sources an optional `builder.env` file and calls `builder-pre` /
  `builder-post` hooks around the main `make` invocation.
- New managed files: `.includes/builder.mk`, `.includes/test.mk`,
  `builder.env`.
- Variable normalisation now uses a portable `lc` make function
  instead of shell `${var^^}` expansions, improving compatibility.
- `CMB_VERSION_DRIFT` and `CMB_UPDATE_CHECK` now accept `FAIL`,
  `WARN`, `IGNORE`, `ON`, and `OFF` (case-insensitive) and emit clear
  errors for unrecognised values.
- The `extra-files` git-check is now skipped when not inside a git
  repository.
- `cpanfile.darkpan` is now excluded from `make clean` and is
  explicitly un-ignored in `.gitignore`.

---

## Dependency Changes

| Dependency   | Change                              |
|--------------|-------------------------------------|
| `List::Util` | Added, pinned to 1.33 (minimum)     |

