# Release Notes — CLI::Simple 2.0.14

**Released:** Mon Jul 13 2026  
**Author:** Rob Lauer \<rclauer@gmail.com\>

---

## Overview

Version 2.0.14 delivers improvements to `help_sections` configuration,
making it properly injectable via the constructor, and adds a new
`file_or_stdout` utility to `CLI::Simple::Utils`. A
context-propagation bug in the `choose` utility function is also fixed
in this release.

---

## What's New

### `CLI::Simple` — `help_sections` Constructor Support

The `help_sections` option can now be passed directly to the `new()`
constructor, providing a clean, explicit way to customise which POD
sections are rendered when `--help` is invoked.

**Recommended usage — pass during construction:**

```perl
my $cli = CLI::Simple->new(
  help_sections => [qw(SYNOPSIS COMMANDS OPTIONS)],
  ...
);
```

**Alternative — declare as an extra option with a default:**

```perl
my $cli = CLI::Simple->new(
  commands        => $commands,
  extra_options   => [ qw(help_sections) ],
  default_options => { help_sections => [qw(SYNOPSIS COMMANDS OPTIONS)] },
  option_specs    => \@option_specs,
);
```

If `help_sections` is not supplied, the previous default set of
sections continues to apply:

```
SYNOPSIS  DESCRIPTION/Commands  DESCRIPTION/Options  OPTIONS  USAGE
```

> **Note:** The earlier documented pattern of calling
> `set_help_sections()` after construction or overriding it inside
> `init()` was incorrect.  Prefer passing `help_sections` at
> construction time.

---

### `CLI::Simple::Utils` — New `file_or_stdout` Function

A new exportable utility function, `file_or_stdout`, has been added to
`CLI::Simple::Utils`.

```perl
use CLI::Simple::Utils qw(file_or_stdout);

my $fh = file_or_stdout($self, $outfile, $mode);
```

Returns an open filehandle by opening the specified file with the
given mode, or falls back to `\*STDOUT` when the file argument is
empty or `'-'`. If the invocant has a `get_outfile` accessor, that
value is used as the default filename when none is explicitly
provided.

| Argument | Description |
|---|---|
| `$self` | Object (used to call `get_outfile` if available) |
| `$outfile` | Path to output file, or `'-'` / `undef` for STDOUT |
| `$mode` | File open mode (default: `'r'`) |

---

## Bug Fixes

### `CLI::Simple::Utils` — `choose` Context Propagation Fixed

The `choose` block function was not correctly propagating calling
context into the supplied code block, which could cause unexpected
scalar/list/void behaviour depending on how the result was used. The
function now explicitly evaluates the block in list, scalar, or void
context to match the outer calling context.

---

## Files Changed

| File | Change |
|---|---|
| `VERSION` | Bumped to `2.0.14` |
| `lib/CLI/Simple.pm.in` | Accept `help_sections` in constructor; set defaults correctly; updated documentation |
| `lib/CLI/Simple/Utils.pm.in` | Fixed `choose` context propagation; added `file_or_stdout` |
| `README.md` | Regenerated from updated POD |

---

## Upgrading

This release is backwards compatible.
