# Generated by using rustinr::rustrize() -> do not edit by hand


perform_filtering_for_r = function(update_type,q,alpha,delta_t,first_aprils){ .Call('wrap__perform_filtering_for_r',PACKAGE = 'baseflow', update_type,q,alpha,delta_t,as.numeric(first_aprils))}

bfi_for_r = function(update_type,q,alpha,delta_t,first_aprils){ .Call('wrap__bfi_for_r',PACKAGE = 'baseflow', update_type,q,alpha,delta_t,as.numeric(first_aprils))}

criteria_for_r = function(update_type,q,alpha,delta_t,p,pet,tau,first_aprils){ .Call('wrap__criteria_for_r',PACKAGE = 'baseflow', update_type,q,alpha,delta_t,p,pet,tau,as.numeric(first_aprils))}

criteria_vector_for_r = function(update_type,q,alphas,delta_t,p,pet,taus,first_aprils){ .Call('wrap__criteria_vector_for_r',PACKAGE = 'baseflow', update_type,q,alphas,delta_t,p,pet,taus,as.numeric(first_aprils))}
