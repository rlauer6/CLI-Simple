# CLI::Simple 2.3.0 Release Notes

## Overview

This release introduces selective role composition for manifest-based
CLI applications, a significant extension to the `roles:`-based
architecture added in 2.0.0. The build and release tooling has also
been substantially reworked, with a new `build-init.mk` fragment,
tighter CI integration, and several new Make targets.

---

## Selective Role Composition

The primary user-facing change is the addition of a `roles:` key in
the YAML manifest. Prior to this release, the `commands:` key was the
only way to declare command-to-role mappings, and composing any
command's role caused the entire legacy role set to be composed at
once. The new `roles:` key enables **deferred, per-command** role
composition.

### How it works

When a command is declared under `roles:` rather than `commands:`,
`CLI::Simple` defers role composition until that specific command is
selected at runtime. Only the roles required by the chosen command are
applied:

```yaml
---
roles:
  frobnicate: My::Script::Role::Frobnicate
  list:
    - My::Script::Role::List
    - My::Script::Role::Shared
options:
  - help|h
  - verbose|v
```

Each `roles:` value may be a single role class name (scalar) or an
array of role class names. Both forms are normalized to an array
internally.

### Validation

`CLI::Simple` validates the following at manifest-load time:

- A command may not appear in both `commands:` and `roles:`;
  doing so is a fatal error.
- Each role value must be a valid Perl class name. A hash reference
  or other non-string, non-array value is rejected.

At command-dispatch time, `CLI::Simple` verifies that the composed
roles actually provide the expected `cmd_<command>` method, dying with
a diagnostic message if they do not.

### Preserved legacy behavior

Commands declared under the existing `commands:` key continue to work
as before: when a `commands:`-declared command is selected, the
complete set of legacy roles is composed. Command aliases are
correctly restored after legacy role composition.

### New constructor options

Two new keys are accepted by `CLI::Simple->new()` (and listed in
`@VALID_OPTIONS`):

- `command_roles` — carries the selective role map from the
  manifest to the constructor.
- `manifest_commands` — carries the legacy command map for
  deferred composition.

These are set automatically when using `main()` with a manifest and
do not ordinarily need to be set by hand.

---

## Build System Changes

This release includes extensive changes to the `CPAN::Maker::Bootstrapper`
managed Make fragments. Projects using this toolchain should run
`make update` after upgrading.

### New file: `.includes/build-init.mk`

Build configuration and helper discovery have been moved out of
`perl.mk` into a new `build-init.mk` fragment. This is now a managed
file that must be present for the build to function.

### GNU Make 4.3 requirement

The `Makefile` now explicitly requires GNU Make 4.3 or newer (for
grouped-target support). Builds on older Make versions fail with a
clear error.

### New and changed Make targets

- `test-all` — runs the full test suite with `AUTHOR_TESTING`,
  `RELEASE_TESTING`, and `AUTOMATED_TESTING` all enabled.
- `test-author`, `test-release`, `test-smoke` — run tests from
  `xt/author/`, `xt/release/`, and `xt/smoke/` respectively. The
  standard `test` target honors the corresponding environment
  variables and delegates to these targets automatically.
- `real-quick` — extends `quick` by also disabling syntax checking
  (`SYNTAX_CHECKING=off`).
- `quick` — now also disables POD checking in addition to scanning
  and linting.

### Batch processing

`perltidy`, `perlcritic`, and `resolve-vars` passes are now batched
through `cmb` rather than running per-file. This avoids repeated
process startup overhead for projects with many source files.
Rendered `.rendered` intermediate files are generated before POD
processing and are now tracked as intermediate build artifacts that
`make clean` removes.

### Dependency reconciliation

The `Makefile` now avoids rewriting scanned dependency files when
content has not changed (preventing spurious rebuilds), and removes
modules listed in `provides` from `test-requires` after
reconciliation.

### Publishing

`publish` now requires `PAUSE_USER` and `PAUSE_PASSWORD` to be set
before attempting an upload, and unpacks and tests the distribution
tarball locally before uploading. Pre-publish and post-publish
extension points (`pre-publish::` and `post-publish::`) are available
for projects that need additional steps around CPAN upload.

### CI

The `builder` script runs `make clean` before the CI build to ensure
a clean state. The GitHub Actions workflow (`build.yml`) pins to
`debian:trixie` and sets `CMB_VERSION_DRIFT=ignore` for container
builds.

### `update-available`

The `update-available` target now uses `cmb update-available` and
`cmb dist-file --path-only` to locate `cmb_md5sums.txt`, replacing
the previous inline logic.

---

## Dependency Changes

- `Test::Exit` and `Test::Output` have been removed from `cpanfile`
  and `test-requires`. They are no longer used by the test suite.
- `test-requires` has been pruned of modules already provided by
  runtime requirements to avoid redundant declarations.

---

## Test Suite

- `t/cli-simple-manifest.t` has been updated to test manifest
  parsing and normalization without eagerly composing roles, duplicate
  command detection, invalid selective role specifications, and
  manifest metadata pass-through.
- `t/cli-simple-selective-roles.t` is a new test file covering
  single and multiple selective roles, legacy all-role composition,
  abbreviation and command alias resolution, invalid role
  specifications, and missing command method detection.

---

## Upgrade Notes

Projects using `CPAN::Maker::Bootstrapper` should run `make update`
after this release to pick up the new `build-init.mk` fragment and
the updated managed Make files. The `Makefile` now requires GNU Make
4.3; verify your environment before upgrading.

If your manifest uses only the `commands:` key, no changes to your
YAML or Perl code are required — legacy behavior is fully preserved.

---

