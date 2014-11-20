## Per-project, declarative Julia package installations

*juliawithpackages*, or `jwp` for short, allows to declaratively specify which Julia packages a project should use, with exact version or commit information.

Simply create a `REQUIRE.jwd` file in your project's directory and run `jwp` in that directory instead of `julia`. 

`jwp` will install the specified packages (if necessary) and start 'julia' with exactly these packages available. Additionally, it will pass through all command line arguments.

`jwp` is heavily inspired by the [nix package manager](http://nixos.org/nix/).

## Example REQUIRE.jwd file

```
# Julia packages:  Packagename [ version or commit hash]
JSON
HDF5 0.4.6
Images 86a43d8368

# Any Git URL:  URL [ version or commit hash ]
http://github.com:rened/BinDeps.jl.git
http://github.com:rened/HDF5.jl.git 0.4.6
http://github.com:rened/LibGit2.jl.git 9283d54a87de3253a66bfb48a0d0b3f677ed5e13
```

## Installation

You need to have `git` and `md5sum` installed. Clone this repository and make `jwp` accessible, for example by linking it to a directory that is already in your `PATH`:

```
ln -s jwp ~/local/bin
```

## Uninstall

Remove the symlink you created and delete all installed packages:

```
chmod -R +w $HOME/.julia/juliawithpackages && rm -rf $HOME/.julia/juliawithpackages
```

## How does it work?

Normally, Julia has a global, mutable state of installed packages in `$HOME/.julia/v0.X`.

`jwp`, in contrast, installs the packages for each unique `REQUIRE.jwd` file in a distinct location, and calls Julia with a modified `JULIA_PKGDIR`. Like this, Julia sees only the packages specified in `REQUIRE.jwd`, and different projects can easily specify which package versions (even individual commits) they would like to use.

The package are actually installed in `$HOME/.julia/juliawithpackages/HASH/v0.x`, where `HASH` is the md5 hash over the contents of the `REQUIRE.jwd` file.
