# CLI::Simple 2.2.0 Release Notes

## Overview

Version 2.2.0 is the first CPAN release since 2.1.1. It incorporates
all fixes and enhancements from versions 2.1.2 and 2.1.3, which were
developed on GitHub but never published to CPAN. Users who have been
tracking the GitHub repository can consult the commit history for a
detailed view of incremental changes since 2.1.1.

## What's New

### Test Suite Fixes

The primary changes in this release are corrections to the test suite
to improve reliability and correctness:

- **`t/04-cli-simple-help.t`** — Moved `use CLI::Simple
  qw($AUTO_HELP)` into `BEGIN` blocks to ensure the import (and the
  exported `$AUTO_HELP` variable) is available at compile
  time. Replaced `use parent qw(CLI::Simple)` with `our @ISA =
  qw(CLI::Simple)` to avoid inheritance issues within the test file's
  multi-package layout.

- **`t/06-cli-simple-default.t`** — Consolidated the `CLI::Simple`
  import into a single `BEGIN` block, importing both `$AUTO_DEFAULT`
  and `$AUTO_HELP` together. Replaced `local
  $CLI::Simple::AUTO_DEFAULT` with direct use of the imported
  `$AUTO_DEFAULT` variable for consistency. Removed a redundant `use
  CLI::Simple qw($AUTO_HELP)` statement from within a subtest.

### Build / Packaging

- **`test-requires.skip`** — Removed. The file that previously
  excluded `CLI::Simple` from test requirements is no longer needed.

## Upgrading

This release contains no changes to the public API or module
behaviour. Users on 2.1.1 (the previous CPAN release) can upgrade
without any changes to their code.

Users tracking the GitHub repository at 2.1.2 or 2.1.3 will find this
release identical in functionality; the only differences are the test
suite corrections noted above.

## Resources

- **CPAN:** [CLI::Simple](https://metacpan.org/pod/CLI::Simple)
- **GitHub:**
  [rlauer6/CLI-Simple](https://github.com/rlauer6/CLI-Simple) — see
  commit history for full details of changes since 2.1.1
