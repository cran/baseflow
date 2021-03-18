## Definition of a BaseflowFilter class to store filtering data for a basin

# Definition of object and a dummy prototype
setClass(
  Class = 'BaseflowFilter',
  representation = representation(
    BasinData = 'BasinData',
    R = 'numeric',
    V = 'numeric',
    update = 'logical',
    updateFunction = 'character',
    alpha = 'numeric'
  ),
  prototype = prototype(
    BasinData = new('BasinData'),
    R = rep(as.numeric(NA), new('BasinData')@nbTimeStep),
    V = rep(as.numeric(NA), new('BasinData')@nbTimeStep),
    update = rep(FALSE, new('BasinData')@nbTimeStep),
    updateFunction = 'lin',
    alpha = 1
  ),
  validity = function(object){
    if(all(c(length(object@R), length(object@V), length(object@update)) != rep(object@BasinData@nbTimeStep, 3))){
      stop('Filtering data must have the same length as basin data.')
    }
    if(length(object@updateFunction) != 1){
      stop('Update and recursion functions must be character strings.')
    }
    if(!(object@updateFunction %in% c('lin', 'quadr', 'exp'))){
      stop('Reservoir function must be one the following values : lin, quadr or exp.')
    }
  }
)

# Definition of various usual class methods
setMethod('as.data.frame', 'BaseflowFilter',
          function(x, row.names = NULL, optional = FALSE, ...){
            return(cbind(as.data.frame(x@BasinData), data.frame(R = x@R, V = x@V, update = x@update)))
          }
)
setMethod('summary', 'BaseflowFilter',
          function(object, ...){
            return(summary(as.data.frame(object)))
          }
)
setMethod('show', 'BaseflowFilter',
          function(object){
            cat(paste0('Update function : ', object@updateFunction, '\n'))
            show(as.data.frame(object))
          }
)
setMethod('print', 'BaseflowFilter',
          function(x, ...){
            cat(paste0('Update function : ', x@updateFunction, '\n'))
            print(as.data.frame(x))
          }
)
setMethod('plot', 'BaseflowFilter',
          function(x, y, ...){
            plot(x@BasinData@Dates, x@BasinData@Qobs, type = 'l',
                 col = 'blue', ylim = c(0, max(x@BasinData@Qobs, na.rm = TRUE)),
                 xlab = 'Date', ylab = 'Q (mm/day)')
            lines(x@BasinData@Dates, x@R, col = 'orange')
          }
)

# Constructor
BaseflowFilter <- function(BasinData, alpha, updateFunction = 'quadr'){
  if(!('BasinData' %in% class(BasinData))){
    stop('BasinData argument must be of class BasinData')
  }
  if(!(updateFunction %in% c('lin', 'quadr', 'exp'))){
    stop('Update function must be one the following values : lin, quadr or exp.')
  }
  return(new('BaseflowFilter', BasinData = BasinData, R = rep(as.numeric(NA), BasinData@nbTimeStep),
            V = rep(as.numeric(NA), BasinData@nbTimeStep), update = rep(FALSE, BasinData@nbTimeStep),
            updateFunction = updateFunction, alpha = alpha))
}

# Perform filtering method, wrapping from Rust
perform_filtering <- function(filter){
  if(class(filter) != 'BaseflowFilter'){
    stop('filter must be a BaseflowFilter object.')
  }
  rustResult <- perform_filtering_for_r(filter@updateFunction, filter@BasinData@Qobs, filter@alpha, 1,
                                        which(format(filter@BasinData@Dates, '%m%d') == '0401'))
  rustResult <- matrix(rustResult, ncol = 3, byrow = FALSE)
  filter@R <-  rustResult[,1]
  filter@V <- rustResult[,2]
  filter@update <- as.logical(rustResult[,3])
  return(filter)
}

# BFI method, wrapping from Rust
bfi <- function(filter){
  if(class(filter) != 'BaseflowFilter'){
    stop('filter must be a BaseflowFilter object.')
  }
  if(sum(is.na(filter@R)) > 0){
    rustResult <- bfi_for_r(filter@updateFunction, filter@BasinData@Qobs, filter@alpha, 1,
                            which(format(filter@BasinData@Dates, '%m%d') == '0401'))
  } else {
    rustResult <- mean(filter@R)/mean(filter@BasinData@Qobs)
  }
  return(rustResult)
}
