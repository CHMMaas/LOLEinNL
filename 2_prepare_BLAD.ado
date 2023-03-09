*------------------------------------------------------------------------------*
* This script selects patients with bladder cancer-----------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_BLAD
program prepare_BLAD
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep BLAD */					quietly keep if tumsoort==712310 | tumsoort==712320 | tumsoort==713310 | ///
								tumsoort==713330 | tumsoort==713340 | ///
								tumsoort==719310 | tumsoort==719330
																	
								display _N
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end