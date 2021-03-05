#![allow(unused)]
#[macro_use]

extern crate rayon;
extern crate roots;
extern crate extendr_api;

use extendr_api::prelude::*;
mod filter;

use filter::FilteringResult;

//Wrapping functions for R
#[extendr]
fn perform_filtering_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, first_aprils: Vec<f64>) -> Vec<f64> {
	let first_aprils_usize: Vec<usize> = first_aprils.iter().map(|x| *x as usize).collect();
	let rust_result: FilteringResult = filter::perform_filtering(&update_type[..], &q, alpha, delta_t, &first_aprils_usize[..]);
	rust_result.to_vec_for_r()
}

#[extendr]
fn bfi_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, first_aprils: Vec<f64>) -> f64 {
  let first_aprils_usize: Vec<usize> = first_aprils.iter().map(|x| *x as usize).collect();
	let rust_result: FilteringResult = filter::perform_filtering(&update_type[..], &q, alpha, delta_t, &first_aprils_usize[..]);
	rust_result.bfi()
}

#[extendr]
fn criteria_for_r(update_type: String, q: Vec<f64>, alpha: f64, delta_t: f64, p: Vec<f64>, pet: Vec<f64>, tau: f64, first_aprils: Vec<f64>) -> f64 {
  let first_aprils_usize: Vec<usize> = first_aprils.iter().map(|x| *x as usize).collect();
	filter::criteria_computation(&update_type[..], &q, alpha, delta_t, &p, &pet, tau, &first_aprils_usize[..])
}

#[extendr]
fn criteria_vector_for_r(update_type: String, q: Vec<f64>, alphas: Vec<f64>, delta_t: f64, p: Vec<f64>, pet: Vec<f64>, taus: Vec<f64>, first_aprils: Vec<f64>) -> Vec<f64> {
  let first_aprils_usize: Vec<usize> = first_aprils.iter().map(|x| *x as usize).collect();
	filter::criteria_computation_vector(&update_type[..], &q, alphas, delta_t, &p, &pet, taus, &first_aprils_usize[..])
}

extendr_module! {
  mod baseflow;
  fn perform_filtering_for_r;
  fn bfi_for_r;
  fn criteria_for_r;
  fn criteria_vector_for_r;
}
