\name{BasinData-class}
\Rdversion{1.1}
\docType{class}
\alias{BasinData-class}
\alias{as.data.frame,BasinData-method}
\alias{print,BasinData-method}
\alias{show,BasinData-method}
\alias{summary,BasinData-method}

\title{Class \code{BasinData}}
\description{
Class used by package \emph{baseflow} to store hydroclimatic data from a given catchment.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("BasinData", ...)}, but it is recommended to use \code{BasinData} function to create this object.
%%  ~~ describe objects here ~~ 
}
\section{Slots}{
  \describe{
    \item{\code{Name}:}{Object of class \code{"character"} giving the name of the catchment (e.g. \samp{Seine in Paris}}
    \item{\code{Dates}:}{Vector of \code{"POSIXct"} dates giving timestamps of measures}
    \item{\code{nbTimeStep}:}{Object of class \code{"integer"} giving the number of measures}
    \item{\code{P}:}{Vector of total precipitation of length \samp{nbTimeStep}}
    \item{\code{PET}:}{Vector of potential evapotranspiration of length \samp{nbTimeStep}}
    \item{\code{Qobs}:}{Vector of observed streamflow of length \samp{nbTimeStep}}
  }
}
\section{Methods}{
  \describe{
    \item{as.data.frame}{\code{signature(x = "BasinData")}: transforms object into a data frame.}
    \item{print}{\code{signature(x = "BasinData")}: prints object to console}
    \item{show}{\code{signature(object = "BasinData")}: shows object}
    \item{summary}{\code{signature(object = "BasinData")}: show a summary of object}
	 }
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrization for an imperfect method, Hydrol. Earth Syst. Sci. Discuss., \url{https://doi.org/10.5194/hess-2019-503}, in review, 2019
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}

\seealso{
\code{\link{BasinData}}

\code{\linkS4class{BaseflowFilter}}
}
\examples{
showClass("BasinData")
}
\keyword{classes}
