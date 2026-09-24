# CLI::Simple 2.2.3

## Release Notes

**Released:** 2026-09-24

### What's New

#### Smarter Help Section Selection

The most significant change in this release is how `CLI::Simple`
selects POD sections when rendering help output. Previously, the
module used a fixed list of sections including both `SYNOPSIS` and
`USAGE`. Now it inspects the script's POD at runtime and selects
the appropriate usage section automatically:

- If the POD contains a `=head1 SYNOPSIS` section, it is used as
  the primary usage section.
- If no `SYNOPSIS` is present, `USAGE` is used as a fallback for
  backward compatibility.
- When both sections exist, `SYNOPSIS` takes precedence and `USAGE`
  is suppressed by default.

Applications that need both sections displayed (or any other custom
ordering) can still pass an explicit `help_sections` list to the
constructor, which is honored exactly as provided.

Two new internal helpers drive this behavior: `_pod_has_section`
checks whether a named `=head1` heading exists in the POD source,
and `_get_help_sections` applies the selection logic before each
`usage()` call.

#### New `@DEFAULT_HELP_SECTIONS` Constant

A new exported constant `@DEFAULT_HELP_SECTIONS` is now defined in
`CLI::Simple::Constants` and imported by `CLI::Simple`. This makes
the default section list a single authoritative source rather than
a hardcoded inline literal.

### Dependency Update

The minimum required version of `Role::Tiny` has been bumped from
`2.002004` to `2.002005` in both runtime and test dependencies.

### Build System Improvements

This release incorporates several updates from
`CPAN::Maker::Bootstrapper`:

- `bootstrap.mk` has been added to the managed include files.
- Build output is more informative: syntax, POD, tidiness, and
  critic checks now print labeled progress messages.
- Dependency scanning now correctly excludes modules provided by
  the distribution itself from `test-requires`.
- The `provides` section has been removed from `buildspec.yml`
  as it is now generated automatically.
- The `find-files` macro supports an optional fourth filename
  pattern, allowing test helper modules under `t/lib/` to be
  included in the file search.
- `extra-files` generation is now delegated to the bootstrapper
  and guarded against bootstrap builds.

### Test Suite

The help test suite (`t/04-cli-simple-help.t`) has been
substantially rewritten. Tests now cover four distinct scenarios:

- `USAGE` section displayed when no `SYNOPSIS` is present
- `SYNOPSIS` displayed when present
- `SYNOPSIS` takes precedence when both sections exist
- Explicit `help_sections` configuration is honored exactly

Three supporting test helper modules have been added under
`t/lib/` and are included in the distribution.

### Documentation

The `help_sections` documentation in `CLI::Simple` and the
"Adding Usage to Your Scripts" section have been updated to reflect
the new `SYNOPSIS`-first behavior and backward-compatible `USAGE`
fallback.