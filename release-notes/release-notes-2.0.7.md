# CLI::Simple 2.0.7

## Bug Fix

### `CLI::Simple::Modulino` — `create-modulino` install directory resolution

`create-modulino` previously resolved the installation directory via
`FindBin::$RealBin` when `--installbindir` was not supplied. This
caused the wrapper script to be written into the PERL5LIB directory
rather than the correct site bin directory.

The fallback now queries `Config::config_re` for `installsitebin`,
matching the directory Perl's toolchain uses for installed scripts.
`FindBin` is no longer imported.

The error message on a missing or inaccessible directory now includes
the resolved path to aid diagnosis.
