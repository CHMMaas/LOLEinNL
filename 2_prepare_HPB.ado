*------------------------------------------------------------------------------*
* This script selects patients with hepato-pancreato-biliary cancer------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_HPB
program prepare_HPB
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep HPB */					quietly keep if tumsoort==207310 | tumsoort==207320 | ///
								tumsoort==208310 | tumsoort==208320 | tumsoort==209310 | ///
								tumsoort==209320 | tumsoort==208330 | tumsoort==208340 | ///
								tumsoort==208350 | tumsoort==208360
	
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end