\name{perform_filtering}
\alias{perform_filtering}
\title{
Baseflow filtering function
}
\description{
Function provided by package \code{baseflow} to compute baseflow variables from a raw \code{BaseflowFilter} object. It must be called after calling the \code{BaseflowFilter} function.
}
\usage{
perform_filtering(filter)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filter}{
A \code{BaseflowFilter} object created by \code{BaseflowFilter} function.
}
}
\details{
Providing a non-\code{BaseflowFilter} object creates an error. The function calls a Rust routine to compute vectors \code{R} (baseflow) and \code{V} (reservoir level) from parameters and hydroclimatic data stored in \code{filter} object.
}
\value{
A \code{BaseflowFilter} object with the same parameters and \code{BasinData} slots as input, but \code{R}, \code{V} and \code{update} slots are replaced by computed values.
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \url{https://doi.org/10.5194/hess-24-1171-2020}, 2020
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}
\seealso{
\code{\linkS4class{BaseflowFilter}}

\code{\link{BaseflowFilter}}

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