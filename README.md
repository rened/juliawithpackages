## Per-project, declarative Julia package installations

**juliawithpackagesi**, or `jwp` for short, allows to declaratively specify which Julia packages a project should use, with exact version or commit details.

`jwp` will install the specified packages (if necessary) and start 'julia' with exactly these packages available. 

`jwp` is heavily inspired by the [nix package manager](http://nixos.org/nix/).

## Installation

You need to have `git` and `md5sum` installed. Clone this repository and make `jwp` accessible, for example by linking it to a directory that is already in your `PATH`:

```
ln -s jwp ~/local/bin/jwp
```

## Usage

Simply create a `REQUIRE.jwd` file in your project's directory and run `jwp` in that directory instead of `julia`. 

Example REQUIRE.jwd file:

```
# Julia packages:  Packagename [ version or commit hash]
JSON
HDF5 0.4.6
Images 86a43d8368

# Any Git URL:  URL [ version or commit hash ]
https://github.com/JuliaLang/BinDeps.jl.git
https://github.com/timholy/HDF5.jl.git 0.4.6
https://github.com/jakebolewski/LibGit2.jl.git dcbf6f2419f92edeae4014f0a293c66a3c053671
```

You can change both the name of the `REQUIRE.jwp` file as well as the julia binary called via environment variables. All arguments after `jwp` will be passed on to Julia:

```
REQUIRE=myrequire.txt JULIA=/usr/bin/juliafromgit jwp -e "println(123")
```

## Uninstall

Remove the symlink to `jwp` you created and delete all installed packages:

```
chmod -R +w $HOME/.julia/juliawithpackages && rm -rf $HOME/.julia/juliawithpackages
```

## How does it work?

Normally, Julia has a global, mutable state of installed packages in `$HOME/.julia/v0.x`.

`jwp`, in contrast, installs the packages for each unique `REQUIRE.jwd` file in a distinct location, and calls Julia with a modified `JULIA_PKGDIR`. Like this, Julia sees only the packages specified in `REQUIRE.jwd`, and different projects can easily specify which package versions (even individual commits) they would like to use.

The packages are actually installed in `$HOME/.julia/juliawithpackages/HASH/v0.x`, where `HASH` is the md5 hash over the contents of the `REQUIRE.jwd` file.

In addition to `JULIA_PKGDIR` the `JULIA_LOAD_PATH` is set to point to a `modules` subdirectory of where `jwp` was invoked. This is thus a great place to put any git submodules.

While cruft will accumulate over time in `$HOME/.julia/juliawithpackages`, the few MBs lost are a very cheap resource compared to programmer time and nerves. And, you can still simply delete that directory from time to time if you wantto.

