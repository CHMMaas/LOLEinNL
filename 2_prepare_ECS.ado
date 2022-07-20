*------------------------------------------------------------------------------*
* This script selects patients with cancer in the esophagus, cardia or stomach-*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_ECS
program prepare_ECS
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep ECS */					quietly keep if tumsoort==201310 | ///
								tumsoort==201320 | tumsoort==202300 | tumsoort==203300
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end