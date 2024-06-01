using DataFrames
using CSV
using Printf

# This function returns expected vmpcr@k given degrees quantiles in a csv file as extracted from graphembed.
# (Cf https://github.com/jean-pierreBoth/graphembed)
#
# It computes for each node expected number of deleted edges and suppose they are all found up to k
# It is thus an expected result for a perfect embedding.
#
# k = the number at which we compute vmpcr@k
# p = deletion edge probability, usually 0.2
#
# nbsigma is to take into account incertitude around mean number of edge removed. default is 0
# but we can compute nb removed as d*p + nbsigma * sigma. 
# sigma in our case is sqrt(p * (1. - p) * degree)
#
# Usage:
#  julia> in Julia interpreter :
# include("e_vmpcr.jl")
# julia> e_vmcpr("amazon-degrees.csv", 10, 0.2)
# we get 0.263
# julia> e_vmcpr("amazon-degrees.csv", 10, 0.2, 1.)
# we get 0.6908
# So even if in each quantile the number of removed edges is at 1 sigma
# above mean, the expected vmpcr is under 0.691
# 
# For the blog Catalog graph we get 
# julia> e_vmcpr("blog-degree.csv", 10, 0.2)
# we get  0.566
# julia> e_vmcpr("blog-degree.csv", 10, 0.2, 1.)
# we get  0.74
#
function e_vmcpr(degreefile, k, p, nbsigma::Float64=0.0)
    #
    @assert p < 1.0
    # read csv file 
    df = CSV.read(degreefile, DataFrame)
    #
    mean_degree = 0
    degrees = df[:, 2]
    quants = df[:, 1]
    esp = 0.0
    nbslot = size(df)[1]
    esp += p * quants[1] * degrees[1]
    mean_degree += quants[1] * degrees[1]
    for i in 2:nbslot
        proba = quants[i] - quants[i-1]
        di = degrees[i]
        mean_degree += proba * di
        sigma = sqrt(p * (1.0 - p) * di)
        # removed edge is compute as mean + nbsigma sigma to get upper bounds
        removed = min(di, p * di + sigma * nbsigma)
        di_remain = di - removed
        if di_remain <= k
            esp += proba *  min(k, removed) / di_remain
        else
            esp += proba * min(k, removed) / k
        end
    end
    @printf("mean degree : %.3f", mean_degree)
    println()
    @printf("expected  vmpcr(under mean removed number of edges) : %.3f \n", esp)
    return esp
end