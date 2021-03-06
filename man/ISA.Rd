% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ISA.R
\name{ISA}
\alias{ISA}
\title{Iterated Stable Autoencoder}
\usage{
ISA(X, sigma = NA, delta = NA, noise = c("Gaussian", "Binomial"),
  transformation = c("None", "CA"), svd.cutoff = 0.001, maxiter = 1000,
  threshold = 1e-06, nu = min(nrow(X), ncol(X)), svdmethod = c("svd",
  "irlba"), center = TRUE)
}
\arguments{
\item{X}{a data frame or a matrix with numeric entries}

\item{sigma}{numeric, standard deviation of the Gaussian noise. By default sigma is estimated using the estim_sigma function with the MAD option}

\item{delta}{numeric, probability of deletion of each cell of
the data matrix when considering Binomial noise. By default delta = 0.5}

\item{noise}{noise model assumed for the data. By default "Gaussian"}

\item{transformation}{estimate a transformation of the original matrix; currently,
only correspondence analysis is available}

\item{svd.cutoff}{singular values smaller than this are treated as numerical error}

\item{maxiter}{integer, maximum number of iterations of ISA}

\item{threshold}{for assessing convergence (difference between two successive iterations)}

\item{nu}{integer, number of singular values to be computed - may be useful for very large matrices}

\item{svdmethod}{svd by default. irlba can be specified to use a fast svd method.
It can be useful to deal with large matrix. In this case, nu may be specified}

\item{center}{boolean, to center the data for the Gaussian noise model. By default "TRUE"}
}
\value{
mu.hat the estimator of the signal

nb.eigen the number of non-zero singular values

low.rank the results of the SVD of the estimator; for correspondence analysis, returns
                 the SVD of the CA transform

nb.iter number of iterations taken by the ISA algorithm
}
\description{
This function estimates a low-rank signal from noisy data
using the Iterated Stable Autoencoder. More precisely, it transforms
a noise model into a regularization scheme using a parametric bootstrap. 
In the Gaussian noise model, the procedure is equivalent to shrinking the
singular values of the data matrix (a non linear transformation of the singular
values is applied) whereas it gives other estimators with rotated singular vectors outside the Gaussian framework.
Within the framework of a Binomial or Poisson noise model, it is also possible
to find the low-rank approximation of a transformed version of the data matrix
for instance such as the one used in Correspondence Analysis.
}
\details{
When the data are continuous and assumed to be drawn from a Gaussian distribution
with expectation of low-rank and variance sigma^2, then ISA performs a regularized SVD by
corrupting the data with an homoscedastic Gaussian noise (default choice) with variance sigma^2.
A value for sigma has to be provided. When sigma is not known, it can be estimated using the
function estim_sigma.  

For count data, the subsampling scheme used to draw X can be considered as Binomial or Poisson (equivalent to
Binomial, delta = 0.5). ISA regularizes the data by corrupting the data with Poisson noise or by drawing
from a Binomial distribution of parameters X_ij and 1-delta divided by 1-delta. Thus it is necessary to give a value
for delta. When, the data are transformed with Correspondence Analysis (transfo = "CA"), this latter
noising scheme is also applied but on the data transformed with the CA weights.
The estimated low rank matrix is given in the output mu.hat. ISA automatically estimates the rank of the signal.
Its value is given in the output nb.eigen corresponding to the number of non-zero eigenvalues.
}
\examples{
Xsim <- LRsim(200, 500, 10, 4)
isa.gauss <- ISA(Xsim$X, sigma = 1/(4*sqrt(200*500)))
isa.gauss$nb.eigen

# isa.bin <- ISA(X, delta = 0.7, noise = "Binomial")

# A regularized Correspondence Analysis 
\dontrun{library(FactoMineR)
 perfume <-  read.table("http://factominer.free.fr/docs/perfume.txt",
 header=TRUE,sep="\\t",row.names=1)
 rownames(perfume)[4] <- "Cinema"
 isa.ca <- ISA(perfume, delta = 0.5, noise = "Binomial", transformation = "CA")
 rownames(isa.ca$mu.hat) <- rownames(perfume)
 colnames(isa.ca$mu.hat) <- colnames(perfume)
 res.isa.ca <- CA(isa.ca$mu.hat, graph = FALSE)
 plot(res.isa.ca, title = "Regularized CA", cex = 0.6, selectCol = "contrib 20")
 res.ca <- CA(perfume, graph = FALSE)
 plot(res.ca, title = "CA", cex = 0.6, selectCol = "contrib 20")}
}
\references{
Josse, J. & Wager, S. (2016). Bootstrap-Based Regularization for Low-Rank Matrix Estimation. Journal of Machine Learning Research.
}
\seealso{
\code{\link{estim_sigma}}

\code{\link{LRsim}}
}

