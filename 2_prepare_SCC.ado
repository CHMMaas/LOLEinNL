*------------------------------------------------------------------------------*
* This script selects patients with squamous cell carcinoma--------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_SCC
program prepare_SCC
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */		use "`data_path'\\patient_data.dta", clear

/* keep SCC */						quietly keep if tumsoort==403310 | tumsoort==403330 | tumsoort==403320
								
									save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end