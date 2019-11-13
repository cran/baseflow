#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME: 
 Check these declarations against the C/Fortran source code.
 */

/* .Call calls */
extern SEXP baseflow_bfi_for_r(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP baseflow_criteria_for_r(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP baseflow_criteria_vector_for_r(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP baseflow_perform_filtering_for_r(SEXP, SEXP, SEXP, SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"baseflow_bfi_for_r",               (DL_FUNC) &baseflow_bfi_for_r,               5},
  {"baseflow_criteria_for_r",          (DL_FUNC) &baseflow_criteria_for_r,          8},
  {"baseflow_criteria_vector_for_r",   (DL_FUNC) &baseflow_criteria_vector_for_r,   8},
  {"baseflow_perform_filtering_for_r", (DL_FUNC) &baseflow_perform_filtering_for_r, 5},
  {NULL, NULL, 0}
};

void R_init_baseflow(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
