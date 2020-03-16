\name{BaseflowFilter-class}
\Rdversion{1.1}
\docType{class}
\alias{BaseflowFilter-class}
\alias{as.data.frame,BaseflowFilter-method}
\alias{plot,BaseflowFilter-method}
\alias{print,BaseflowFilter-method}
\alias{show,BaseflowFilter-method}
\alias{summary,BaseflowFilter-method}

\title{Class \code{BaseflowFilter}}
\description{
Class used by package \emph{baseflow} to store results of a baseflow filtering for a given catchment.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("BaseflowFilter", ...)}, but it is recommended to use \code{BaseflowFilter} function to create this object.
}
\section{Slots}{
  \describe{
    \item{\code{BasinData}:}{Object of class \code{"BasinData"} giving hydroclimatic data of catchment (see \link{BasinData-class}).}
    \item{\code{R}:}{Vector of class \code{"numeric"} giving filtered baseflow.}
    \item{\code{V}:}{Vector of class \code{"numeric"} giving storage of the conceptual reservoir.}
    \item{\code{update}:}{Vector of class \code{"logical"}, \code{TRUE} at timesteps in which reservoir's level is updated, \code{FALSE} otherwise.}
    \item{\code{updateFunction}:}{Object of class \code{"character"} equal to \code{"quadr"}, \code{"lin"} or \code{"exp"}, giving the nature of the conceptual reservoir.}
    \item{\code{alpha}:}{Object of class \code{"numeric"} : value of \code{"alpha"} reservoir parameter.}
  }
}
\section{Methods}{
  \describe{
    \item{as.data.frame}{\code{signature(x = "BaseflowFilter")}: transforms object into dataframe.}
    \item{plot}{\code{signature(x = "BaseflowFilter")}: plots baseflow separation on the hydrograph.}
    \item{print}{\code{signature(x = "BaseflowFilter")}: prints object to console.}
    \item{show}{\code{signature(object = "BaseflowFilter")}: shows object in console.}
    \item{summary}{\code{signature(object = "BaseflowFilter")}: shows a summary of the object.}
	 }
}
\references{
Pelletier, A. and Andréassian, V.: Hydrograph separation: an impartial parametrisation for an imperfect method, Hydrol. Earth Syst. Sci., 24, 1171–1187, \url{https://doi.org/10.5194/hess-24-1171-2020}, 2020
}
\author{
Pelletier and Andreassian (\email{antoine.pelletier@irstea.fr})
}

\seealso{
\code{\link{BaseflowFilter}}

\code{\link{perform_filtering}}

\code{\linkS4class{BasinData}}
}
\examples{
showClass("BaseflowFilter")
}
\keyword{classes}
