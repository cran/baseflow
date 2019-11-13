mod reservoir;
mod rain;

use rayon::prelude::*;
use std::f64;
use roots::SimpleConvergency;
use roots::find_root_brent;

pub struct FilteringResult {
	alpha: f64,
	beta: f64,
	q: Vec<f64>,
	r: Vec<f64>,
	v: Vec<f64>,
	ups: Vec<bool>
}

impl FilteringResult {
	pub fn to_vec_for_r(&self) -> Vec<f64> {
		let mut result: Vec<f64> = self.r.clone();
		let mut truncated_v: Vec<f64> = self.v.clone();
		truncated_v.resize(self.r.len(), 0.0);
		
		let mut ups_float: Vec<f64> = Vec::new();
		
		for up in self.ups.iter() {
			ups_float.push((*up as i64) as f64);
		}
		result.append(&mut truncated_v);
		result.append(&mut ups_float);
		result
	}
	
	pub fn bfi(&self) -> f64 {
		self.r.iter().sum::<f64>() / self.q.iter().sum::<f64>()
	}
	
	pub fn criteria(&self, cer: &rain::CumulativeEffectiveRainfall) -> f64 {
		let p_cumul: &Vec<f64> = &cer.p_eff_cumul;
		let tau: f64 = cer.tau;
		let r: &Vec<f64> = &self.r;
		let mut cor: f64;
		let n: f64 = r.len() as f64;
		//Statistics computation
		let m_p_cumul: f64 = p_cumul[((tau - 1.0) as usize)..].iter().sum::<f64>() / (n - tau + 1.0);
		let m_r: f64 = r.iter().cloned().sum::<f64>() / (r.len() as f64);
		let mut p_cumul_scale: Vec<f64> = p_cumul[((tau as usize) - 1)..].iter().map(|pi| pi - m_p_cumul).collect();
		let mut r_scale: Vec<f64> = r[((tau as usize) - 1)..].iter().map(|ri| ri - m_r).collect();
		let sigma_p_cumul: f64 = p_cumul_scale.iter().map(|x| x.powi(2)/(n - tau + 1.0)).sum::<f64>().sqrt();
		let sigma_r: f64 = r_scale.iter().map(|x| x.powi(2)/(n - tau + 1.0)).sum::<f64>().sqrt();
		p_cumul_scale = p_cumul_scale.iter().map(|x| x/sigma_p_cumul).collect();
		r_scale = r_scale.iter().map(|x| x/sigma_r).collect();
		
		//Correlation computation through loop
		cor = r_scale.iter().zip(p_cumul_scale.iter()).map(|(ri, pi)| pi*ri).sum();
//		for i in ((tau as usize) - 1)..r.len() {
//			cor += (p_cumul[i] - m_p_cumul) * (r[i] - m_r);
//		}
		cor /= n - tau + 1.0;
		cor
	}
	

}

//Basic filtering function, designed for perform() method in R
pub fn perform_filtering_beta(update_type: &str, q_obs: &[f64], alpha: f64, beta: f64, delta_t: f64, first_aprils: &[usize]) -> FilteringResult {
	//Variable definition
	let mut r: Vec<f64> = Vec::new();
	let mut v: Vec<f64> = Vec::new();
	let mut ups: Vec<bool> = Vec::new();
	let n: usize = q_obs.len();
	let mut qi: f64;
	let mut vi: f64;
	let update_mins: Vec<usize> = yearly_mins(q_obs, first_aprils);
	
	//Inizialisation of reservoir's level vector
	let q_init: f64 = q_obs[0..4].iter().sum::<f64>()/5.0;
	let v_init: f64 = match reservoir::update(update_type, alpha, beta, q_init, delta_t) {
		x if x > 0.0 => x,
		_ => 0.0
	};
	v.push(v_init);
	//V.push(0.0);
	
	//Recursion loop
	for i in 0..n {
		ups.push(false);
		qi = match q_obs[i] {
			x if x > 0.0 => x,
			_ => 0.0001
		};
		vi = v[i];
		v.push(reservoir::recursion(update_type, alpha, beta, vi, qi, delta_t));
		r.push((-v[i+1] + v[i]) / delta_t + beta * qi);
		
		//Update part
		if (r[i] > qi) || (update_mins.iter().any(|&x| x == i)) {
			r[i] = qi;
			ups[i] = true;
			v[i] = reservoir::update(update_type, alpha, beta, qi, delta_t);
			v[i+1] = v[i] - qi * delta_t * (1.0 - beta);
		}
	}
	
	FilteringResult {
		alpha,
		beta,
		q: q_obs.to_vec(),
		r,
		v,
		ups
	}
}

