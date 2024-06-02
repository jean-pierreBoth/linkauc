# Some comments on paper : Link prediction using low-dimensional node embeddings: The measurement problem
See https://www.pnas.org/doi/10.1073/pnas.2312527121, *vmpcr* was defined as the following:
1. Delete a fraction of edges with a probability $p$ (usually 0.2), the remaining edges are train edges;
2. Do the embedding. Noting $q_i(j)$ the prediction index for an edge between nodes i and j;
3. For each node i, we remove the index node j corresponding to train (kept) edges, sort all remaining  $q_i(j)$ in the order such that prediction of edge between i and j is decreasing.  We note $q_i$ this sorted array.
Vcpmr is defined as a precision recall in the first k.
$vmpcr_{i}(k)=\frac{t_i(k)}{\min(r_i,k)}$
,where $t_i(k)$ is the number of deleted edges in the first k slots in the $q_i$ array while $r_i$ is the number of edges deleted from the full graph to the  graph used to recover deleted edges;
4. Then we can average over nodes i, 1000 nodes are used in the paper, thus defining  $vcpmr(k)$.

We provide here some comments and simulations related to the *vmpcr* precision estimator of the paper.

We point to some problems in the definition and propose a centric Auc to understand and mitigate the discrepancy between centric and global Auc estimators.

The Degrees directory contains degrees quantiles for some graphs. A Julia script provides estimates of the number of nodes with no edges deleted in tests, depending on edge deletion probability $p$ and degrees.  
