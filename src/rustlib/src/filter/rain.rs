use rayon::prelude::*;

//Cumulated effective rainfall object

pub struct CumulativeEffectiveRainfall {
	pub tau: f64,
	pub p_eff_cumul: Vec<f64>
}

//Effective rainfall computation through Turc-Mesentsev formula
fn effective_rainfall(p: &[f64], pet: &[f64]) -> Vec<f64> {
	let p_eff: Vec<f64> = p.par_iter().zip(pet).map(|(pi, peti)| {
		match (*pi, *peti) {
			(a, b) if ((a <= 0.0) & (b <= 0.0)) => 0.0,
			(a, b) if ((a > 0.0) & (b <= 0.0)) => a,
			(a, b) if ((a <= 0.0) & (b > 0.0)) => 0.0,
			(a, b) if ((a > 0.0) & (b > 0.0)) => a * (1.0 - 1.0/(1.0 + a.powi(2) / b.powi(2)).sqrt()),
			(_, _) => 0.0
		}
	}).collect();
	p_eff
}

//Cumulative effective rainfall computation
fn cumulated_rainfall(p_eff: &[f64], tau: f64) -> Vec<f64> {
	let mut sortie: Vec<f64> = Vec::new();
	let mut p_sum: f64;
	//Computation of time series
	for i in 0..p_eff.len() {
		//First tau values are NAs, identified as negative values
		if (i as f64) < tau - 1.0 {
			sortie.push(-1.0);
		//Then values are cumultaed rainfall
		} else {
			p_sum = p_eff[(((i as f64) - tau + 1.0).floor() as usize)..i].iter().sum();
			sortie.push(p_sum);
		}
	}
	sortie
}

//Constructor
pub fn cumulative_effective_rainfall(p: &[f64], pet: &[f64], tau: f64) -> CumulativeEffectiveRainfall{
	let p_eff: Vec<f64> = effective_rainfall(p, pet);
	CumulativeEffectiveRainfall {
		tau,
		p_eff_cumul: cumulated_rainfall(&p_eff, tau)
	}
}
