using DataFrames
using CSV

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
        removed = p * di + sigma * nbsigma
        if di <= k
            esp += proba * removed / di
        elseif di <= k / p    # k > di
            esp += proba * removed / k
        else
            esp += proba * min(k, removed) / k
            #            esp += proba
        end
    end
    println("mean degree : ", mean_degree)
    println("expected  vmpcr(under mean removed number of edges) : ", esp)
    return esp
end