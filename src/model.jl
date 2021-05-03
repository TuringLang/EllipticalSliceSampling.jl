# internal model structure consisting of prior and log-likelihood function

struct ESSModel{P,L} <: AbstractMCMC.AbstractModel
    "Gaussian prior."
    prior::P
    "Log likelihood function."
    loglikelihood::L

    function ESSModel{P,L}(prior::P, loglikelihood::L) where {P,L}
        isgaussian(P) || error("prior distribution has to be a Gaussian distribution")
        return new{P,L}(prior, loglikelihood)
    end
end

function ESSModel(prior, loglikelihood)
    return ESSModel{typeof(prior),typeof(loglikelihood)}(prior, loglikelihood)
end

# obtain prior
prior(model::ESSModel) = model.prior

# evaluate the loglikelihood of a sample
Distributions.loglikelihood(model::ESSModel, f) = model.loglikelihood(f)
