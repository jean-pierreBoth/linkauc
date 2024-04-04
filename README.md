# Some comments on paper : Link prediction using low-dimensional node embeddings: The measurement problem
See https://www.pnas.org/doi/10.1073/pnas.2312527121

We provide here some comments and simulations related to the *vmpcr* precision estimator of the paper.

We try to motivate why it is so low with respect to global AUC and propose a centric Auc to understand and mitigate the discrepancy between centric and global Auc estimators.

The Degrees directory contains degrees quantiles for some graphs. A Julia script provides estimates of expected *vmpcr@k* depending on edge deletion probability, $k$. An extra parameter gives the possibility to get *vmpcr* estimates if the expected number of deleted edges is *nbsigma* standard deviation above mean.  