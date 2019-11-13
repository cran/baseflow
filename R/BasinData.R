## Definition of a BasinData object to store hydroclimatic data for a basin

# Definition of object and a dummy prototype from birthday
setClass(
  Class = 'BasinData',
  representation = representation(
    Name = 'character',
    Dates = 'POSIXct',
    nbTimeStep = 'integer',
    P = 'numeric',
    PET = 'numeric',
    Qobs = 'numeric'
  ),
  prototype = prototype(
    Name = 'Ouche in Crimolois',
    Dates = seq(from = as.POSIXct('1995-07-26', tz = 'UTC'),
                to = as.POSIXct(format(Sys.Date(), format = '%Y-%m-%d'), tz = 'UTC'),
                by = 'day'),
    nbTimeStep = as.integer(length(seq(from = as.POSIXct('1995-07-26', tz = 'UTC'),
                            to = as.POSIXct(format(Sys.Date(), format = '%Y-%m-%d'), tz = 'UTC'),
                            by = 'day'))),
    P = rep(0, as.integer(length(seq(from = as.POSIXct('1995-07-26', tz = 'UTC'),
                                     to = as.POSIXct(format(Sys.Date(), format = '%Y-%m-%d'), tz = 'UTC'),
                                     by = 'day')))),
    PET = rep(0, as.integer(length(seq(from = as.POSIXct('1995-07-26', tz = 'UTC'),
                                       to = as.POSIXct(format(Sys.Date(), format = '%Y-%m-%d'), tz = 'UTC'),
                                       by = 'day')))),
    Qobs = rep(0, as.integer(length(seq(from = as.POSIXct('1995-07-26', tz = 'UTC'),
                                        to = as.POSIXct(format(Sys.Date(), format = '%Y-%m-%d'), tz = 'UTC'),
                                        by = 'day'))))
  ),
  validity = function(object){
    if(is.na(object@nbTimeStep)){
      stop('Number of time steps cannot be NA.')
    }
    if(object@nbTimeStep < 0){
      stop('The number of time steps has to be non-negative.')
    }
    if(length(object@Dates) != object@nbTimeStep){
      stop('Length of Dates vector is not equal to the number of time steps.')
    }
    if(length(object@P) != object@nbTimeStep){
      stop('Length of P vector is not equal to the number of time steps.')
    }
    if(length(object@PET) != object@nbTimeStep){
      stop('Length of PET vector is not equal to the number of time steps.')
    }
    if(length(object@Qobs) != object@nbTimeStep){
      stop('Length of Qobs vector is not equal to the number of time steps.')
    }
    if(length(which(is.na(object@Dates))) > 0){
      stop('Dates vector contains NAs. Missing values are forbidden.')
    }
    if(length(which(is.na(object@P))) > 0){
      stop('P vector contains NAs. Missing values are forbidden.')
    }
    if(length(which(is.na(object@PET))) > 0){
      stop('PET vector contains NAs. Missing values are forbidden.')
    }
    if(length(which(is.na(object@Qobs))) > 0){
      stop('Qobs vector contains NAs. Missing values are forbidden. Consider using one of filling methods provided.')
    }
    return(TRUE)
  }
)
#test <- new('BasinData')

# Definition of plot, show and summary methods
setMethod('print', 'BasinData',
          function(x, ...){
            cat(paste0(x@Name, '\n'))
            cat('Dates\n')
            print(x@Dates)
            cat('P\n')
            print(x@P)
            cat('PET\n')
            print(x@PET)
            cat('Qobs\n')
            print(x@Qobs)
          }
)
setMethod('show', 'BasinData',
          function(object){
            cat(paste0(object@Name, '\n'))
            cat('Dates\n')
            print(object@Dates)
            cat('P\n')
            print(object@P)
            cat('PET\n')
            print(object@PET)
            cat('Qobs\n')
            print(object@Qobs)
          }
)
setMethod('summary', 'BasinData',
          function(object, ...){
            cat(paste0(object@Name, '\n'))
            summary(data.frame(Dates = object@Dates, P = object@P, PET = object@PET, Qobs = object@Qobs))
          }
)
setMethod('as.data.frame', 'BasinData',
          function(x, row.names = NULL, optional = FALSE, ...){
            return(data.frame(Dates = x@Dates, P = x@P, PET = x@PET, Qobs = x@Qobs))
          })

