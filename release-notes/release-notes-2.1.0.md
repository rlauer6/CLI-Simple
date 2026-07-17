# CLI::Simple 2.1.0 Release Notes

## Overview

This is a feature release introducing **colorized log output** support
via a built-in Log4perl appender configuration. It also includes
documentation improvements, exit code fixes, and build system updates.

---

## New Features

### Colorized Log Output (`color` support in `use_log4perl`)

`use_log4perl()` now accepts a `color => 1` argument that enables
colorized log output using a built-in Log4perl `ScreenColoredLevels`
appender — no custom config string required.

```perl
__PACKAGE__->use_log4perl(
  level => 'info',
  color => 1,
);
```

Color levels are mapped as follows:

| Level   | Color       |
|---------|-------------|
| `TRACE` | bold white  |
| `DEBUG` | magenta     |
| `INFO`  | green       |
| `WARN`  | yellow      |
| `ERROR` | red         |
| `FATAL` | bold red    |

**Notes:**
- Colorizing requires
  [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor). If it
  is not installed, `CLI::Simple` silently falls back to uncolored
  output — `color => 1` is a request, not a hard dependency.
- `color` and `config` are **mutually exclusive**. Passing both will
  cause `use_log4perl()` to die with a descriptive error.

### `--color` / `--no-color` Command-Line Flag Support

If you add `color!` to your `option_specs`, users can override the
color default at runtime:

```perl
my @option_specs = qw( color! ... );
```

An explicit `--color` or `--no-color` flag on the command line always
wins over the `use_log4perl()` default. If neither flag is passed, the
`use_log4perl()` setting is preserved.

### `$LOG4PERL_CONF` Constant

A new exportable constant `$LOG4PERL_CONF` is defined in
`CLI::Simple::Constants` containing the built-in colorized Log4perl
configuration string. It can be imported directly:

```perl
use CLI::Simple::Constants qw($LOG4PERL_CONF);
```

### `Term::ANSIColor` Added as a Recommended Dependency

`Term::ANSIColor` has been added to the `recommends` file. It is
intentionally **not** a hard requirement — it is excluded from
`requires` via `requires.skip` to keep the dependency profile minimal.

---

## Bug Fixes

### Correct Exit Code Propagation from `main()`

The modulino entry point pattern has been corrected throughout the
codebase and documentation to properly propagate the exit code
returned by `main()`:

```perl
# Before (exit code lost)
caller or __PACKAGE__->main();

# After (exit code propagated to shell)
caller or exit __PACKAGE__->main();
```

This affects `CLI::Simple` itself and all documentation examples.

---

## Documentation Updates

### Expanded `-scaffold` Documentation

The `-scaffold` internal command documentation has been significantly
expanded to describe all three application architecture patterns
available when building a `CLI::Simple`-based application:

1. **Monolithic** — all commands in a single package
2. **Hybrid role/monolith** — commands split into `Role::Tiny` roles,
   composed into a single main package
3. **Full role-based** — commands in roles, configuration in a YAML manifest

Usage instructions for `-scaffold` have been clarified to distinguish
between scaffolding from a live modulino versus from a `.yml` file.

### Simplified Quick Start Role-Based Section

The role-based architecture section of the Quick Start guide now
points readers to the `-scaffold` documentation directly, replacing a
less coherent set of individual command examples.

---

## Build System Updates

These changes affect the `CPAN::Maker::Bootstrapper`-managed build
infrastructure and do not impact end users of `CLI::Simple` directly.

- **`config.mk` support**: The `Makefile` now includes an optional
  `config.mk` file, allowing per-project overrides of build variables
  such as `CMB_UPDATE_CHECK` and `CMB_VERSION_DRIFT`.
- **`CMB_UPDATE_CHECK` / `CMB_VERSION_DRIFT` controls**: Update and
  drift checks for the bootstrapper are now configurable and skippable
  via `config.mk`.
- **Version drift detection**: `update-available` now checks local
  managed files against installed bootstrapper checksums
  (`cmb_md5sums.txt`) and reports drift with configurable severity
  (`fail`, `warn`, or `ignore`).
- **`NO_COMMIT` support for `make git`**: The `git` target now
  respects a `NO_COMMIT=1` variable to stage files without committing.
- **`--color` flag for `cpan-maker`**: The tarball build target now
  passes `--color` to `cpan-maker` unless `NO_COLOR` is set.
- **`clean-local` hook**: A no-op `clean-local` phony target has been added to allow downstream `Makefile` extensions to hook into the `clean` target.
- **`buildspec.yml` permissions**: The generated `buildspec.yml` is
  now explicitly set to mode `0644`.
- **`update-available` added to default build dependencies**: The
  `update-available` check is now part of the standard `DEPS` list, so
  it runs automatically during a normal build.

---

## Upgrade Notes

- If you use `use_log4perl()` with a custom `config` string, behavior
  is unchanged.
- If you wish to opt into colorized output, add `color => 1` to your
  `use_log4perl()` call and optionally install `Term::ANSIColor`.
- Review all modulino entry points in your own scripts and ensure they
  use `caller or exit __PACKAGE__->main()` to correctly propagate exit
  codes.
