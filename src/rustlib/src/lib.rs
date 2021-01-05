#![allow(unused)]
#[macro_use]

extern crate rustr;
extern crate rayon;
extern crate roots;
pub mod export;
pub use rustr::*;
mod filter;

use filter::FilteringResult;

//Wrapping functions for R
// #[rustr_export]
pub fn perform_filtering_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, first_aprils: Vec<usize>) -> RResult<Vec<f64>> {
	let rust_result: FilteringResult = filter::perform_filtering(&update_type[..], &q, alpha, delta_t, &first_aprils[..]);
	Ok(rust_result.to_vec_for_r())
}

// #[rustr_export]
pub fn bfi_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, first_aprils: Vec<usize>) -> RResult<f64> {
	let rust_result: FilteringResult = filter::perform_filtering(&update_type[..], &q, alpha, delta_t, &first_aprils[..]);
	Ok(rust_result.bfi())
}

// #[rustr_export]
pub fn criteria_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, p: Vec<f64>, pet: Vec<f64>, tau: f64, first_aprils: Vec<usize>) -> RResult<f64> {
	Ok(filter::criteria_computation(&update_type[..], &q, alpha, delta_t, &p, &pet, tau, &first_aprils[..]))
}

// #[rustr_export]
pub fn criteria_vector_for_r(update_type: String, q: Vec<f64>, alphas: Vec<f64>, delta_t: f64, p: Vec<f64>, pet: Vec<f64>, taus: Vec<f64>, first_aprils: Vec<usize>) -> RResult<Vec<f64>> {
	Ok(filter::criteria_computation_vector(&update_type[..], &q, alphas, delta_t, &p, &pet, taus, &first_aprils[..]))
}

