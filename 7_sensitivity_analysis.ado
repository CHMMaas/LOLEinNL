*------------------------------------------------------------------------------*
* This script performs sensitivity analysis for the degrees of freedom in the--*
* flexible parametric survival model-------------------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop sensitivity_analysis
program sensitivity_analysis
args baseline_min baseline_max ///
				spline_min spline_max ///
				TD_min TD_max ///
				df_spline_year df_spline_age ///
				df_baseline df_TD ///
				max_CBS_age max_fupdat bool_CI bool_stage ///
				strs_path results_data_path SA_path path_ado_files ///
				disease age1 age2 age3 age4 start_year end_year	
capture drop *

/* Estimate the loss in expectation of life */
quietly cd "`strs_path'"

/* Vary degrees of freedom of baseline hazard */
file open SA_`disease' using "`SA_path'\SA_`bool_stage'_`disease'.txt", write replace
local min_BIC = 1e+100
local chosen_df_baseline = 0
forval try_df_baseline = `baseline_min'/`baseline_max' {
    /* Load data */
	use "`results_data_path'\\`disease'_year`df_spline_year'_age`df_spline_age'_`bool_stage'.dta", clear
	if ("`bool_stage'" == "with_stage"){
		quietly keep if stage4 == 0
		quietly drop stage4
	}
	
	/* Train model */
	if (`df_TD' == 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`try_df_baseline') bhazard(rate) 
	}
	else if (`df_TD' == 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`try_df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`try_df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`try_df_baseline') bhazard(rate) tvc(syr* fem* sag* stage*) dftvc(`df_TD')
	}
	
	// continue if convergence not achieved
	if (_rc+(e(converge)==0) > 0){
	    continue
	}
	else{
		/* If BIC smaller, store as best model */
		estimates store baseline_`try_df_baseline'
		estat ic
		mat s=r(S)
		local new_BIC = (s[1,6])
		if (`new_BIC' < `min_BIC'){
			local min_BIC = `new_BIC'
			local chosen_df_baseline = `try_df_baseline'
		}
	}
}
file write SA_`disease' "df baseline: `chosen_df_baseline'" _n

/* Vary degrees of freedom of spline of age at diagnosis */
local min_BIC = 1e+100
local chosen_df_spline_age = 0
forval try_df_spline_age = `spline_min'/`spline_max' {
	/* Load data */
	use "`results_data_path'\\`disease'_year`df_spline_year'_age`try_df_spline_age'_`bool_stage'.dta", clear
	if ("`bool_stage'" == "with_stage"){
		keep if stage4 == 0
		drop stage4
	}
	
	/* Train model */
	if (`df_TD' == 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) 
	}
	else if (`df_TD' == 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag* stage*) dftvc(`df_TD')
	}
	
	// continue if convergence not achieved
	if (_rc+(e(converge)==0) > 0){
		continue
	}
	else{
		/* If BIC smaller, store as best model */
		estimates store spline_age_`try_df_spline_age'
		estat ic
		mat s=r(S)
		local new_BIC = (s[1,6])
		if (`new_BIC' < `min_BIC'){
			local min_BIC = `new_BIC'
			local chosen_df_spline_age = `try_df_spline_age'
		}
	}
}
file write SA_`disease' "df spline age: `chosen_df_spline_age'" _n

/* Vary degrees of freedom of spline of year at diagnosis */
local min_BIC = 1e+100
local chosen_df_spline_year = 0
forval try_df_spline_year = `spline_min'/`spline_max' {
	/* Load data */
	use "`results_data_path'\\`disease'_year`try_df_spline_year'_age`chosen_df_spline_age'_`bool_stage'.dta", clear
	if ("`bool_stage'" == "with_stage"){
		keep if stage4 == 0
		drop stage4
	}
	
	/* Train model */
	if (`df_TD' == 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) 
	}
	else if (`df_TD' == 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	else if (`df_TD' > 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag* stage*) dftvc(`df_TD')
	}
	
	// continue if convergence not achieved
	if (_rc+(e(converge)==0) > 0){
		continue
	}
	else{
		/* If BIC smaller, store as best model */
		estimates store spline_year_`try_df_spline_year'
		estat ic
		mat s=r(S)
		local new_BIC = (s[1,6])
		if (`new_BIC' < `min_BIC'){
			local min_BIC = `new_BIC'
			local chosen_df_spline_year = `try_df_spline_year'
		}
	}
}
file write SA_`disease' "df spline year: `chosen_df_spline_year'" _n

/* Vary degrees of freedom to model time-dependent effects */
local min_BIC = 1e+100
local chosen_df_TD = 0
forval try_df_TD = `TD_min'/`TD_max' {
	/* Load data */
	use "`results_data_path'\\`disease'_year`chosen_df_spline_year'_age`chosen_df_spline_age'_`bool_stage'.dta", clear
	if ("`bool_stage'" == "with_stage"){
		keep if stage4 == 0
		drop stage4
	}
	
	/* Train model */
	if (`try_df_TD' == 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) 
	}
	else if (`try_df_TD' == 0 & "`bool_stage'" == "with_stage"){
		capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate)
	}
	else if (`try_df_TD' > 0 & "`bool_stage'" == "without_stage"){
		capture noisily: quietly stpm2 syr* fem* sag*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`try_df_TD')
	}
	else if (`try_df_TD' > 0 & "`bool_stage'" == "with_stage"){
	    capture noisily: quietly stpm2 syr* fem* sag* stage*, scale(hazard) df(`chosen_df_baseline') bhazard(rate) tvc(syr* fem* sag* stage*) dftvc(`try_df_TD')
	}
	
	if (_rc+(e(converge)==0) > 0){
	    // continue if convergence not achieved
		continue
	}
	else{
		/* If BIC smaller, store as best model */
		estimates store df_TD_`try_df_TD'
		estat ic
		mat s=r(S)
		local new_BIC = (s[1,6])
		if (`new_BIC' < `min_BIC'){
			local min_BIC = `new_BIC'
			local chosen_df_TD = `try_df_TD'
		}
	}
}
file write SA_`disease' "df TD: `chosen_df_TD'" _n

file close SA_`disease'

end