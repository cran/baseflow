# Criteria computation function
corr_crit <- function(BasinData, alpha, tau, updateFunction = 'quadr'){
  if(class(BasinData) != 'BasinData'){
    stop('BasinData must be of class BasinData.')
  }
  if(class(alpha) != 'numeric'){
    stop('alpha must be numeric.')
  }
  if(is.na(alpha)){
    stop('alpha cannot be NA.')
  }
  if(length(alpha) > 1){
    alpha <- alpha[1]
    warning('alpha is a vector. Using first value as parameter.')
  }
  if(is.na(as.integer(tau))){
    stop('tau cannot be coerced to a non-NA integer.')
  } else {
    tau <- as.numeric(as.integer(tau))
  }
  if(length(tau) > 1){
    tau <- tau[1]
    warning('tau is a vector. Using first value as parameter.')
  }
  if(!(updateFunction %in% c('lin', 'quadr', 'exp'))){
    stop('updateFunction must be one of the following : "lin", "quadr", "exp".')
  }
  criteria_for_r(updateFunction, BasinData@Qobs, alpha, 1, BasinData@P, BasinData@PET, tau,
                 which(format(BasinData@Dates, '%m%d') == '0401'))
}

# Criteria vectorized function
corr_crit_vect <- function(BasinData, alphas, taus, updateFunction = 'quadr'){
  if(!(updateFunction %in% c('lin', 'quadr', 'exp'))){
    stop('Update function must be one the following values : lin, quadr or exp.')
  }
  alphas <- as.numeric(alphas)
  if(sum(is.na(alphas)) > 0) {
    stop("alphas must be a positive numeric vector without missing values.")
  }
  if(sum(alphas <= 0) > 0) {
    stop("alphas must be a positive numeric vector without missing values.")
  }
  taus <- as.numeric(as.integer(taus))
  if(sum(is.na(taus)) > 0) {
    stop("taus must be a positive numeric vector without missing values.")
  }
  if(sum(taus <= 0) > 0) {
    stop("taus must be a positive numeric vector without missing values.")
  }
  crits <- criteria_vector_for_r(updateFunction, BasinData@Qobs, alphas, 1,
                                 BasinData@P, BasinData@PET, taus, which(format(BasinData@Dates, '%m%d') == '0401'))
  bfis <- sapply(seq_along(alphas), function(i) bfi(BaseflowFilter(BasinData, alphas[i], updateFunction)))
  data_crit <- expand.grid(alphas, taus)
  colnames(data_crit) <- c('alpha', 'tau')
  data_crit$bfi <- rep(bfis, length(taus))
  
  data_crit$crit <- crits
  return(data_crit)
}