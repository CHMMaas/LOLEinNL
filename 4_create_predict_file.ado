*------------------------------------------------------------------------------*
* Create file with artificial patients to estimate predictions for, each ------*
* combination once ------------------------------------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop create_predict_file
program create_predict_file 
args max_since_years bool_CI bool_stage spline_min spline_max strs_path results_data_path disease ///
		min_year max_year min_age max_age 
quietly capture drop *
display "Obtain patients to predict"

/* Compute data set with all combinations of 
  - gender (1, 2);
  - year of diagnosis (1989 - 2018);
  - age (50-90) */
quietly cd "`strs_path'"
quietly capture drop *
local r_age = `max_year' - `min_year' + 1
local r_gender = (`max_age' - `min_age' + 1)*`r_age'
if ("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | ///
	"`disease'" == "FBRE" | "`disease'" == "PROST" | "`disease'" == "TEST"){
	local N = `r_gender'
	quietly set obs `N'
	if ("`disease'" == "PROST" | "`disease'" == "TEST"){
		/* Males */
		quietly egen geslacht = seq(), f(1) t(1) b(`r_gender')
		lab def sexlbl 1 "Males", modify
	}
	else{
		/* Females */
		quietly egen geslacht = seq(), f(2) t(2) b(`r_gender')
		lab def sexlbl 2 "Females", modify
	}
}			
else{
	local N = `r_gender'*2
	quietly set obs `N'
	quietly egen geslacht = seq(), f(1) t(2) b(`r_gender')
	lab def sexlbl 1 "Males" 2 "Females", modify
}
lab val geslacht sexlbl
quietly egen age = seq(), f(`min_age') t(`max_age') b(`r_age')
quietly egen jaar = seq(), f(`min_year') t(`max_year')
quietly gen fem = geslacht==2

/* Compute splines of age and year */
quietly rcsgen age, df(`spline_max') gen(sag) orthog
quietly rcsgen jaar, df(`spline_max') gen(syr) orthog

/* Compute interactions */
forval i = 1/`spline_max'{
	/* interaction age and gender */
	quietly gen sag`i'fem = sag`i'*fem 
	forval j = 1/`spline_max'{
		/* only add interaction with gender once */
		if (`i' == 1){ 							
			/* interaction year and gender */
			quietly gen syr`j'fem = syr`j'*fem  
		}
		/* interaction year and age at diagnosis */
		quietly gen syr`j'sag`i' = syr`j'*sag`i' 
	}
}

/* set _t and _d to missing, 
	because the predict function needs .t and .d as input,
	but doesn't do anything with it */
quietly gen _d = .
quietly gen _t = . 

if ("`bool_CI'" == "yes"){
	local string_CI = "with_CI"
}
else if ("`bool_CI'" == "no"){
	local string_CI = "without_CI"
}

if ("`bool_stage'" == "without_stage"){
	/* save prediction file */
	quietly save "`results_data_path'\\`disease'_patients_to_predict_`bool_stage'.dta", replace
	if (`max_since_years' > 0){
		/* save file for multiple conditional LOLE */
		quietly save "`results_data_path'\results_`disease'_CLOLE_multiple_`string_CI'_`bool_stage'.dta", replace
	}
}
else if ("`bool_stage'" == "with_stage"){
	/* Add stage to model */
	quietly gen long order = _n 
	/* Options: Localized, Distant, Regional
	   - omit Unknown from results */
	quietly expand 3 
	quietly sort age order
	quietly drop order
	quietly egen stage = seq(), f(1) t(3)
	lab def stagelbl 1 "Localized" 2 "Regional" 3 "Distant", modify
	lab val stage stagelbl
	forval stage_val = 1/3{
		quietly gen stage`stage_val' = (stage==`stage_val')
	}
	quietly drop stage
	
	/* Interactions with stage */
	forval stage_val = 1/3{
		forval age_val = 1/`spline_max'{
			quietly gen stage`stage_val'sag`age_val' = stage`stage_val'*sag`age_val'
		}
		forval year_val = 1/`spline_max'{
			quietly gen stage`stage_val'syr`year_val' = stage`stage_val'*syr`year_val'
		}
		quietly gen stage`stage_val'fem = stage`stage_val'*fem
	}
	
	/* save prediction file */
	quietly save "`results_data_path'\\`disease'_patients_to_predict_`bool_stage'.dta", replace
	if (`max_since_years' > 0){
		/* save file for multiple conditional LOLE */
		quietly save "`results_data_path'\\results_`disease'_CLOLE_multiple_`string_CI'_`bool_stage'.dta", replace
	}
}

end
