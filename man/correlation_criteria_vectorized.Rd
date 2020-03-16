\name{corr_crit_vect}
\alias{corr_crit_vect}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Baseflow vectorized correlation criteria computation
}
\description{
Vectorized computation function of correlation criteria used by package \code{baseflow} to calibrate parameters of the baseflow separation algorithm. A scalar version of this function \code{correlation_criteria} also exists.
}
\usage{
corr_crit_vect(BasinData, alphas, taus, updateFunction = "quadr")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{BasinData}{
A \code{BasinData} object containing hydroclimatic data for the catchment under study.
}
  \item{alphas}{
Numeric vector of parameters of the filtering reservoir. Their dimension depends on the used update function. They must be positive.
}
  \item{taus}{
Vector of numbers of days used to compute cumulative effective rainfall. Must be an integer vector or any object that can be coerced to an integer vector. All values must be positive.
}
  \item{updateFunction}{
Character string giving reservoir function : must be one of \code{"quadr"}, \code{"lin"} or \code{"exp"}. Default is \code{"quadr"}.
}
}
\details{
Providing empty vectors or vectors containing missing or non-positive values for parameters \code{alphas} and \code{taus} throws an error.
}
\value{
A dataframe containing four columns and \code{length(alphas) * length(taus)} rows. Colums are the following:

\item{alpha}{Values of alpha}
\item{tau}{Values of tau}
\item{bfi}{Values of baseflow index, which depends on alpha}
\item{crit}{Computed values of correlation criterion}
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \url{https://doi.org/10.5194/hess-24-1171-2020}, 2020
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}

\seealso{
\code{\link{perform_filtering}}

\code{\link{BaseflowFilter}}

\code{\link{corr_crit}}

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

# Computing correlation criteria
data_crit <- corr_crit_vect(BasinData_Example,
                            alphas = seq(from = 100, to = 2000, by = 100),
                            taus = seq(from = 10, to = 370, by = 10),
                            updateFunction = "quadr")
}
\keyword{manip}