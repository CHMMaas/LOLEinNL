*---------------------------------------------------------------------------------*
***** Analysis of Hematology Data in the NCR data for the period 1989 to 2018 ***** 
***** Prepare Hematology Data for the period 1989 to 2018 *************************
*---------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_patient_data
program prepare_patient_data
args data_path results_data_path min_year max_year max_fupdat min_age max_age disease
capture drop *
display "Select patient population"

/* A copy of the kern.dta set in G:\IKNL\Registratie en Onderzoek\onderzoeksbestanden\STATAData\RANK\Kern\kern.dta */
/* open kern dataset */			quietly use "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Data\kern1508.dta", clear
								display _N
								
/* rename year at diagnosis */	gen jaar = incjr
/* rename vitdat */				quietly rename vit_stat_dat fupdat
/* rename age */				gen lft = leeft
/* rename date to death */  	gen overl = (fupdat - incdat)/30.44
/* rename vital status */ 		gen dood = vit_stat	

								display "Select only at diagnosis"
/* Keep only at diagnosis */	keep if epis=="DIA"
								display _N

								display "Keep only invasive tumors"
/* Keep only invasive tumors */ keep if gedrag>=3 
								display _N
									
								display "Select first episode"
/* Keep only first episode */ 	quietly sort rn incdat
								quietly by rn: gen nr_episode = _n
								drop if nr_episode != 1
								display _N
							
								display "Select period"
/* select period */				keep if inrange(jaar,`min_year',`max_year')
/* fupdat */					quietly replace fupdat = d(31dec`max_fupdat') if (fupdat > d(31dec`max_fupdat'))
								display _N
								
								display "Drop minors"
/* drop below age 18 */			drop if lft < `min_age'
/* cluster age >90 */ 			quietly gen age = lft
								quietly replace age = `max_age' if lft > `max_age'
								display _N
								
/* overl = fdat - incdat*/		quietly replace overl=1/30.44 if overl==0	// set patients with zero follow-up time to one day in terms of months
								
								display "Drop gender == 3"
/* omit transgender etc. */		drop if gesl == 3
								display _N
								
/* label sex */					quietly rename gesl geslacht
								lab def sexlbl 1 "Males" 2 "Females", modify
								lab val geslacht sexlbl
								quietly gen patid = _n
								
/* label death */				lab def doodlbl 0 "Alive" 1 "Death", modify
								lab val dood doodlbl
								lab var dood "Vital status"
								
/* keep only necessary var */	keep jaar lft age geslacht stage grade overl dood patid rn incdat fupdat tumsoort
																
/* compress */					quietly compress

/* save hoogover */				quietly save "`data_path'\\patient_data.dta", replace

end