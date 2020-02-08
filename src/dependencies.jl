import Pkg

@inline function _get_project_recursive_dependencies()
    result = Vector{String}(undef, 0)
    for pkginfo in values(Pkg.dependencies())
        push!(result, pkginfo.name)
    end
    append!(result, collect(values(Pkg.Types.stdlibs())))
    unique!(result)
    return result
end

@inline function _add_all_project_recursive_dependencies()
    pkg_names_to_add = Vector{String}(undef, 0)
    for pkginfo in values(Pkg.dependencies())
        push!(pkg_names_to_add, pkginfo.name)
    end
    append!(pkg_names_to_add, collect(values(Pkg.Types.stdlibs())))
    unique!(pkg_names_to_add)
    Pkg.add(pkg_names_to_add)
    return nothing
end
