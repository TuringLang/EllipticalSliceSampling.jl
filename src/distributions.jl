# define the element type of the samples
randtype(::Type{D}) where {D<:Distributions.MultivariateDistribution} = Vector{eltype(D)}
randtype(::Type{D}) where {D<:Distributions.MatrixDistribution} = Matrix{eltype(D)}
function randtype(
    ::Type{D}
) where {D<:Distributions.Sampleable{Distributions.Multivariate}}
    return Vector{eltype(D)}
end
function randtype(
    ::Type{D}
) where {D<:Distributions.Sampleable{Distributions.Matrixvariate}}
    return Matrix{eltype(D)}
end

# define trait for Gaussian distributions
isgaussian(::Type{<:Distributions.Normal}) = true
isgaussian(::Type{<:Distributions.NormalCanon}) = true
isgaussian(::Type{<:Distributions.AbstractMvNormal}) = true

# compute the proposal of the next sample
function proposal(prior::Distributions.Normal, f::Real, ν::Real, θ)
    sinθ, cosθ = sincos(θ)
    μ = prior.μ
    if iszero(μ)
        return cosθ * f + sinθ * ν
    else
        a = 1 - (sinθ + cosθ)
        return cosθ * f + sinθ * ν + a * μ
    end
end

function proposal(
    prior::Distributions.MvNormal,
    f::AbstractVector{<:Real},
    ν::AbstractVector{<:Real},
    θ
)
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    return @. cosθ * f + sinθ * ν + a * prior.μ
end

function proposal!(
    out::AbstractVector{<:Real},
    prior::Distributions.MvNormal,
    f::AbstractVector{<:Real},
    ν::AbstractVector{<:Real},
    θ
)
    sinθ, cosθ = sincos(θ)
    a = 1 - (sinθ + cosθ)
    @. out = cosθ * f + sinθ * ν + a * prior.μ
    return out
end
