## Per-project, declarative Julia package installations

*juliawithpackages*, or `jwp` for short, allows to declaratively specify which Julia packages a project should use, with exact version or commit information.

Simply create a `REQUIRE` file in your project's directory and run `jwp` in that directory instead of `julia`. 

`jwp` will install the specified packages (if necessary) and start 'julia' with exactly these packages available. Additionally, it will pass through all command line arguments.

## Example REQUIRE file

```
# Install julia packages
JSON
HDF5 0.4.6
Images 86a43d8368

# Directly install any Git URL 
git@github.com:rened/BinDeps.jl.git
git@github.com:rened/LibGit2.jl.git 9283d54a87de3253a66bfb48a0d0b3f677ed5e13
```

## Installation

You need to have `git` and `md5sum` installed. Clone this repository and make `jwp` accessible, for example by linking it to a directory that is already in your `PATH`:

```
ln -s jwp ~/local/bin
```

## How does it work?

Normally, Julia has a global, mutable state of installed packages in `$HOME/.julia/v0.X`.

`jwp`, in contrast, installs the packages for each unique `REQUIRE` file in a distinct location, and calls Julia with a modified `JULIA_PKGDIR`. Like this, Julia sees only the packages specified in `REQUIRE`, and different projects can easily specify which package versions (even individual commits) they would like to use.
