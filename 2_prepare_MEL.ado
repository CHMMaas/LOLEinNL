*------------------------------------------------------------------------------*
* This script selects patients with skin melanoma------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_MEL
program prepare_MEL
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep MEL */					quietly keep if tumsoort==441310 | tumsoort==441320 | ///
								tumsoort==441330 | tumsoort==441340 | tumsoort==441350
									
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end