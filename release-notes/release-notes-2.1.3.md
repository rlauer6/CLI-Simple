# CLI::Simple 2.1.3 Release Notes

## Overview

This is a maintenance release focusing on build system improvements,
documentation updates, and expanded optional dependency
declarations. No changes were made to core CLI::Simple functionality
or public APIs.

---

## What's New

### Optional Dependencies (`cpanfile`)

Three packages have been added as `suggests`-level dependencies,
reflecting their optional nature in the distribution:

| Module | Version | Purpose |
|---|---|---|
| `IO::Pager` | 2.10 | Pager support for help output |
| `Log::Log4perl` | 1.57 | Structured logging |
| `Perl::Tidy` | 20260204 | Code formatting (dev/build tool) |

These modules are not required for normal use and will not be
installed automatically by most CPAN clients. They enable optional
features when present.

---

### Build System Improvements (`Makefile`, `.includes/perl.mk`)

Several improvements were made to the
CPAN::Maker::Bootstrapper-managed build infrastructure:

#### `cpanfile` Generation Now Supports Dependency Tiers

The `cpanfile` target has been refactored to support all three optional dependency tiers independently:

- `cpanfile.requires` — runtime and test requirements
- `cpanfile.suggests` — optional suggested modules
- `cpanfile.recommends` — recommended modules

These intermediate targets are declared `.INTERMEDIATE` and are
concatenated into the final `cpanfile`.

#### `perlcritic` Target Fixes

The `critic` target in `perl.mk` now correctly passes `--theme` and
`--severity` flags when linting both modules and scripts.

#### `deps.mk` Dependency Fix

`deps.mk` now depends on built source files (`.pm`) rather than
`.pm.in` templates, which resolves a potential chicken-and-egg rebuild
issue during `make clean`.

#### `MIN_PERL_VERSION_FLAG` Guard

The `MIN_PERL_VERSION_FLAG` shell expansion now checks for the
existence of `buildspec.yml` before attempting to read from it,
preventing spurious errors on clean checkouts.

#### `README.md` Generation

The `README.md` generation rule now uses `|| true` to prevent build failures when `markdown-render` encounters non-fatal issues.

#### `test-requires.raw` Filter

The `cmb filter` step for `test-requires.raw` is now unconditional —
the previous conditional that skipped filtering when no prior file
existed has been removed.

---

### CI Builder Improvements (`builder`)

The `builder` script used for local and CI Docker builds received several updates:

- **Local volume mount**: The project directory is now mounted into
  the container (`-v "$(pwd):/$(...)"`) so builds can operate on local
  sources without requiring a fresh `git clone`.
- **Conditional `git clone`**: The builder now skips cloning if the
  target directory already exists.
- **Conditional `git checkout`**: Branch checkout is skipped if the
  `.git` directory is not present (i.e., when using a mounted volume).
- **`REPO` environment variable**: The `build-ci` `make` target now
  passes `REPO` derived from `git remote get-url origin` to the
  container.
- **`--no-prebuilt` flag**: The default `cpm` installer invocation now
  includes `--no-prebuilt` to ensure modules are built from source.
- **Build invocation**: The final `make` call now passes
  `CMB_VERSION_DRIFT=ignore NO_ECHO=` for more verbose, permissive CI
  builds.

---

### Documentation (`lib/CLI/Simple/Utils.pm.in`)

- The `slurp` function POD has been updated to clarify that the `file`
  argument may be either a filesystem path **or an open file handle**.
- A `VERSION` section has been added to the `CLI::Simple::Utils` POD.

---

## Files Changed

| File | Change |
|---|---|
| `VERSION` | Bumped to `2.1.3` |
| `cpanfile` | Added `suggests` entries for `IO::Pager`, `Log::Log4perl`, `Perl::Tidy` |
| `Makefile` | Refactored `cpanfile` target; `deps.mk` dependency fix; `MIN_PERL_VERSION_FLAG` guard; `README.md` generation fix |
| `.includes/perl.mk` | Fixed `critic` target flags; updated sentinel rules |
| `builder` | CI/local Docker build improvements |
| `lib/CLI/Simple/Utils.pm.in` | POD update for `slurp`; added `VERSION` section |
| `README.md` | Regenerated from POD |

---

## Upgrade Notes

This release contains no breaking changes. Upgrading from 2.1.2 is
safe for all users. The new `suggests` entries in `cpanfile` are
informational and will not affect existing installations.
