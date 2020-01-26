import PackageCompilerX

@inline function default_project()
    return "@v$(Base.VERSION.major).$(Base.VERSION.minor)"
end

@inline function fast_and_simple(project::AbstractString = _default_project();
                                 sysimage_path::Union{AbstractString, Nothing} = nothing,
                                 notest::AbstractVector{<:Symbol} = Symbol[],
                                 replace_default::Bool = false,
                                 shared_project::Bool = false,
                                 test_stdlibs::Bool = false,
                                 force_replace_default::Bool = false)
    if replace_default && project != default_project()
        msg = "`replace_default` is `true` but `project` is not the default project (`$(default_project())`)"
        if force_replace_default
            @warn(msg)
        else
            throw(ArgumentError(msg))
        end
    end
    _with_different_project(project; shared_project = shared_project) do activated_project
        _add_all_project_recursive_dependencies()
        project_recursive_dependencies = unique(Symbol.(_get_project_recursive_dependencies()))
        precompile_execution = _precompile_execution(project_recursive_dependencies;
                                                     notest = notest,
                                                     test_stdlibs = test_stdlibs)
        PackageCompilerX.create_sysimage(project_recursive_dependencies;
                                         project = dirname(activated_project),
                                         replace_default = replace_default,
                                         sysimage_path = sysimage_path,
                                         precompile_execution_file=precompile_execution)
        return nothing
    end
    return nothing
end
