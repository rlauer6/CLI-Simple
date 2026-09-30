# CLI::Simple 2.2.4 Release Notes

## Summary

This release corrects the precedence logic for POD help sections,
formally registers `help_sections` as a valid constructor option,
and updates the build system with new tooling support.

## Bug Fixes

### Help Section Precedence Reversed

The most significant change in this release is a correction to the
`_get_help_sections` method in `CLI::Simple`. Prior to this release,
when a script's POD contained both a `SYNOPSIS` and a `USAGE`
section, `SYNOPSIS` was used by default. This was the opposite of
the intended behaviour.

The corrected logic now gives `USAGE` priority when it is present,
falling back to `SYNOPSIS` when no `USAGE` section exists. This
better supports scripts written with backward-compatible `USAGE`
sections. The full precedence rules are:

- If a `USAGE` section is present in the POD, it is used.
- If no `USAGE` section is present, `SYNOPSIS` is used instead.
- When `help_sections` is configured explicitly in the constructor,
  the caller's specification is honoured exactly, allowing both
  sections to be displayed if desired.

### `help_sections` Added to Valid Constructor Options

`help_sections` was accepted by the constructor but was absent from
`@VALID_OPTIONS` in `CLI::Simple::Constants`, causing an "unknown
option" error if the option was passed directly. This has been
corrected.

## Test Updates

Tests in `t/04-cli-simple-help.t` have been updated to reflect the
corrected precedence. The subtest formerly named "SYNOPSIS takes
precedence over USAGE" has been renamed "USAGE takes precedence over
SYNOPSIS" and its assertions inverted accordingly.

## Documentation

POD and `README.md` have been updated to accurately describe the
`USAGE`/`SYNOPSIS` precedence rules and the behaviour of
`help_sections`.

## Build System

Build infrastructure has been updated via `CPAN::Maker::Bootstrapper`,
including the addition of `publish.mk`, updates to `update.mk`, and
several improvements to dependency scanning, DarkPAN support, and
the `extra-files` handling mechanism. A new `test-local` hook target
has been added.

---

