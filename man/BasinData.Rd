\name{BasinData}
\alias{BasinData}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Constructor function of class \code{BasinData}
}
\description{
Standard construction function of \code{BasinData} objects, used by package \code{baseflow} to store daily hydroclimatic data for a given catchment. As the separation algorithm proposed in \code{baseflow} does not handle missing streamflow values, a filling routine using \code{airGR} package is provided.
}
\usage{
BasinData(Name, startDate, endDate, P, PET, Qobs, fill = "none")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Name}{
Character string giving the name of the catchment. Can be a code or a plain-text description.
}
  \item{startDate}{
Starting date of hydroclimatic data as a \code{POSIXct} object.
}
  \item{endDate}{
End date of hydroclimatic data as a \code{POSIXct} object.
}
  \item{P}{
Numeric vector giving daily total lumped precipitation over the catchment, in mm. Must be of the same length as \code{PET} and \code{Qobs}.
}
  \item{PET}{
Numeric vector giving daily total lumped potential evapotranspiration over the catchment, in mm. Must be of the same length as \code{P} and \code{Qobs}.
}
  \item{Qobs}{
Numeric vector giving daily streamflow of the catchment, as depth of runoff in mm. Must be of the same length as \code{PET} and \code{Qobs}.
}
  \item{fill}{
Character string describing filling methods. Must be one of the following : \code{"none"} (no filling, default), \code{"GR4J"}, \code{"GR5J"} or \code{"GR6J"}.
}
}
\details{
The expected length of data vectors is equal to the number of days between the two provided dates. It is recommended to store data into a data frame before using this function.
This function does not handle missing values : any \code{NA} will produce an error. If there are missing values in streamflow, the \code{fill} argument must be different from \code{"none"}.
Filling routine requires \code{airGR} package. One of the following hydrological lumped models can be used : GR4J, GR5J or GR6J. See \code{airGR} documentation for further details.
}
\value{
A \code{BasinData} object containing provided data.
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \doi{10.5194/hess-24-1171-2020}, 2020
}
\seealso{
\code{\linkS4class{BasinData}}

\code{\linkS4class{BaseflowFilter}}

\code{\link{BaseflowFilter}}
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
}
\keyword{manip}

