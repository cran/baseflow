\name{BaseflowFilter}
\alias{BaseflowFilter}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Constructor function of class \code{BaseflowFilter}
}
\description{
Standard construction function of \code{BaseflowFilter} objects, used by package \code{baseflow} to store filtering information for a given catchment. The object is created with NA values of baseflow and level of filtering reservoir, it is then necessary to run \code{perform_filtering} function to compute them.
}
\usage{
BaseflowFilter(BasinData, alpha, updateFunction = "quadr")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{BasinData}{
A \code{BasinData} object containing hydroclimatic data for the catchment under study.
}
  \item{alpha}{
Numeric parameter of the filtering reservoir. Its dimension depends on the used update function.
}
  \item{updateFunction}{
Character string giving reservoir function : must be one of \code{"quadr"}, \code{"lin"} or \code{"exp"}. Defalut is \code{"quadr"}.
}
}
\value{
A \code{BaseflowFilter} object containing provided data. Baseflow numeric field \code{R} and reservoir level \code{V} are filled with \code{NA}, it is thus necessary to call \code{perform_filtering} function to compute \code{R} and \code{V}.
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \url{https://doi.org/10.5194/hess-24-1171-2020}, 2020
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}
\seealso{
\code{\linkS4class{BasinData}}

\code{\linkS4class{BaseflowFilter}}

\code{\link{BasinData}}

\code{\link{perform_filtering}}
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

# Creating BaseflowFilter object
BaseflowFilter_Example <- BaseflowFilter(BasinData_Example, 1000, updateFunction = 'quadr')

# Computing baseflow
BaseflowFilter_Example <- perform_filtering(BaseflowFilter_Example)

# Plotting computed separation
plot(BaseflowFilter_Example)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}
