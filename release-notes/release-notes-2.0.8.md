# CLI::Simple 2.0.8 Release Notes

## Release Date

2026-06-30

## Overview

This is a patch release of `CLI::Simple` that improves the default
installation directory resolution in `CLI::Simple::Modulino`. When
creating a modulino wrapper, the tool now correctly respects the
`PERL_LOCAL_LIB_ROOT` environment variable before falling back to the
system-wide `installsitebin` configuration.

## Changes

### Bug Fix / Improvement: `CLI::Simple::Modulino` — Default Install Directory Resolution

**Module:** `lib/CLI/Simple/Modulino.pm`  
**Function:** `create_modulino`

Previously, when no explicit `--installbindir` (`-i`) option was
provided to `create-modulino`, the tool would unconditionally query
Perl's `Config` module for the `installsitebin` path. This behaviour
was incorrect for users working in a local library environment (e.g.,
via `local::lib`), where installed binaries should go into the user's
local `bin` directory rather than the system site bin.

The resolution logic has been updated to the following priority order:

1. **Explicit `--installbindir` option** — used as-is if provided.
2. **`$PERL_LOCAL_LIB_ROOT/bin`** — used when the
   `PERL_LOCAL_LIB_ROOT` environment variable is defined (i.e., a
   `local::lib` environment is active).
3. **`installsitebin` from `Config`** — the previous default, now used
   only as a fallback when neither of the above apply.

#### Before

```perl
if ( !$installbindir ) {
    require Config;
    ($installbindir) = Config::config_re(qr/installsitebin/xsm);
    ($installbindir) = $installbindir =~ /=\'([^\']+)/xsm;
}
```

#### After

```perl
if ( !$installbindir ) {
    if ( defined $ENV{PERL_LOCAL_LIB_ROOT} ) {
        $installbindir = "$ENV{PERL_LOCAL_LIB_ROOT}/bin";
    }
    else {
        require Config;
        ($installbindir) = Config::config_re(qr/installsitebin/xsm);
        ($installbindir) = $installbindir =~ /=\'([^\']+)/xsm;
    }
}
```

## Impact

Users running `create-modulino` inside a `local::lib` environment
(where `PERL_LOCAL_LIB_ROOT` is set) will now have their modulino
wrapper scripts installed into `$PERL_LOCAL_LIB_ROOT/bin` by default,
without needing to explicitly pass the `-i` flag. This aligns the
tool's behaviour with standard `local::lib` conventions and avoids
accidental writes to system directories.

Users **not** using `local::lib` are unaffected — the fallback to
`installsitebin` behaves as before.

## Upgrading

No API changes. Drop-in replacement for 2.0.7.

```bash
cpanm CLI::Simple
```

---

*For full documentation, see [CLI::Simple on MetaCPAN](https://metacpan.org/pod/CLI::Simple).*  
*Maintained by Rob Lauer &lt;rclauer@gmail.com&gt;*
