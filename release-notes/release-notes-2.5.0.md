# CLI::Simple 2.5.0 Release Notes

## Overview

This release introduces automatic temporary file and directory management
for CLI applications. Resources can be declared through the
`CLI::Simple` constructor and are available before the application's
`init()` method is invoked.

The functionality is also provided by two independently reusable
`Role::Tiny` roles, `CLI::Simple::TempFile` and
`CLI::Simple::TempDir`.

## Temporary File and Directory Management

The `CLI::Simple` constructor now accepts `temp_file` and `temp_dir`
arguments for creating and managing temporary resources.

Each argument accepts a true value to create a single resource with
defaults, a hash reference to configure one resource, or an array
reference to declare multiple resources.

For example:

```perl
my $cli = __PACKAGE__->new(
    temp_dir => {
        accessor => 'workspace',
    },
    temp_file => [
        { accessor => 'report',    suffix => '.csv' },
        { accessor => 'debug_log', suffix => '.log', cleanup => 0 },
    ],
    commands => { process => \&cmd_process },
);
```

Temporary resources are created during construction and exposed through
automatically generated accessors such as `get_workspace()` and
`get_report()`.

By default, resources are removed when the owning application instance
is destroyed. Temporary directory cleanup includes any files and
subdirectories created within them. Setting `cleanup => 0` preserves
a resource after object destruction.

Resource declarations are validated before allocation, including
detection of duplicate or conflicting accessor names.

See the `TEMPORARY RESOURCES` section of the `CLI::Simple` documentation
for configuration options and usage.

## Independently Reusable Roles

The new `CLI::Simple::TempFile` and `CLI::Simple::TempDir` modules
provide `create_temp_file()` and `create_temp_dir()`, respectively.

Both are `Role::Tiny` roles that can be composed into applications
independently of `CLI::Simple`, providing temporary resource creation,
ownership, and cleanup without requiring the framework.

See the individual module documentation for standalone usage.

## Module Version Declarations

The subsidiary modules `CLI::Simple::DumpSpec`,
`CLI::Simple::Helpers`, `CLI::Simple::Migrate`,
`CLI::Simple::Modulino`, `CLI::Simple::Scaffold`, and
`CLI::Simple::Shell` now include explicit `$VERSION` declarations.

## Testing

New regression tests cover temporary file and directory management,
resource cleanup, accessor behavior, and constructor integration.
