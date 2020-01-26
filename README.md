# PackageCompilerConvenienceTools

[![Build Status](https://travis-ci.com/bcbi/PackageCompilerConvenienceTools.jl.svg?branch=master)](https://travis-ci.com/bcbi/PackageCompilerConvenienceTools.jl/branches)
[![Codecov](https://codecov.io/gh/bcbi/PackageCompilerConvenienceTools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bcbi/PackageCompilerConvenienceTools.jl)

`PackageCompilerConvenienceTools` provides some convenience functions that make it
easier to use [`PackageCompilerX`](https://github.com/KristofferC/PackageCompilerX.jl).

## Installation

### Recommended method

```bash
git clone https://github.com/bcbi/PackageCompilerConvenienceTools.jl
cd PackageCompilerConvenienceTools.jl
julia --project -e 'import Pkg; Pkg.instantiate()'
```

### Alternate method (useful if you don't have Git on your computer)

```bash
julia -e 'import Pkg; Pkg.add("GitCommand")'
julia -e 'import GitCommand; GitCommand.git() do git run(`$(git) clone https://github.com/bcbi/PackageCompilerConvenienceTools.jl`) end'
cd PackageCompilerConvenienceTools.jl
julia --project -e 'import Pkg; Pkg.instantiate()'
```

## Examples

### already have packages

#### don't overwrite

```julia
julia> using PackageCompilerConvenienceTools

julia> PackageCompilerConvenienceTools.fast_and_simple(project;
                                             shared_project = shared_project,
                                             sysimage_path = "ExampleSysimage.so")
```

#### overwrite

```julia
julia> using PackageCompilerConvenienceTools

julia> PackageCompilerConvenienceTools.fast_and_simple(project;
                                             shared_project = shared_project,
                                             replace_default = true)
```

```julia
julia> using PackageCompilerConvenienceTools

julia> PackageCompilerConvenienceTools.restore_default_sysimage()
```

### don't have packages

#### don't overwrite

```julia
julia> using PackageCompilerConvenienceTools

julia> using Pkg

julia> project = "v$(VERSION.major).$(VERSION.minor)"

julia> shared_project = true

julia> Pkg.activate(project;
                    shared = shared_project)

julia> Pkg.add("Crayons")

julia> PackageCompilerConvenienceTools.fast_and_simple(project;
                                             shared_project = shared_project,
                                             sysimage_path = "ExampleSysimage.so")
```

#### overwrite

```julia
julia> using PackageCompilerConvenienceTools

julia> using Pkg

julia> project = "v$(VERSION.major).$(VERSION.minor)"

julia> shared_project = true

julia> Pkg.activate(project;
                    shared = shared_project)

julia> Pkg.add("Crayons")

julia> PackageCompilerConvenienceTools.fast_and_simple(project;
                                             shared_project = shared_project,
                                             replace_default = true)
```

```julia
julia> using PackageCompilerConvenienceTools

julia> PackageCompilerConvenienceTools.restore_default_sysimage()
```
