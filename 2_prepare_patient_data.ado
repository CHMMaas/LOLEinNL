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
/* open kern dataset */			quietly use "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Data\kern0905.dta", clear

/* rename year at diagnosis */	gen jaar = incjr
/* rename vitdat */				quietly rename vit_stat_dat fupdat
/* rename age */				gen lft = leeft
/* rename date to death */  	gen overl = (fupdat - incdat)/30.44
/* rename vital status */ 		gen dood = vit_stat	
								
/* Keep only at episode */		quietly keep if epis=="DIA"
								
/* Keep only first episode */ 	quietly sort rn zid incdat
								quietly by rn: gen nr_episode = _n
								quietly drop if nr_episode != 1
							
/* drop double recods */		quietly by eid, sort: gen nvals = _n == 1
/* select first episode only */	quietly list rn if nvals==0
								quietly drop if nvals==0
								
/* check for duplicates */		quietly capture drop dubbel dup
								quietly sort rn
								quietly duplicates tag rn, gen(dubbel)
								quietly sort rn dubbel
								quietly by rn dubbel: gen dup = _n
								quietly drop if dubbel!=0 & dup!=1 
								quietly drop dubbel dup
							
/* select period */				quietly keep if inrange(jaar,`min_year',`max_year')
/* fupdat */					quietly replace fupdat = d(31dec`max_fupdat') if (fupdat > d(31dec`max_fupdat'))
								
/* drop below age 18 */			quietly drop if lft < `min_age'
/* cluster age >90 */ 			quietly gen age = lft
								quietly replace age = `max_age' if lft > `max_age'
								
/* overl = fdat - incdat*/		quietly replace overl=1/30.44 if overl==0	// set patients with zero follow-up time to one day in terms of months
								
/* omit transgender etc. */		capture drop if gesl == 3
/* sex */						quietly rename gesl geslacht
								lab def sexlbl 1 "Males" 2 "Females", modify
								lab val geslacht sexlbl
								quietly gen patid = _n
								
/* death */						lab def doodlbl 0 "Alive" 1 "Death", modify
								lab val dood doodlbl
								lab var dood "Vital status"

/* keep only necessary var */	keep jaar lft age geslacht stage grade overl dood patid rn incdat fupdat tumsoort
					
/* compress */					quietly compress

								tab geslacht

/* save hoogover */				quietly save "`data_path'\\patient_data.dta", replace

end