# CLI::Simple 2.6.0

## Declarative Option Validation and Finalization

This release introduces `CLI::Simple::Options`, a new `Role::Tiny`
role that adds structured option validation and finalization to the
constructor lifecycle. Applications can now declare constraints and
post-processing callbacks directly alongside their `Getopt::Long`
specifications, rather than implementing equivalent logic by hand
inside `init()`.

### Extended option declarations

The `options` constructor argument (preferred spelling; `option_specs`
remains supported) now accepts a hash reference that associates each
option specification with an optional metadata hash:

```perl
my $cli = MyApp->new(
  options => {
    'config|c=s' => {
      type     => 'file',
      required => 1,
      slurp    => 1,
      finalize => sub {
        my ($self, $contents) = @_;
        return $self->parse_config($contents);
      },
    },
    'port|p=i' => {
      min => 1,
      max => 65535,
    },
  },
  commands => { serve => \&cmd_serve },
);
```

A plain array reference continues to work as before. The two forms
are interchangeable but cannot be supplied together; supplying both
`options` and `option_specs` is now a fatal error.

### Validation

`validate_options()` runs after all option sources — command-line,
registered providers, and defaults — have been resolved, so declared
constraints apply uniformly regardless of value origin. Supported
constraints: `required`, `min`, `max`, `min_length`, `max_length`,
`enum`, and filesystem path checks for `file` and `directory` types.
Option types are inferred from the `Getopt::Long` spec suffix when not
declared explicitly. Optional options with undefined values are skipped
silently.

### Finalization

`finalize_options()` invokes a per-option `finalize` callback after
successful validation. The callback receives the application instance
and the validated value; its return value replaces the accessor's
value. This is useful for deserializing configuration, expanding
paths, or constructing objects from raw strings.

### File slurping

Declaring `slurp => 1` on a `file`-typed option causes the file's
contents to be read and stored in the accessor before any finalizer
runs. If no finalizer is declared, the accessor holds the file
contents rather than the pathname.

### Constructor lifecycle update

`validate_options()` and `finalize_options()` are called after
`init_defaults()` and before `init_temp_resources()`, so the
application's `init()` method receives fully resolved, validated, and
finalized values through the normal accessors.

Eight new test files (t/13 through t/20) cover normalization,
validation, finalization, and slurp behavior in both direct and
constructor-invocation forms.

---
