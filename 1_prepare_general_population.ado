*------------------------------------------------------------------------------*
* Smooth life tables from CBS -------------------------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_general_population
program prepare_general_population
args smoothing_factor max_CBS_age strs_path
capture drop *

display "Prepare general population"

*--------------------------------------------*
*** Expected mortality of Dutch population *** 
*--------------------------------------------*
use "`strs_path'\nedmort.dta", clear

/* Keep only necessary variables */
keep _lft _jaar geslacht p

/* Specify mortality rate */
gen rate = -ln(p)
lab var rate "Mortality rate (rate=-ln(p))"

/* Smooth one-year survival probabilities */
if (`smoothing_factor' > 0) {	
	gen p_new = 0
	forval i=0/`max_CBS_age'{         // for all ages
		forval gender=1/2{ // for both genders
			/* perform LOWESS on survival probability and year of diagnosis */
			lowess p _jaar if _lft==`i' & geslacht==`gender', bwidth(`smoothing_factor') nograph generate(p_new_`i') 
			/* set missing values equal to 0 */
			quietly replace p_new_`i' = 0 if missing(p_new_`i')
			/* update p_new */
			quietly replace p_new = p_new + p_new_`i'
			quietly drop p_new_`i'
		}
	}
	quietly replace p = p_new
	drop p_new	
}

/* sort data set
	_lft 0 to 95
	_jaar 1950 to 2021 */
sort _jaar geslacht _lft

/* save in directory same as where strs is located! */
save "`strs_path'\nedmort - LOLE.dta", replace

end