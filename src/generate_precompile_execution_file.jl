import Pkg
import Random

@inline function _precompile_execution_content(pkgs::AbstractVector{<:Symbol};
                                               notest::AbstractVector{<:Symbol} = Symbol[],
                                               test_stdlibs::Bool = false)
    stdlib_names = Symbol.(collect(values(Pkg.Types.stdlib())))
    result = "\n"
    result *= "import Pkg\n"
    result *= "import Test\n"
    for pkg in pkgs
        result *= "import $(pkg)\n"
        pkg_is_stdlib = pkg in stdlib_names
        pkg_is_not_stdlib = !pkg_is_stdlib
        pkg_is_in_notest = pkg in notest
        pkg_is_not_in_notest = !pkg_is_in_notest
        if pkg_is_not_in_notest && (test_stdlibs || pkg_is_not_stdlib)
            package_directory = _package_directory(pkg)
            if package_directory !== nothing
                package_runtests = joinpath(package_directory, "test", "runtests.jl")
                if isfile(package_runtests)
                    module_name = "Test_$(pkg)_$(Random.randstring(16))"
                    result *= "module $(module_name)\n"
                    result *= "include(\"$(package_runtests)\")\n"
                    result *= "end # end module $(module_name) \n"
                    result *= "import .$(module_name)\n"
                end
            end
        end
    end
    return result
end

@inline function _precompile_execution(filename::AbstractString,
                                       pkgs::AbstractVector{<:Symbol};
                                       notest::AbstractVector{<:Symbol} = Symbol[],
                                       test_stdlibs::Bool = false)
    precompile_execution_content =_precompile_execution_content(pkgs;
                                                                notest = notest,
                                                                test_stdlibs = test_stdlibs)
    rm(filename; force = true, recursive = true)
    mkpath(dirname(filename))
    open(filename, "w") do io
        print(io, precompile_execution_content)
    end
    return filename
end

@inline function _precompile_execution(pkgs::AbstractVector{<:Symbol};
                                       notest::AbstractVector{<:Symbol} = Symbol[],
                                       test_stdlibs::Bool = false)
    my_temp_dir = mktempdir(; cleanup=true)
    my_temp_name = joinpath(my_temp_dir, "precompile_execution_file.jl")
    return _precompile_execution(my_temp_name,
                                 pkgs;
                                 notest = notest,
                                 test_stdlibs = test_stdlibs)
end
