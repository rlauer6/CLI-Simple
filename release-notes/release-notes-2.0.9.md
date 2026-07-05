# CLI::Simple 2.0.9 Release Notes

## Overview

This release adds **pager support** for help output and introduces
**customizable help sections**, giving CLI application authors more
control over what users see when invoking `--help`. The build
infrastructure has also been updated to use
`CPAN::Maker::Bootstrapper`.

---

## New Features

### Pager Support (`$PAGER`)

Help output can now be routed through a pager (e.g., `less`, `more`)
when `--help` is invoked.

A new package variable `$PAGER` controls this behaviour:

```perl
use CLI::Simple qw($PAGER);
$PAGER = 0;  # disable pager
```

- **Default:** `true` (pager enabled)
- When enabled, `IO::Pager` selects an appropriate pager based on the
  `PAGER` environment variable, falling back to a sensible default.
- If `IO::Pager` is not installed, help output falls back to STDOUT
  regardless of the `$PAGER` setting.
- `$PAGER` is now included in `@EXPORT_OK`.

### Customizable Help Sections (`help_sections`)

By default, `CLI::Simple` now passes an explicit set of POD section
names to `Pod::Usage` when rendering help output:

```
SYNOPSIS DESCRIPTION/Commands DESCRIPTION/Options OPTIONS USAGE
```

This can be overridden via `set_help_sections`:

```perl
# after construction
$cli->set_help_sections( [qw( SYNOPSIS OPTIONS )] );

# or inside init()
sub init {
  my ($self) = @_;
  $self->set_help_sections( [qw( SYNOPSIS OPTIONS EXAMPLES )] );
  return $self->SUPER::init;
}
```

Subsections use the `Pod::Usage` `/` separator convention,
e.g. `DESCRIPTION/Commands`.

---

## Bug Fixes

- Fixed a duplicate redirect in the `.pl.tdy` tidiness check
  (`2>/dev/null 2>&1` → `2>/dev/null`).
- Fixed `MODULE_NAME` shell variable expansion in the `Makefile`
  (`$(pwd)` → `$$(pwd)`).
- Removed erroneous `-M"$$module"` flag from the `check_syntax_pl`
  snippet; `.pl` files are no longer syntax-checked as modules.
- `podextract` is now checked at runtime in `run_podextract` rather
  than at parse time, with a clear error message if `Pod::Extract` is
  not installed.
- `perltidy` and `perlcritic` checks are now skipped gracefully when
  the respective tools are not installed, rather than always defining
  `tidy_on`/`critic_on`.
- `git config` calls in the `Makefile` now redirect stderr
  (`2>/dev/null`) to suppress warnings in environments without a
  global git config.

---

## Build Infrastructure

- Migrated from `make-cpan-dist.pl` / `CPAN::Maker` to the
  `cpan-maker` CLI provided by `CPAN::Maker` +
  `CPAN::Maker::Bootstrapper`.
- `cpanfile` generation now delegates to `cpan-maker create-cpanfile`.
- `release-notes` target now delegates to `bootstrapper release-notes`.
- `SCAN` is automatically set to `OFF` when `scandeps-static.pl` is not found.
- An error is now raised at `make` parse time if
  `CPAN::Maker::Bootstrapper` is not installed.
- A warning is now emitted if `Markdown::Render` is not installed.
- `README.md` generation now degrades gracefully with a warning if
  `Markdown::Render` or `Pod::Markdown` are absent.
- `builder` script updated: improved `cpm` installer flags
  (`--show-build-log-on-failure --verbose`), dependencies updated to
  `CPAN::Maker` + `CPAN::Maker::Bootstrapper`, and clone logic skips
  re-cloning an existing directory.
- `cpanfile` entries sorted alphabetically.
- Removed `@EXTRA_FILES@` substitution from `buildspec.yml` generation.

---

## Dependency Changes

| Dependency | Change |
|---|---|
| `IO::Pager` | **New** — optional; used for pager support in help output |

---

## Upgrading

No breaking changes. The `$PAGER` variable defaults to `true`; if you
do not want help output paged, set `$PAGER = 0` after importing
it. `IO::Pager` is an optional dependency — if it is not installed,
help output continues to go directly to STDOUT.
