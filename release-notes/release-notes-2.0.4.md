# CLI::Simple 2.0.4 Release Notes

## Summary

Patch release with a single bug fix in `lib/CLI/Simple.pm.in`.

---

## Changes

### Rebuild against CPAN::Maker 1.9.2

This release was built with `CPAN::Maker` 1.9.2, which corrects
`_generate_man_links` to use `$(DESTINSTALLMAN3DIR)` instead of
`$(INSTALLMAN3DIR)`.  No code change is required in `CLI::Simple`
itself — rebuilding picks up the fix automatically.

### `lib/CLI/Simple.pm.in`

**`usage` — uninitialized warning fix**

`$ENV{MODULINO_WRAPPER}` is now guarded with `// q{}` before the
string comparison, preventing an uninitialized-value warning when the
environment variable is not set.
