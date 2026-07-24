# CLI::Simple 2.1.2 Release Notes

**Released:** Fri Jul 24 2026  
**Author:** Rob Lauer

---

## Overview

Version 2.1.2 is a dependency-reduction and logging-refinement
release. `Log::Log4perl` and `Log::Log4perl::Level` are no longer hard
dependencies — they are lazy-loaded only when logging is actually
requested. `Pod::Usage` is similarly lazy-loaded. Colorized log output
is now fully configurable per log level, and the constructor now
detects and rejects duplicate accessor definitions.

---

## What's New

### Reduced Dependency Profile

`Log::Log4perl`, `Log::Log4perl::Level`, and `Pod::Usage` have been
removed from the hard-requirement list. They are now loaded on demand:

- `Log::Log4perl` is loaded only when `use_log4perl()` is called
- `Pod::Usage` is loaded only when `usage()` is called
- Log level numeric values are now hard-coded in
  `CLI::Simple::Constants` to avoid loading `Log::Log4perl::Level` at
  all

This significantly reduces the mandatory install footprint for scripts
that do not use logging.

### Configurable Log Level Colors

`use_log4perl()` now accepts per-level color arguments, allowing you
to customize colorized output without writing your own Log4perl config
string:

```perl
__PACKAGE__->use_log4perl(
  level       => 'info',
  color       => 1,
  debug_color => 'cyan',
  warn_color  => 'bold yellow',
  error_color => 'bold red',
);
```

Supported color arguments: `debug_color`, `info_color`, `warn_color`,
`error_color`, `fatal_color`, `trace_color`.

### New `_set_color_config()` Internal Method

A new private method `_set_color_config(%args)` generates the Log4perl
`ScreenColoredLevels` configuration string from the color arguments
passed to `use_log4perl()` or triggered by the `--color` flag at
runtime. The `$LOG4PERL_CONF` constant in `CLI::Simple::Constants` is
now a `sprintf` pattern rather than a literal string.

### Duplicate Accessor Detection in `new()`

The constructor now tracks which accessors it has generated (per
class) in a `%GENERATED_ACCESSOR` hash. If a hand-written `get_*` or
`set_*` method already exists for a given name, `new()` will die with
a clear error rather than silently skipping accessor creation or
producing subtle bugs when running multiple constructor calls in the
same process.

### New `:color-config` Export Tag in `CLI::Simple::Constants`

A new export tag `:color-config` is available from `CLI::Simple::Constants`:

```perl
use CLI::Simple::Constants qw(:color-config);
```

Exports: `$LOG4PERL_CONF`, `$LOG4PERL_COLOR_DEBUG`,
`$LOG4PERL_COLOR_INFO`, `$LOG4PERL_COLOR_WARN`,
`$LOG4PERL_COLOR_ERROR`, `$LOG4PERL_COLOR_FATAL`,
`$LOG4PERL_COLOR_TRACE`.

Default color values:

| Level | Color         |
|-------|---------------|
| DEBUG | magenta        |
| INFO  | green          |
| WARN  | yellow         |
| ERROR | red            |
| FATAL | bold red       |
| TRACE | bold magenta   |

### New `install` Make Target

`project.mk` now includes a convenience `install` target that installs
the built tarball into `$HOME` via `cpanm`:

```sh
make install
```

---

## Changes

### `CLI::Simple` (`lib/CLI/Simple.pm.in`)

- **`use_log4perl()`**: Now lazy-loads `Log::Log4perl` via `eval {
  require ... }` and dies with a clear message if it is not
  installed. Accepts new color-per-level keyword arguments. Validates
  all argument names against an explicit allowlist.
- **`new()`**: Tracks generated accessors in `%GENERATED_ACCESSOR`
  (keyed by class). Dies if a hand-written accessor conflicts with one
  being requested. Also tracks `logger`, `log_level`, and
  `help_sections` accessors created outside `new()`.
