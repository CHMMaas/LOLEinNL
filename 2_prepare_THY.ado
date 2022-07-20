*------------------------------------------------------------------------------*
* This script selects patients with thyroid cancer-----------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_THY
program prepare_THY
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep THY */					quietly keep if tumsoort==901310 | tumsoort==901320 | ///
								tumsoort==901330 | tumsoort==901340 | tumsoort==901350
	
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end