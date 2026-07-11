# CLI::Simple 2.0.13 Release Notes

## Overview

This is a maintenance release focused on documentation quality and
build tooling improvements. Version 2.0.13 fixes a POD error
introduced in a previous release and adds automated POD validation to
the build system.

## Changes

### Bug Fixes

- **Fixed malformed POD in `lib/CLI::Simple.pm.in`** — Removed a
  spurious `=back` directive that was not paired with a corresponding
  `=over`, which caused a POD parsing error. This resolves the `POD
  ERRORS` section that was appearing at the bottom of the generated
  `README.md`.

### Build System

- **Added `podchecker` integration to `.includes/perl.mk`** — POD
  validation is now automatically run as part of the syntax-checking
  step for both `.pm` and `.pl` files. If a file contains invalid POD,
  the build will fail and report the error. Files that contain no POD
  pass silently. This prevents malformed documentation from being
  shipped in future releases.

### Documentation

- **Regenerated `README.md`** — The `POD ERRORS` section has been
  removed from the generated README, and minor whitespace
  inconsistencies in code examples have been cleaned up.

## Upgrade Notes

No API or behavioural changes are included in this release. Upgrading
from 2.0.12 is safe and requires no changes to existing code.

## Files Changed

| File | Change |
|---|---|
| `lib/CLI/Simple.pm.in` | Removed stray `=back` directive |
| `.includes/perl.mk` | Added `podchecker` to syntax-check macros |
| `README.md` | Regenerated; POD errors section removed |
| `VERSION` | Bumped to `2.0.13` |
