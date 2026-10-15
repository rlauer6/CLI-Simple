# CLI::Simple 2.3.2 Release Notes

## Overview

This release extends the manifest loading system with support for
multiple YAML files and glob patterns, adds a new `init_options()`
lifecycle hook for role-based applications, fixes log level precedence
resolution, and updates the build and release workflow tooling.

---

## Multi-Manifest Loading

The most significant user-visible change is that `import` now accepts
explicit YAML filenames and glob patterns in addition to `:roles`:

```perl
use CLI::Simple qw(
  :roles
  extensions/publish.yml
  .roles/*/role.yml
);
```

Glob patterns are expanded before loading. An unmatched glob silently
contributes nothing; an explicitly named file that does not exist
causes an error that identifies the missing path.

When multiple manifests are loaded, their `commands`, `roles`,
`options`, `default_options`, and `extra_options` sections are merged
into a single application configuration. Merging enforces:

- Uniqueness of command names across all manifests (duplicates are
  an error).
- Uniqueness of option names and aliases across all manifests
  (duplicates are an error).
- Uniqueness of `default_options` keys across all manifests
  (duplicates are an error).
- `extra_options` declarations may repeat without error; an accessor
  name that appears in more than one manifest is registered once.
- `alias` and `abbreviations` metadata are taken only from the
  primary manifest (the first one loaded). Subsequent manifests
  cannot override application-wide alias configuration.

Manifest loading is now validated per file before merging. Each
manifest must be a YAML mapping; unknown top-level keys and
section values that do not match their expected types are rejected
with a descriptive error.

The new `_validate_manifest` internal method implements this
per-file validation. The `_normalize_manifest` method, extracted
from `_load_manifest`, now handles role normalization and
selective-role table construction separately.

---

## New `init_options()` Lifecycle Hook

A new `init_options()` method is called after `init_logger()` and
before `init()` during application startup. The base implementation
is a no-op. Applications may override it, and roles may augment it
with `Role::Tiny` method modifiers to initialize accessors from
configuration, environment variables, or other sources after
command-line parsing is complete.

---

## Log Level Precedence Fix

`init_logger` previously had an early-return path that skipped log
level resolution when the selected command's handler was not an
`ARRAY` reference. This caused the command-level log level and any
`--log-level` option to be silently ignored in those cases.

The precedence order is now applied unconditionally after the logger
is available:

1. `--log-level` command-line option
2. Command-level log level (from the array-ref handler form)
3. Application default supplied to `use_log4perl()`

Existing applications that relied on the skipped resolution — that
is, where the logger stayed at its initialized level rather than
respecting `--log-level` — may observe a behavioral change.

---

## `usage()` and `MODULINO_MODULE_NAME`

`usage()` now consults the `MODULINO_MODULE_NAME` environment
variable when locating the POD input file. This allows wrapper
scripts whose name differs from the module name to correctly
identify the POD source, rather than falling back to the wrapper
script itself.

---

## Build and Workflow Changes

- `.includes/add-plugin.mk` is a new managed make fragment, added
  to `MANAGED_MK_FILES`. `.includes/release-notes.mk` has been
  removed.
- `.includes/update.mk` gains `INCLUDES_DIR` and
  `BOOTSTRAPPER_DIST_DIR` variable definitions, a new `pre-update`
  double-colon phony target (extensible by downstream projects), and
  restructures the `post-update` rule to depend on `pre-update`.
  The `update` target now calls `pre-update` explicitly before
  copying managed files.
- `.includes/test.mk` replaces `GSOURCE_FILES` with `SOURCE_FILES`
  in the `test`, `test-all`, and `check` targets.
- The project `Makefile` adds `DEPENDENCY_FILES`,
  `MISSING_DEPENDENCY_FILES`, and a `force-reconcile` target.
  Reconciliation is triggered when any dependency file is absent.
  The `--log-level info` flag has been removed from the
  `test-requires.scan` `scandeps` invocation.
- `.roles/CPAN-Maker-Bootstrapper-Role-LLM/role.mk` and
  `role.yml` are new project-registered command role extension
  files included via `$(wildcard .roles/*/role.mk)`.

## Modulino Fixes

- `create-modulino` now use correct pattern used by
  `.includes/modulino.mk` to avoid making two perl invocations and
  loading the module twice
- `lib/CLI/Simple/Modulino.pm.in` uses corrected template

---

## Test Coverage

- `t/cli-simple-manifest.t` adds coverage for loading multiple
  explicit YAML manifests via import arguments, glob pattern
  expansion, unmatched globs, and missing explicit YAML files.
  `English qw(-no_match_vars)` was added to eliminate the use of
  `$@` without the pragma.
- `t/log-level-precedence.t` is a new test file that exercises the
  three-level log level precedence: `--log-level` > command level >
  `use_log4perl` default.

---

