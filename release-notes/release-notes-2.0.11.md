# CLI::Simple 2.0.11 Release Notes

## Release Date
2026-07-07

## Overview

This is a maintenance release of `CLI::Simple` that improves argument
handling in the `use_log4perl` method, adds a more convenient alias
constant for the equals sign, and enhances the `slurp` utility
function to accept file handles in addition to file paths.

---

## What's Changed

### `CLI::Simple` — `use_log4perl` improvements

- **Flexible log level argument names**: The `use_log4perl` method now
  accepts any of the following argument names for specifying the log
  level, providing greater flexibility for callers:
  - `log-level`
  - `log_level`
  - `loglevel`
  - `level`

- **Unknown argument validation**: Passing an unrecognised argument to
  `use_log4perl` will now raise an error with `die`, helping to catch
  misconfiguration early.

- **Default log level**: If no log level argument is provided, the log
  level now defaults to `error`.

### `CLI::Simple::Constants` — New `$EQUALS` constant

- Added `$EQUALS` as an alias for the existing `$EQUALS_SIGN` constant
  (both equal `=`). This provides a shorter, more convenient name when
  importing from the `:chars` export tag.

### `CLI::Simple::Utils` — `slurp` accepts file handles

- The `slurp` function now supports being passed an already-open file
  handle (or any value for which `Scalar::Util::openhandle` returns
  true), in addition to a file path string. If a file handle is
  provided, it reads directly from it without attempting to open a new
  file.

---

## Files Changed

| File | Change |
|---|---|
| `lib/CLI/Simple.pm.in` | `use_log4perl` argument validation and flexible log level keys |
| `lib/CLI/Simple/Constants.pm.in` | Added `$EQUALS` constant to `:chars` export tag |
| `lib/CLI/Simple/Utils.pm.in` | `slurp` now accepts a file handle argument |
| `VERSION` | Bumped to `2.0.11` |

---

## Upgrade Notes

- The change to `use_log4perl` is **backwards compatible** for callers
  using `log_level` or `level`. Callers using any argument key other
  than the four accepted names (`log-level`, `log_level`, `loglevel`,
  `level`, `config`) will now receive a fatal error.
- `$EQUALS` and `$EQUALS_SIGN` are interchangeable; existing code
  using `$EQUALS_SIGN` requires no changes.
- The `slurp` change is fully backwards compatible.
