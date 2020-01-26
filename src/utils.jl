import Pkg

@inline function _with_temp_dir(f::F) where F <: Base.Callable
    original_directory = pwd()
    my_tmp_dir = mktempdir(; cleanup=false)
    cd(my_tmp_dir)
    result = f(my_tmp_dir)
    cd(original_directory)
    rm(my_tmp_dir; force = true, recursive = true)
    return result
end

# @inline function _with_temp_depot(f::F) where F <: Base.Callable
#     return _with_temp_dir() do my_temp_depot
#         original_depot_path = deepcopy(Base.DEPOT_PATH)
#         empty!(Base.DEPOT_PATH)
#         push!(Base.DEPOT_PATH, my_temp_depot)
#         result = f(my_temp_depot)
#         empty!(Base.DEPOT_PATH)
#         for x in original_depot_path
#             push!(Base.DEPOT_PATH, x)
#         end
#         return result
#     end
# end

@inline function _with_temp_project(f::F) where F <: Base.Callable
    return _with_temp_dir() do my_temp_project
        original_active_project = Base.active_project()
        Pkg.activate(my_temp_project; shared = false)
        result = f(my_temp_project)
        Pkg.activate(original_active_project; shared = false)
        return result
    end
end

@inline function _activate_possibly_shared_project(project::AbstractString;
                                                   shared_project::Bool = false)
    if length(project) > 0 && project[1] == '@'
        Pkg.activate(project[2:end]; shared = true)
    else
        Pkg.activate(project; shared = shared_project)
    end
    Pkg.instantiate()
    return nothing
end

@inline function _with_different_project(f::F,
                                         project::AbstractString;
                                         shared_project::Bool = false) where F <: Base.Callable
    original_active_project = Base.active_project()
    _activate_possibly_shared_project(project; shared_project = shared_project)
    result = f(Base.active_project())
    Pkg.activate(original_active_project; shared = false)
    return result
end
