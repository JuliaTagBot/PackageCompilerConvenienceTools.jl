using PackageCompilerConvenienceTools
using Test

import Pkg

@testset "PackageCompilerConvenienceTools.jl" begin
    @testset "utils.jl" begin
        PackageCompilerConvenienceTools._with_different_project(PackageCompilerConvenienceTools.default_project()) do activated_project
        end
    end
    @testset "public.jl" begin
        @testset "fast_and_simple" begin
            PackageCompilerConvenienceTools._with_temp_project() do my_temp_project
                PackageCompilerConvenienceTools._with_temp_dir() do my_temp_dir
                    Pkg.add("Crayons")
                    sysimage_path = joinpath(my_temp_dir, "ExampleSysimage.so")
                    @test !isfile(sysimage_path)
                    @test !ispath(sysimage_path)
                    @test_throws ArgumentError PackageCompilerConvenienceTools.fast_and_simple(my_temp_project;
                                                                                     shared_project = false,
                                                                                     replace_default = true)
                    @test !isfile(sysimage_path)
                    @test !ispath(sysimage_path)
                    PackageCompilerConvenienceTools.fast_and_simple(my_temp_project;
                                                          shared_project = false,
                                                          sysimage_path = sysimage_path)
                    @test isfile(sysimage_path)
                    @test ispath(sysimage_path)
                    p_1 = run(`$(Base.julia_cmd()) -J$(sysimage_path) --project=$(my_temp_project) -e 'import Crayons'`)
                    wait(p_1)
                    @test success(p_1)
                    p_2 = run(`$(Base.julia_cmd()) -J$(sysimage_path) --project=$(my_temp_project) -e 'import Pkg; Pkg.test("Crayons")'`)
                    wait(p_2)
                    @test success(p_2)
                end
            end
        end
    end

    if lowercase(strip(get(ENV, "CI", ""))) == "true"
        @testset "CI-only tests" begin
            @testset "CI public.jl" begin
                @testset "CI fast_and_simple" begin
                    PackageCompilerConvenienceTools._with_temp_project() do my_temp_project
                        PackageCompilerConvenienceTools._with_temp_dir() do my_temp__dir
                            Pkg.add("Crayons")
                            @test_throws ArgumentError PackageCompilerConvenienceTools.fast_and_simple(my_temp_project;
                                                                                             shared_project = false,
                                                                                             replace_default = true)
                            if !(Sys.iswindows())
                                PackageCompilerConvenienceTools.fast_and_simple(my_temp_project;
                                                                      shared_project = false,
                                                                      replace_default = true,
                                                                      force_replace_default = true)
                                p_1 = run(`$(Base.julia_cmd()) --project=$(my_temp_project) -e 'import Crayons'`)
                                wait(p_1)
                                @test success(p_1)
                                p_2 = run(`$(Base.julia_cmd()) --project=$(my_temp_project) -e 'import Pkg; Pkg.test("Crayons")'`)
                                wait(p_2)
                                @test success(p_2)
                            end
                        end
                    end
                end
            end
        end
    end
end