- **`_set_color_config()`**: New private method that generates the
  Log4perl `ScreenColoredLevels` config string, using per-level color
  defaults from `CLI::Simple::Constants`.
- **`init_logger()`**: Guards the logging path with
  `$self->can('get_log4perl_conf')` before proceeding. Detects whether
  an existing config uses `ScreenColoredLevels` by regex rather than
  by identity comparison. Falls back gracefully when `Term::ANSIColor`
  is unavailable.
- **`usage()`**: Now lazy-loads `Pod::Usage` via `require Pod::Usage`
  and calls `Pod::Usage::pod2usage()` with its full package name (no
  longer imports `pod2usage` into the `CLI::Simple` namespace).

### `CLI::Simple::Constants` (`lib/CLI/Simple/Constants.pm.in`)

- Removed `use Log::Log4perl::Level`.
- `%LOG_LEVELS` now uses hard-coded numeric values (`trace => 5000`,
  `debug => 10_000`, etc.) matching Log4perl's internal constants,
  avoiding the module load entirely.
- `$LOG4PERL_CONF` is now a `sprintf` pattern string (with `%s`
  placeholders for each log level's color).
- Added six new `$LOG4PERL_COLOR_*` scalar constants with default color values.
- Added new `:color-config` export tag.
- Updated the `foreach` loop that populates `@EXPORT_OK` to include
  all new color constants.

### Dependencies

- **Removed from `requires` and `cpanfile`:** `Log::Log4perl` (1.57), `Log::Log4perl::Level` (0)
- **Moved from `recommends` to `suggests`:** `IO::Pager`, `Term::ANSIColor`

### Build System

- **`Makefile`**: Added `recommends` and `suggests` to the dependency
  list for the tarball target. Added `check-syntax` as an explicit
  tarball prerequisite. `deps.mk` now depends on `.pm.in`/`.pl.in`
  source files rather than the built `.pm`/`.pl` targets, eliminating
  the chicken-and-egg build ordering problem. Added `package` target
  (`clean` + `LINT=on SCAN=on`). Switched from `md-utils.pl` to
  `markdown-render` and from `scandeps-static.pl` to
  `scandeps-static`. Added `MIN_PERL_VERSION_FLAG` computed variable
  for scanner invocations.
- **`.includes/perl.mk`**: Added `PERLCRITIC_SEVERITY` (default: 5)
  and `PERLCRITIC_THEME` (default: `pbp`) variables. `perlcritic`
  rules now pass `--theme` and `--severity` flags. Syntax-check skip
  list now reads from a `compile.skip` file in addition to
  `PERLWC_SKIP`. Templating and syntax checking are recombined into
  the `%.pm` / `%.pl` pattern rules. Added `check-syntax` phony
  target. Dependency include for `deps.mk` is now unconditional (the
  chicken-and-egg issue is resolved at the source).
- **`.includes/release-notes.mk`**: Updated to invoke `cmb` instead of
  `bootstrapper`.
- **`.includes/update.mk`**: `post-update` now merges new entries from
  the bootstrapper's `gitignore` template into the project's
  `.gitignore`.
- **`.gitignore`**: Added `**/*.checked`, `**/*.raw`, `**/*.tdy`,
  `buildspec.yml.current`, `buildspec.yml.tmpl`, `module.pm.tmpl`,
  `test.t.tmpl`.

---

## Upgrade Notes

- If you were relying on `Log::Log4perl` being loaded as a side-effect
  of `use CLI::Simple`, you must now call `use_log4perl()` explicitly,
  or `require` it yourself.
- If you use `CLI::Simple::Constants` and were importing
  `$LOG4PERL_CONF` as a ready-to-use string, note that it is now a
  `sprintf` format pattern. Pass it through `_set_color_config()` (or
  `sprintf` it yourself with six color strings) before handing it to
  Log4perl.
- Subclasses that define `get_*` or `set_*` methods with the same
  names as `option_specs` or `extra_options` entries will now receive
  a fatal error from the constructor. Rename the conflicting methods
  or remove the corresponding option/extra-option entries.
