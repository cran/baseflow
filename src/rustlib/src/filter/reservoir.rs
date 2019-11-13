// Usual update functions
fn linear_update(alpha: f64, beta: f64, q: f64, delta_t: f64) -> f64 {
	let x: f64 = -1.0 * alpha * delta_t;
	delta_t * q * (1.0 - beta + beta * x.exp()) / (1.0 - x.exp())
}

fn quadratic_update(alpha: f64, beta: f64, q: f64, delta_t: f64) -> f64 {
	let x: f64 = 1.0 + 4.0 * alpha /(q * delta_t);
	0.5 * q * delta_t * (x.sqrt() - 2.0 * beta + 1.0)
}

fn exp_update(alpha: f64, beta: f64, q: f64, delta_t: f64) -> f64 {
	let x: f64 = q * delta_t / alpha;
	let y: f64 = x.exp() - 1.0;
	-1.0 * beta * q * delta_t + alpha * y.ln()
}

//Usual recursion functions
fn linear_recursion(alpha: f64, beta: f64, v: f64, q: f64, delta_t: f64) -> f64 {
	let x: f64 = -1.0 * alpha * delta_t;
	(v + beta * delta_t * q)*x.exp()
}

fn quadratic_recursion(alpha: f64, beta: f64, v: f64, q: f64, delta_t: f64) -> f64 {
	(v + q * beta * delta_t) / (1.0 + (v + q * beta * delta_t)/alpha)
}

fn exp_recursion(alpha: f64, beta: f64, v: f64, q: f64, delta_t: f64) -> f64 {
	let x: f64 = -1.0 * (v + beta * q * delta_t) / alpha;
	let y: f64 = 1.0 + x.exp();
	-1.0 * alpha * y.ln()
}

//Wrapping String functions
pub fn update(update_type: &str, alpha: f64, beta: f64, q: f64, delta_t: f64) -> f64 {
	let update_function: &dyn Fn(f64, f64, f64, f64) -> f64 = match update_type {
		"lin" => &linear_update,
		"quadr" => &quadratic_update,
		"exp" => &exp_update,
		_ => panic!("Unknown reservoir function, please use one of the following : lin, quadr or exp.")
	};
	update_function(alpha, beta, q, delta_t)
}
pub fn recursion(update_type: &str, alpha: f64, beta: f64, v:f64, q: f64, delta_t: f64) -> f64 {
	let recursion_function = match update_type {
		"lin" => linear_recursion,
		"quadr" => quadratic_recursion,
		"exp" => exp_recursion,
		_ => panic!("Unknown reservoir function, please use one of the following : lin, quadr or exp.")
	};
	recursion_function(alpha, beta, v, q, delta_t)
}
