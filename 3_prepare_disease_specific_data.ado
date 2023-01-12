*------------------------------------------------------------------------------*
* This script selects variables, sets data to survival data, computs ----------*
* interaction terms -----------------------------------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm
* install restricted cubic splines if necessary
// ssc install rcsgen, all replace   

capture program drop prepare_disease_specific_data
program prepare_disease_specific_data
args bool_stage max_CBS_age strs_path results_data_path spline_min spline_max ///
		time_of_cure disease
capture drop *

display "Set survival data"
quietly use "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", clear

/* keep vars for analyses */	if ("`disease'" == "CNS"){
									/* For CNS, don't use stage, but degree 
										reference category is degree 1 and 2, 
										so stage1 not created */
									quietly gen stage2 = grade=="Graad 3" 
									quietly gen stage3 = grade=="Graad 4"
									quietly gen stage4 = grade=="Onbekend"
								}
								else{
									/* Ref category is Localized, 
										so stage1 not created */
									quietly gen stage2 = stage==1 
									quietly gen stage3 = stage==2
									quietly gen stage4 = stage==9
								}
/* change unknown bladder 
to localized */					if ("`disease'" == "BLAD"){
									replace stage = 0 if (tumsoort==713310 & stage==9) 
								}
/* Unknown is localized 
(stage 1) for SCC */ 			if ("`disease'" == "ALL" | "`disease'" == "SCC"){
									replace stage4 = 0 if ((tumsoort==403310 | tumsoort==403330 | tumsoort==403320) & stage==9)
								}
								
/* keep some variables */ 		quietly keep rn patid lft geslacht jaar age ///
										incdat fupdat overl dood ///
										stage2 stage3 stage4 tumsoort

/* compress */					quietly compress
								quietly save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
									
*--------------------------*
*** Set-up survival data *** 
*--------------------------*
forval df_spline_year = `spline_min'/`spline_max' {
    forval df_spline_age = `spline_min'/`spline_max' {
		quietly use "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", clear

		/* Declare data to be survival-time data with stset
		id() 						  multiple-record ID variable
		scale(#)                      rescale time value
		exit(time exp)                specify when subject exits study

		For conditional survival:
		origin(time exp)              define when a subject becomes at risk
		enter(time exp)               specify when subject first enters study
		
		e.g. The exit(time 12*10) option creates a maximum follow-up time of 10 years (120 months). 

		stset creates 1. _st (1 if record to be used)  -> only 1's 
				   2. _d (1 if failure; 0 if censored)
				   3. _t (time)
				   4. _t0 (time when record begins) -> only 0's */
		quietly cd "`strs_path'"
		
		/* Cohort approach */
		quietly stset overl dood, id(patid) scale(12) exit(time `time_of_cure'*12) // TODO: check what happens if dood omitted
		
		/* spline variables for age */				
		quietly rcsgen age, df(`df_spline_age') gen(sag) orthog
		/* spline variables for year */				
		quietly rcsgen jaar, df(`df_spline_year') gen(syr) orthog
		/* create dummy variable for sex */			
		gen fem = geslacht==2 

		/* Add information of population to current data set
			use original age variable to merge with population file */
		gen _lft = min(int(lft + _t), `max_CBS_age') 
		gen _jaar = int(jaar + _t)
		sort _jaar geslacht _lft

		/* merge data sets using year, gender, age
		m:1        	many-to-one merge on specified key variables
		keep: 		specify which match results to keep 
		keepusing:  variables to keep from using data; default is all 
		This adds the mortality rate (-ln(p)) to the data set */
		quietly merge m:1 _jaar geslacht _lft using "nedmort - LOLE", keep(match master) keepusing(rate)
		quietly drop _lft _jaar _merge

		/* Compute interactions */
		forval i = 1/`df_spline_age'{
			/* interaction age and gender */
			quietly gen sag`i'fem = sag`i'*fem
			forval j = 1/`df_spline_year'{
				/* only add interaction with gender once */
				if (`i' == 1){ 							
					/* interaction year and gender */
					quietly gen syr`j'fem = syr`j'*fem
				}
				/* interaction year and age at diagnosis */
				quietly gen syr`j'sag`i' = syr`j'*sag`i' 
			}
		}
		
		if ("`bool_stage'" == "with_stage"){
			/* Interactions with stage
				Ref category is Localized */
			forval stage_val = 2/3 { 
				forval age_val = 1/`df_spline_age'{
					quietly gen stage`stage_val'sag`age_val' = stage`stage_val'*sag`age_val'
				}
				forval year_val = 1/`df_spline_year'{
					quietly gen stage`stage_val'syr`year_val' = stage`stage_val'*syr`year_val'
				}
			}
		}
		
		/* Save file with `df_spline_year', `df_spline_age' degrees of freedom, 
		and whether or not to include stage in model (`bool_stage') */
		quietly save "`results_data_path'\\`disease'_year`df_spline_year'_age`df_spline_age'_`bool_stage'.dta", replace
	}
}

end