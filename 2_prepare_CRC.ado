*------------------------------------------------------------------------------*
* This script selects patients with colorectum cancer--------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal poCRC is a comma
set dp comma, perm

capture program drop prepare_CRC
program prepare_CRC
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep PCC */					quietly keep if tumsoort==205310 | tumsoort==205320 | ///
								tumsoort==205330 | tumsoort==205340
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end