#Constructor
BasinData <- function(Name, startDate, endDate, P, PET, Qobs, fill = 'none'){
  if(!is.character(Name)){
    stop('Name must me a character string.')
  }
  if(!('POSIXct' %in% class(startDate))){
    stop('startDate must be a POSIXct object.')
  }
  if(!('POSIXct' %in% class(endDate))){
    stop('endDate must be a POSIXct object.')
  }
  if(!is.numeric(P)){
    stop('P must be a numeric vector.')
  }
  if(!is.numeric(PET)){
    stop('PET must be a numeric vector.')
  }
  if(!is.numeric(Qobs)){
    stop('Qobs must be a numeric vector.')
  }
  Dates <- seq(from = startDate, to = endDate, by = 'day')
  nbTimeStep <- length(Dates)
  if(length(P) != nbTimeStep){
    stop('Length of P vector is incorrect.')
  }
  if(length(PET) != nbTimeStep){
    stop('Length of PET vector is incorrect.')
  }
  if(length(Qobs) != nbTimeStep){
    stop('Length of Qobs vector is incorrect.')
  }
  if(!(fill %in% c('none', 'GR4J', 'GR5J', 'GR6J'))){
    stop('Unknown value of fill.')
  }
  if(fill != 'none'){
    Qobs <- fill_airGR(data.frame(Dates = Dates, P = P, PET = PET, Qobs = Qobs), fill)
  }
  startDate_day <- as.POSIXct(format(startDate, '%Y-%m-%d'), tz = 'UTC')
  if(startDate_day != startDate){
    startDate <- startDate_day
    warning('startDate must be provided as a POSIXct object containing only a UTC date, without time. It is now rounded to the day before.')
  }
  endDate_day <- as.POSIXct(format(endDate, '%Y-%m-%d'), tz = 'UTC')
  if(endDate_day != endDate){
    endDate <- endDate_day
    warning('endDate must be provided as a POSIXct object containing only a UTC date, without time. It is now rounded to the day before.')
  }
  return(new('BasinData', Name = Name, Dates = Dates, nbTimeStep = nbTimeStep, P = P, PET = PET, Qobs = Qobs))
}
# Filling function for flow missing values, not supposed to be used out of BasinData function
fill_airGR <- function(data_peq, fill){
  #require(airGR)
  runMod <- switch(fill,
                   "GR4J" = RunModel_GR4J,
                   "GR5J" = RunModel_GR5J,
                   "GR6J" = RunModel_GR6J)
  entree <- CreateInputsModel(runMod, data_peq$Dates, data_peq$P, PotEvap = data_peq$PET, verbose = FALSE)
  options_calib <- CreateCalibOptions(runMod)
  options_run <- CreateRunOptions(runMod, entree,
                                  IndPeriod_WarmUp = 1:365, IndPeriod_Run = 366:length(data_peq$P),
                                  verbose = FALSE)
  critere <- CreateInputsCrit(ErrorCrit_NSE, entree, options_run,
                              Obs = list(data_peq$Qobs[366:length(data_peq$P)]), VarObs = 'Q')
  calib <- Calibration_Michel(entree, options_run, critere, options_calib, runMod, verbose = FALSE)
  sim <- runMod(entree, options_run, calib$ParamFinalR)
  if(fill == 'GR6J'){
    ini_state <- CreateIniStates(runMod, entree, ProdStore = mean(sim$Prod, na.rm = TRUE),
                                 RoutStore = mean(sim$Rout, na.rm = TRUE),
                                 ExpStore = mean(sim$Exp, na.rm = TRUE))
  } else {
    ini_state <- CreateIniStates(runMod, entree, ProdStore = mean(sim$Prod, na.rm = TRUE),
                                 RoutStore = mean(sim$Rout, na.rm = TRUE))
  }
  options_run <- CreateRunOptions(runMod, entree, IndPeriod_WarmUp = 0L, IndPeriod_Run = 1:length(data_peq$P),
                                  IniStates = ini_state, verbose = FALSE)
  sim <- runMod(entree, options_run, calib$ParamFinalR)
  Qobs <- data_peq$Qobs
  Qobs[is.na(Qobs)] <- sim$Qsim[is.na(Qobs)]
  return(Qobs)
}