//Perform filtering function without beta
pub fn perform_filtering(update_type: &str, q_obs: &[f64], alpha: f64, delta_t: f64, first_aprils: &[usize]) -> FilteringResult {
	let beta: f64 = beta_finder(update_type, q_obs, alpha, delta_t, first_aprils);
	perform_filtering_beta(update_type, q_obs, alpha, beta, delta_t, first_aprils)
}

//Yearly minimum finding, test for r export
pub fn yearly_mins(q: &[f64], first_aprils: &[usize]) -> Vec<usize> {
	let n: usize = q.len();
	let n_years: usize = first_aprils.len();
	let mut mins: Vec<usize> = Vec::new();
	let mut min: f64;
	if n_years == 0 {
		min = q.iter().fold(f64::INFINITY, |a, &b| a.min(b));
		mins.push(match q.iter().position(|x| x == &min) {
			Some(i) => i,
			_ => 0
		});
	} else {
		for i in 0..(n_years-1) {
			min = q[first_aprils[i]..(first_aprils[i+1] - 1)].iter().fold(f64::INFINITY, |a, &b| a.min(b));
			mins.push(match q[first_aprils[i]..(first_aprils[i+1] - 1)].iter().position(|x| x == &min) {
			Some(i) => i,
			_ => 0
			} + first_aprils[i]);
		}
	}
	mins
}

//Criteria computation
pub fn criteria_computation(update_type: &str, q: &[f64], alpha: f64, delta_t: f64, p: &[f64], pet: &[f64], tau: f64, first_aprils: &[usize]) -> f64 {
	let filtering: FilteringResult = perform_filtering(update_type, q, alpha, delta_t, first_aprils);
	let cer: rain::CumulativeEffectiveRainfall = rain::cumulative_effective_rainfall(p, pet, tau);
	filtering.criteria(&cer)
}

//Vectorized criteria computation
pub fn criteria_computation_vector(update_type: &str, q: &[f64], alphas: Vec<f64>, delta_t: f64, p: &[f64], pet: &[f64], taus: Vec<f64>, first_aprils: &[usize]) -> Vec<f64> {
	let mut criterias: Vec<f64>;
	let mut filtering_results: Vec<FilteringResult>;
	let mut cers: Vec<rain::CumulativeEffectiveRainfall>;
	
	cers = taus.par_iter().map(|tau| rain::cumulative_effective_rainfall(p, pet, *tau)).collect();

	filtering_results = alphas.par_iter().map(|alpha| perform_filtering(update_type, q, *alpha, delta_t, first_aprils)).collect();

	let mut combination: Vec<(&rain::CumulativeEffectiveRainfall, &FilteringResult)> = Vec::new();
	for cer in cers.iter() {
		for fr in filtering_results.iter() {
			combination.push((&cer, &fr));
		}
	}

	criterias = combination.par_iter().map(|(cer, fr)| fr.criteria(cer)).collect();

	criterias
}

//Beta finder
pub fn beta_finder(update_type: &str, q: &[f64], alpha: f64, delta_t: f64, first_aprils: &[usize]) -> f64 {
	let ym: Vec<usize> = yearly_mins(q, first_aprils);
	let f = |b| {perform_filtering_beta(update_type, q, alpha, b, delta_t, first_aprils).bfi() - b};
	let mut convergency = SimpleConvergency {eps: 0.001, max_iter: 1000};
	
	let beta: f64 = match find_root_brent(0.005, 0.995, &f, &mut convergency) {
		Ok(x) => x as f64,
		_ => 0.5
	};
	
	beta
}
