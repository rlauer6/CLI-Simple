# CLI::Simple 2.2.1 Release Notes

## Overview

This is a patch release of `CLI::Simple`, a minimalist object-oriented
base class for building CLI applications using the modulino
pattern. Version 2.2.1 delivers a bug fix for alias injection in
role-based applications, two new build include files, and dependency
version bumps.

---

## What's New

### Bug Fix: Alias Injection from YAML Manifest

The inherited `main()` method in role-based applications now correctly
reads the `alias` key from the YAML manifest and passes it to the
constructor. Previously, aliases defined in the manifest were silently
ignored when using the `:roles` architecture.

```yaml
# my-script.yml
alias:
  commands:
    ls: list
  options:
    cfg: config
```

This key is now properly forwarded:

```perl
my $cli = $class->new(
    ...
    alias => $manifest ? ( $manifest->{alias} // {} ) : {},
    ...
);
```

---

## Build System Changes

### New: `.includes/bash-completion.mk`

A new managed include file providing a `bash-completion` Make target,
now tracked and updated by `CPAN::Maker::Bootstrapper`.

### New: `.includes/modulino.mk`

The inline `modulino` target previously embedded directly in
`Makefile` has been extracted into a dedicated managed include file
(`.includes/modulino.mk`). The `Makefile` now delegates to this
include.

### Updated: `.includes/help.mk`

The `help` target has been improved:

- Help output is now buffered to a temporary file before display.
- Output is routed through a pager (`$PAGER`, `less`, `more`, or `cat`
  as fallback) rather than printed directly to the terminal.
- Variable documentation has been refreshed:
  - Added `SYNTAX_CHECKING=OFF` and `SKIP_TESTS=1`.
  - Removed `MODULINO_NAME` (no longer applicable).
  - Improved formatting of examples.

### Updated: `.includes/release-notes.mk`

- The `release-notes` target now supports dry-run mode: if the
  `DRYRUN` environment variable is set, `cmb release-notes` is invoked
  with `--dryrun`.
- The target description comment has been moved inline (now picked up by `help`).

### Updated: `.includes/update.mk`

- `bash-completion.mk` and `modulino.mk` are now listed in
  `MANAGED_FILES` and will be kept in sync on `make update`.
- The `Makefile` update step now runs **after** `post-update`
  (previously it ran before), ensuring managed `.includes/` files are
  updated before the top-level `Makefile` is overwritten.

---

## Dependency Updates

| Module | Previous | New |
|---|---|---|
| `File::Which` | 1.23 | 1.27 |
| `JSON` | 4.07 | 4.10 |
| `Role::Tiny` | 0 (duplicate entry) | 2.002004 |
| `List::Util` | 1.56 (explicit) | removed (core) |

The duplicate `Role::Tiny` entry (with version `0`) in `cpanfile` and
`requires` has been consolidated to the single minimum version
`2.002004`.

---

## Upgrade Notes

- If you are using role-based architecture (`:roles`) with a YAML
  manifest that defines `aliases`, this release is a **recommended
  upgrade** — aliases were previously silently dropped.
- No changes to the public API. Existing single-module and role-based
  applications are unaffected beyond the alias fix.
- Run `make update` to pull in the new managed include files
  (`bash-completion.mk`, `modulino.mk`) if you are using
  `CPAN::Maker::Bootstrapper` to manage your project.
