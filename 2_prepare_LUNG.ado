*------------------------------------------------------------------------------*
* This script selects patients with lung cnacer--------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_LUNG
program prepare_LUNG
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep LUNG */					quietly keep if tumsoort==302310 | tumsoort==302320 | ///
								tumsoort==302330 | tumsoort==302340 | tumsoort==302350
									
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end