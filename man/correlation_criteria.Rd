\name{corr_crit}
\alias{corr_crit}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Baseflow correlation criterion computation
}
\description{
Computation function of correlation criterion used by package \code{baseflow} to calibrate parameters of the baseflow separation algorithm. A vectorized version of this function \code{correlation_criteria_vectorized} also exists.
}
\usage{
corr_crit(BasinData, alpha, tau, updateFunction = "quadr")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{BasinData}{
A \code{BasinData} object containing hydroclimatic data for the catchment under study.
}
  \item{alpha}{
Numeric parameter of the filtering reservoir. Its dimension depends on the used update function. Must be positive.
}
  \item{tau}{
Number of days used to compute cumulative effective rainfall. Must be a positive integer or any object that can be coerced to a positive integer.
}
  \item{updateFunction}{
Character string giving reservoir function : must be one of \code{"quadr"}, \code{"lin"} or \code{"exp"}. Default is \code{"quadr"}.
}
}
\details{
NA values are not permitted for parameters \code{alpha} and \code{tau}. If a vector is supplied, the first element is used.

Usage of gradient-based optimization algorithms is not recommended to find the maximum value of this criterion. It is a better option to use vectorized function \code{correlation_criteria_vectorized} to perform a grid-search; a non-gradient-based optimization algorithm, like differential evolution, may be used to refine the optimal point afterwards.
}
\value{
A numeric value of the computed criterion, between -1 and 1.
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrization for an imperfect method, Hydrol. Earth Syst. Sci. Discuss., \url{https://doi.org/10.5194/hess-2019-503}, in review, 2019
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}

\seealso{
\code{\link{perform_filtering}}

\code{\link{BaseflowFilter}}

\code{\link{corr_crit_vect}}

\code{\link{bfi}}
}
\examples{
library(baseflow)

# Loading example data from airGR package
data(L0123001, package = 'airGR')

# Defining BasinData object

Name <- BasinInfo$BasinName
startDate <- BasinObs$DatesR[1]
endDate <- BasinObs$DatesR[length(BasinObs$DatesR)]
P <- BasinObs$P
PET <- BasinObs$E
Qobs <- BasinObs$Qmm

BasinData_Example <- BasinData(Name, startDate, endDate, P, PET, Qobs, fill = "GR4J")

# Computing correlation criterion
corr_crit(BasinData_Example, 1500, 110, updateFunction = "quadr")
}
\keyword{manip}
