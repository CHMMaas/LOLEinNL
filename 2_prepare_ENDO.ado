*------------------------------------------------------------------------------*
* This script selects patients with endometria cancer--------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_ENDO
program prepare_ENDO
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep ENDO */					quietly keep if tumsoort==604300
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end