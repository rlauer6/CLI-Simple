# CLI::Simple 2.0.6 Release Notes

## Summary

`create-modulino` is promoted from a standalone Perl script to a proper
installable module (`CLI::Simple::Modulino`) with a generated bash
wrapper, and a correct exit code is now propagated from `main`.

---

## Changes

### `CLI::Simple::Modulino` (new module, replaces `bin/create-modulino.pl.in`)

`bin/create-modulino.pl.in` is renamed and moved to
`lib/CLI/Simple/Modulino.pm.in`.  The shebang line is removed and the
package declaration is retained, making it a proper installable module.

`caller or exit __PACKAGE__->main` - the `exit` was missing, so the
return value of `main` was never used as the process exit code.

The `@MODULE_NAME@` substitution token is renamed to
`@PERL_MODULE_NAME@` in both the template body and the embedded
`__DATA__` bash script, eliminating a collision with the autoconf
`@MODULE_NAME@` variable used in the build system.

A debug `print {*STDERR} $script` line is removed from
`cmd_create_modulino`.

### `bin/create-modulino.in` (new)

A bash wrapper stub is added as `bin/create-modulino.in`, generated
at build time via `do_subst`.  It sets `MODULINO_WRAPPER` and
`MODULE_NAME`, resolves the module path via `%INC`, and invokes
`perl $MODULE_PATH "$@"` - the same pattern used by all other
modulino wrappers in the distribution.

### `buildspec.yml`

`CLI::Simple::Modulino` added to `provides`.  Entries in `provides`
sorted alphabetically.
