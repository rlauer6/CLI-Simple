# CLI::Simple 2.2.2 Release Notes

**Released:** 2026-08-18  
**Distribution:** CLI-Simple  
**Author:** Rob Lauer

---

## Overview

This release delivers a collection of bug fixes and behavioural
improvements to `CLI::Simple`, along with build-system modernisation
across the CPAN::Maker::Bootstrapper infrastructure. Key highlights
include a new `set_args` method, improved `default` command
resolution, a clearer error message when `Log::Log4perl` is missing,
and expanded documentation around `use_log4perl` opt-in semantics.

---

## What's New

### `CLI::Simple`

#### New Method: `set_args`

A new `set_args` method has been added to allow callers to explicitly
reset the positional argument list:

```perl
$self->set_args([qw(foo bar baz)]);
```

This provides a cleaner API alternative to retrieving and mutating the
array reference returned by `get_args` in scalar context.

---

#### `use_log4perl` — Improved Error Handling and Documentation

**Bug fix:** The error variable in the unknown-argument check was
incorrectly referencing `$_` instead of `$o`. This caused the wrong
variable name to appear in the error message.

`**Improved error message:** When `Log::Log4perl` is not installed,
the error message now clearly explains the opt-in nature of the
dependency and tells the caller exactly how to resolve the problem:

```
use_log4perl() requires Log::Log4perl, which is not installed.
It is an opt-in feature, so CLI::Simple does not depend on it.
If your app calls use_log4perl(), add 'Log::Log4perl' to your requires/cpanfile.
```

**Documentation expanded:** The POD now makes the opt-in nature of
`Log::Log4perl` explicit, advises callers to declare the dependency
themselves (since static scanners cannot detect the dynamic
`require`), and warns against calling `use_log4perl` when using a
different logging framework or managing `Log::Log4perl` initialisation
independently.

A new FAQ entry — *"My application dies with 'use_log4perl() requires
Log::Log4perl...'"* — provides actionable guidance and an audit
one-liner:

```bash
grep -rl use_log4perl lib bin && grep -q Log::Log4perl cpanfile \
  || echo 'use_log4perl() called but Log::Log4perl not in cpanfile'
```

---

#### `new` — Constructor Fixes

- **Guard against bad `extra_options` values:** A new check detects
  the common mistake of passing an array reference as an element of
  `extra_options` (e.g. `extra_options => [qw(a b c)]` written as
  `extra_options => [[qw(a b c)]]`) and dies with a clear diagnostic.

- **`default` command resolution:** When the `default` key in the
  commands hash maps to a non-reference (i.e. a plain string naming
  another command), that string is now used as the command name rather
  than the literal string `'default'`. This aligns with
  manifest-driven role-based applications where `default: cmd_install`
  should resolve to `cmd_install`.

- **Custom help method receives a flag:** The custom `help` handler
  (when provided as a command) is now called with an extra boolean
  argument (`$TRUE`) so that it can distinguish a programmatic help
  invocation from a normal command dispatch.

---

#### `init_logger` — Undefined Warning Fixed

A guard has been added to avoid an "uninitialized value" warning when
`$command` is undefined or when the commands hash does not contain the
current command.

---

#### `run` — Handler Dereferencing

When a command's handler is a plain string (non-reference), `run` now
dereferences it through the commands hash to find the real
handler. This supports the case where `default` points to a sub name
rather than a code reference.

An explicit error is now raised if the resolved command has no registered handler:

```
ERROR: no such command 'foo' has been registered.
```

---

### `CLI::Simple::Modulino`

Template variable placeholders changed from uppercase
(`@MODULINO_WRAPPER@`, `@PERL_MODULE_NAME@`) to lowercase
(`@modulino_wrapper@`, `@perl_module_name@`) to avoid validation
errors from `cmb`, which treats uppercase placeholder names as
reserved.

---

### `CLI::Simple::Utils`

`ToCamelCase` is now exported from `@EXPORT_OK`, making it available
to callers alongside the existing `toPascalCase` and `toCamelCase`
exports.

---

## Build System Changes

These changes affect the CPAN::Maker::Bootstrapper infrastructure used
to build this distribution and do not affect the installed module API.

| Area | Change |
|------|--------|
| **`Makefile`** | `bootstrapper` command renamed to `cmb`. `GITHUB_ACTIONS`, `CPM`, `CARTON`, and `CPAN_INSTALLER` variables added. `GIT_SHA` and `GIT_DIRTY` variables added and exposed as template variables. `config.mk` now has an explicit no-op rule to suppress missing-file warnings. `extra-files.mk` added to `CLEANFILES`. |
| **Template expansion** | `sed`-based substitution replaced with `cmb resolve-vars` throughout, with a new `gen-vars-file` make function writing variable values via `$(file)` to avoid shell quoting issues. `TEMPLATE_VARS` list defined centrally. |
| **`PERLINCLUDE`** | Changed from `-I lib $(PERL5LIB)` to `-I lib -I local/lib/perl5` to prefer locally installed dependencies. `PERL5LIB=` is now cleared during syntax checks to prevent interference from the caller's environment. |
| **`deps.mk`** | Now depends on `$(SOURCE_FILES_IN)` (`.pm.in` / `.pl.in` sources) rather than built `.pm` / `.pl` targets. Output written atomically via a `.tmp` file. |
| **`requires` / `recommends` / `suggests`** | Dependency scanning now uses `$(SOURCE_FILES_IN)` as inputs. |
| **`local` target** | Added to `DEPS` and as an order-only prerequisite for `.pm` and `.pl` pattern rules. `local.mk` added to the managed-files list in `update.mk`. |
| **`extra-files.mk`** | New dynamically generated include file that wires extra distribution files (from `buildspec.yml`) into the tarball dependency graph. |
| **`version.mk`** | `release`, `minor`, and `major` targets now depend on `clean` to ensure a fresh build after a version bump. |
| **`git.mk`** | New `repo` target added for creating GitHub repositories via `gha-aws`. |
| **`find-files`** | Emacs backup files (`#*`, `.#*`, `*~`, `*.bak`) are now excluded from file discovery. Output is sorted for reproducibility. |
| **`builder`** | Logic fix: the `git checkout` branch condition was inverted (`! [[ -d ".git" ]]` → `[[ -d ".git" ]]`). Removed the hard error when no `REPO` is specified and the current directory is not a git repository. |
| **`DOCKER_CPAN_INSTALLER`** | The `INSTALLER` make variable renamed to `DOCKER_CPAN_INSTALLER` to avoid colliding with the new `CPAN_INSTALLER` variable used for local builds. |
| **`.gitignore`** | `extra-files.mk` and `local/**` added. |

---

## Upgrade Notes

- If your application calls `__PACKAGE__->use_log4perl(...)`, ensure
  `Log::Log4perl` is declared in your own `requires` / `cpanfile`. It
  is not, and has never been, a prerequisite of `CLI::Simple` itself,
  and static dependency scanners will not detect it automatically.
- The `default` command key in the commands hash now behaves
  differently when its value is a plain string: it is treated as the
  name of another registered command rather than the literal key
  `'default'`. Review any `commands => { default => 'some-string' }`
  usages.
- Custom `help` command handlers will now receive a second argument
  (`$TRUE`) when invoked via the help path. Handlers that accept only
  `($self)` are unaffected, but handlers that inspect `@_` should be
  aware of the additional argument.

---

## Full Changelog

See [ChangeLog](ChangeLog) for the complete entry-by-entry record.
