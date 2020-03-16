\name{bfi}
\alias{bfi}
\title{
Baseflow index computing function
}
\description{
Function provided by package \code{baseflow} to compute baseflow index from a \code{BaseflowFilter} object.
}
\usage{
bfi(filter)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filter}{
A \code{BaseflowFilter} object created by \code{BaseflowFilter} function.
}
}
\details{
Computes baseflow index from a \code{BaseflowFilter} object, created by \code{BaseflowFilter} function. If the baseflow values have not been computed yet in the object, a Rust routine is called to compute baseflow ; else, baseflow is computed directly from baseflow and observed streamflow values. Providing a non-\code{BaseflowFilter} object creates an error.
}
\value{
A numeric giving computed baseflow index.
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \url{https://doi.org/10.5194/hess-24-1171-2020}, 2020
}
\seealso{
\code{\linkS4class{BaseflowFilter}}

\code{\link{BaseflowFilter}}

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

# Computing baseflow index
bfi(BaseflowFilter_Example)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{manip}