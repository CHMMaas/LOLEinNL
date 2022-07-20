*------------------------------------------------------------------------------*
* This script selects patients with kidney cancer------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_KIDN
program prepare_KIDN
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep KIDN */					quietly keep if tumsoort==711310
									
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end