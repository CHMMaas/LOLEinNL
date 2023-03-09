*------------------------------------------------------------------------------*
* This script selects patients with cancer in the central nervous system-------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_CNS
program prepare_CNS
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep CNS */					quietly keep if tumsoort==961300 | tumsoort==961310 | ///
								tumsoort==962300 | tumsoort==962310 | tumsoort==964310 | ///
								tumsoort==964320 | tumsoort==964330 | tumsoort==966300 | ///
								tumsoort==966310 | ///
/* Hersenvliezen */				tumsoort==963310 | tumsoort==963320 | tumsoort==963330 ///
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end