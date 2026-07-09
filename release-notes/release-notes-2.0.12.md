# CLI::Simple 2.0.12 Release Notes

## Overview

This release introduces two new features: a `command_args` accessor
method for directly getting and setting the command argument list, and
a `validate_command` constructor option that allows bypassing
automatic command validation. It also adds stricter input validation
to the constructor by checking all passed options against a known-good
list.

---

## What's New

### `command_args` Method

A new public method `command_args` has been added to `CLI::Simple`. It
provides a convenient way to get or set the current command argument
list.

- When called with no arguments, returns an array reference of the
  current positional arguments (similar to `get_args` in scalar
  context).
- When called with an array or list, replaces the argument list
  entirely.

```perl
# get the current argument list
my $args = $self->command_args();

# replace or extend the argument list
$self->command_args(@{$args}, 'new_arg');
```

This method is particularly useful in `init()` when implementing
flexible command dispatch patterns (see `validate_command` below).

---

### `validate_command` Constructor Option

A new `validate_command` option has been added to the `new()`
constructor. By default, `CLI::Simple` validates that the command
provided on the command line has been registered, throwing an
exception if it has not. Setting `validate_command` to a false value
disables this check.

```perl
my $cli = MyScript->new(
  option_specs     => [...],
  commands         => { get => \&cmd_get },
  validate_command => 0,
);
```

This is intended for scripts that want to support a default command
with implicit arguments. For example, if `foo get something` and `foo
something` should both work:

```perl
sub init {
  my ($self) = @_;

  my @args = $self->get_args;

  if ( !@args ) {
    $self->command_args( $self->command() );  # treat the command token as an argument
    $self->command('get');                    # set the real command
  }
  else {
    die "ERROR: unknown command\n"
      if !$self->commands->{ $self->command };
  }

  return;
}
```

> **Note:** This pattern works reliably only when commands have a
> deterministic number of arguments.

---

### Constructor Option Validation

The `new()` constructor now validates all passed keys against the list
of known valid options. Passing an unrecognised option will cause an
immediate exception:

```
ERROR: unknown option 'foo'
```

The list of valid constructor options is defined in
`CLI::Simple::Constants` as `@VALID_OPTIONS` and is now exported:

```perl
use CLI::Simple::Constants qw(@VALID_OPTIONS);
```

Valid constructor options are:

| Option | Description |
|---|---|
| `abbreviations` | Enable abbreviated command names |
| `alias` | Option and command aliases |
| `commands` | Command dispatch table (required) |
| `default_options` | Default option values |
| `error_handler` | Custom `GetOptions` error handler |
| `extra_options` | Additional accessor names |
| `option_specs` | `Getopt::Long` option specifications |
| `validate_command` | Toggle command validation (new) |

---

## Tests

- Added a new subtest `unknown option` to `t/01-cli-simple.t`
  verifying that passing an unrecognised key to the constructor throws
  an error matching `/unknown\soption/`.

---

## Bug Fixes and Minor Changes

- `validate_command` (the internal method) now also returns early if
  the `_validate_command` attribute is false, in addition to the
  existing check for a missing command.
- POD has been updated throughout to document the new `command_args`
  and `validate_command` features.

---

## Upgrade Notes

This release is backwards compatible. Existing code will continue to
work without modification. The new constructor-level option validation
may surface errors in code that was inadvertently passing unrecognised
keys to `new()` — these would have been silently ignored in prior
releases.

---

## Author

Rob Lauer — `rclauer@gmail.com`
