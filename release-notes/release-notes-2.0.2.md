## CLI::Simple 2.0.2

**Released:** Tue May 19, 2026

### New

**`CLI::Simple::Shell`** - new module added to the distribution. Serves as the POD backing for the `cli-simple` script, documenting its interface for scaffolding new projects from a `.yml` spec file. By housing the man page in a proper module, `cli-simple` gets a first-class entry in the man link table and a `provides` declaration in `buildspec.yml`.

### Changes

**`bin/cli-simple`** - renamed from `bin/cli-simple.sh.in`. The `.sh` infix has been dropped; the script is now built as `cli-simple.in` and installed simply as `cli-simple`.

**`CLI::Simple::usage()`** - now context-aware. When invoked via the `cli-simple` wrapper (detected via `$ENV{MODULINO_WRAPPER} eq 'cli-simple'`), `pod2usage` is directed at `CLI::Simple::Shell`'s installed path rather than the calling program. This gives `cli-simple --help` its own coherent usage output instead of falling back to `CLI::Simple`'s own POD.

**`buildspec.yml`** - `CLI::Simple::Shell` added to `provides`; a `man-links` entry maps `cli-simple` → `CLI::Simple::Shell`.

### Documentation

- Removed the now-obsolete `EXAMPLE` section from both `CLI::Simple.pm` and `README.md` (previously referred to `cli-simple-example`, which is no longer part of the distribution).
- `CLI::Simple::Utils` - `NAME` heading now includes a short description (`Useful utility functions for CLI::Simple-based applications`); `SEE ALSO` gains a back-link to `CLI::Simple`; trailing whitespace cleaned up.
- `CLI::Simple::Constants` - `NAME` heading corrected (was missing description); author contact updated to `rlauer@treasurersbriefcase.com`.
- `create-modulino.pl.in` - `NAME` now includes a brief description; option list indentation in the `OPTIONS` section corrected.
- `SEE ALSO` in `CLI::Simple.pm` and `README.md` - `CLI::Simple::Constants` added to the cross-reference list.

### Housekeeping

- `.gitignore` - replaced stale `bin/bootstrapper` and `bin/cpan-maker-bootstrapper` entries with `bin/cli-simple`.
- Author contact updated to `rlauer@treasurersbriefcase.com` across all modules that previously had `bigfoot@cpan.org` or a bare name.
