# unify element type of samplers
randtype(dist) = eltype(dist)
randtype(::Type{D}) where {D<:MultivariateDistribution} = Vector{eltype(D)}
randtype(::Type{D}) where {D<:Sampleable{Multivariate}} = Vector{eltype(D)}
randtype(::Type{D}) where {D<:MatrixDistribution} = Matrix{eltype(D)}
randtype(::Type{D}) where {D<:Sampleable{Matrixvariate}} = Matrix{eltype(D)}

# cache for high-dimensional samplers
function cache(dist)
    T = randtype(typeof(dist))
    
    # only create a cache if the distribution produces mutable samples
    ArrayInterface.ismutable(T) || return nothing

    similar(T, size(dist))
end

"""
    isnormal(dist)

Test whether a distribution is normal.
"""
isnormal(dist) = false
isnormal(::Normal) = true
isnormal(::AbstractMvNormal) = true