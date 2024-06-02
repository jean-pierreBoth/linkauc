using DataFrames
using CSV
using Printf
using Distributions


# This function returns expected number of nodes with no edges deleted with graph degrees quantiles in a csv file as extracted from graphembed.
# (Cf https://github.com/jean-pierreBoth/graphembed)
#
#
# Usage:
#  julia> in Julia interpreter :
# include("e_vmpcr.jl")
# 
# Then for an edge deletion of probability 0.2 we get 
# julia> removed("amazon-degrees.csv", 0.2)
# proba node zero edge removed : 0.389
# 
# For the blog Catalog graph we get 
#julia> removed("blog-degree.csv", 0.2)
# proba node zero edge removed : 0.120 


# compute number of nodes with null removed edges
function removed(degreefile,p)
    @assert p < 1.0
    # read csv file 
    df = CSV.read(degreefile, DataFrame)
    #
    degrees = df[:, 2]
    quants = df[:, 1]
    proba_zero = 0.
    nbslot = size(df)[1]
    b = Binomial(degrees[1], p)
    q = cdf(b,0)
    proba_zero += quants[1]
    for i in 2:nbslot 
        b = Binomial(degrees[i], p)
        q = cdf(b,0)
        proba_zero += q * (quants[i] - quants[i-1])
    end
    @printf("proba node zero edge removed : %.3f \n", proba_zero)    
    return proba_zero
end