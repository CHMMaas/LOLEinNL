*------------------------------------------------------------------------------*
* This script selects patients with female breast cancer-----------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_FBRE
program prepare_FBRE
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep FBRE */					quietly keep if tumsoort==501300
								
/* only female breast cancer */ capture drop if gesl == 1

/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end