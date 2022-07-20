*------------------------------------------------------------------------------*
* This script selects patients with head or neck cancer------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_HN
program prepare_HN
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear

/* keep HN */					quietly keep if tumsoort==101300 | tumsoort==102310 | ///
								tumsoort==102320 | tumsoort==102330 | tumsoort==102340 | ///
								tumsoort==102350 | tumsoort==103310 | tumsoort==103320 | ///
								tumsoort==103330 | tumsoort==103340 | tumsoort==104310 | ///
								tumsoort==104320 | tumsoort==105310 | tumsoort==105320 | ///
								tumsoort==105340 | tumsoort==105350 | tumsoort==105360 | ///
								tumsoort==106310 | tumsoort==106320 | tumsoort==106330 | ///
								tumsoort==106340 | tumsoort==107310

/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end