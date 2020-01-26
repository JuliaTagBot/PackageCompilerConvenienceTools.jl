import Pkg

# @inline function _package_directory(m::Module)
#     return Base.pkgdir(m)
# end

# @inline function _package_directory(name::Symbol)
#     return _package_directory(string(name))
# end

# @inline function _package_directory(name::AbstractString)
#     for pkginfo in values(Pkg.dependencies())
#         if pkginfo.name == name
#             return pkginfo.source
#         end
#     end
#     return nothing
# end
