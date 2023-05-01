capture drop *
capture program drop *

cd #

local strs_path = #
local results_data_path = #
local combined_figure_path = #
local max_fupdat = 2021
local max_CBS_age = 95
local min_age = 18
local tinf_val = 100 - `min_age'
local bool_stage = "without_stage"

// local diseases " "ALL" "
local diseases " "BLAD" "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "PROST" "SCC" "TEST" "THY" "ALL" "
capture file close CancerDeaths
file open CancerDeaths using "#\Cancer_Deaths.txt", write replace
file write CancerDeaths "Disease" _tab "jaar" _tab "nr_of_deaths" _n
foreach disease in `diseases'{	
	/* load data */ 
	quietly use #, clear
	
 	/* Keep only at diagnosis */	keep if epis=="DIA"
									
 	/* Keep only invasive tumors */ keep if gedrag>=3 
									
 	/* Keep only first episode */ 	quietly sort rn incdat
 									quietly by rn: gen nr_episode = _n
 									drop if nr_episode != 1
									
 	/* drop below age 18 */			drop if leeft < 18
									
 	if ("`disease'" == "ALL"){
 	/* BLAD */		keep if tumsoort==712310 | tumsoort==712320 | tumsoort==713310 | ///
 					tumsoort==713330 | tumsoort==713340 | ///
 					tumsoort==719310 | tumsoort==719330 | /// 
 	/* CERV */		(tumsoort==603300 & gesl == 2) | ///
 	/* CNS */		tumsoort==961300 | tumsoort==961310 | ///
 					tumsoort==962300 | tumsoort==962310 | tumsoort==963310 | ///
 					tumsoort==963320 | tumsoort==963330 | tumsoort==964310 | ///
 					tumsoort==964320 | tumsoort==964330 | tumsoort==966300 | ///
 					tumsoort==966310 | ///
 	/* CRC */		tumsoort==205310 | tumsoort==205320 | ///
 					tumsoort==205330 | tumsoort==205340 | ///
 	/* ECS */		tumsoort==201310 | ///
 					tumsoort==201320 | tumsoort==202300 | tumsoort==203300 | ///
 	/* ENDO */		(tumsoort==604300 & gesl == 2) | ///
 	/* FBRE */		(tumsoort==501300 & gesl == 2) | /// 
	/* HN */ 		tumsoort==101300 | tumsoort==102310 | ///
 					tumsoort==102320 | tumsoort==102330 | tumsoort==102340 | ///
 					tumsoort==102350 | tumsoort==103310 | tumsoort==103320 | ///
 					tumsoort==103330 | tumsoort==103340 | tumsoort==104310 | ///
 					tumsoort==104320 | tumsoort==105310 | tumsoort==105320 | ///
 					tumsoort==105340 | tumsoort==105350 | tumsoort==105360 | ///
 					tumsoort==106310 | tumsoort==106320 | tumsoort==106330 | ///
 					tumsoort==106340 | tumsoort==107310 | ///
 	/* HPB */ 		tumsoort==207310 | tumsoort==207320 | ///
 					tumsoort==208310 | tumsoort==208320 | tumsoort==209310 | ///
 					tumsoort==209320 | tumsoort==208330 | tumsoort==208340 | ///
 					tumsoort==208350 | tumsoort==208360 | ///
 	/* KIDN */ 		tumsoort==711310 | ///
 	/* LUNG */		tumsoort==302310 | tumsoort==302320 | ///
 					tumsoort==302330 | tumsoort==302340 | tumsoort==302350 | ///
 	/* MEL */		tumsoort==441310 | tumsoort==441320 | ///
 					tumsoort==441330 | tumsoort==441340 | tumsoort==441350 | ///
 	/* OFT */		((tumsoort==606310 | tumsoort==606320 | tumsoort==606340) & gesl == 2) | ///
 	/* PROST */		(tumsoort==702300 & gesl == 1) | ///
 	/* SCC */ 		tumsoort==403310 | tumsoort==403330 | tumsoort==403320 | ///
 	/* TEST */		((tumsoort==703310 | tumsoort==703320) & gesl == 1) | ///
 	/* THY */		tumsoort==901310 | tumsoort==901320 | ///
 					tumsoort==901330 | tumsoort==901340 | tumsoort==901350				
 	}
 	else if ("`disease'" == "BLAD"){
 	/* BLAD */		keep if tumsoort==712310 | tumsoort==712320 | tumsoort==713310 | ///
 					tumsoort==713330 | tumsoort==713340 | ///
 					tumsoort==719310 | tumsoort==719330
 	} 
 	else if ("`disease'" == "CERV"){
 	/* CERV */		keep if (tumsoort==603300 & gesl == 2)
 	}
 	else if ("`disease'" == "CNS"){
 	/* CNS */		keep if tumsoort==961300 | tumsoort==961310 | ///
 					tumsoort==962300 | tumsoort==962310 | tumsoort==963310 | ///
 					tumsoort==963320 | tumsoort==963330 | tumsoort==964310 | ///
 					tumsoort==964320 | tumsoort==964330 | tumsoort==966300 | ///
 					tumsoort==966310
 	}
 	else if ("`disease'" == "CRC"){
 	/* CRC */		keep if tumsoort==205310 | tumsoort==205320 | ///
 					tumsoort==205330 | tumsoort==205340
 	}
 	else if ("`disease'" == "ECS"){
 	/* ECS */		keep if tumsoort==201310 | ///
 					tumsoort==201320 | tumsoort==202300 | tumsoort==203300
 	}
 	else if ("`disease'" == "ENDO"){
 	/* ENDO */		keep if (tumsoort==604300 & gesl == 2)
 	}
 	else if ("`disease'" == "FBRE"){
 	/* FBRE */		keep if (tumsoort==501300 & gesl == 2)
 	}
 	else if ("`disease'" == "HN"){
 	/* HN */ 		keep if tumsoort==101300 | tumsoort==102310 | ///
 					tumsoort==102320 | tumsoort==102330 | tumsoort==102340 | ///
 					tumsoort==102350 | tumsoort==103310 | tumsoort==103320 | ///
 					tumsoort==103330 | tumsoort==103340 | tumsoort==104310 | ///
 					tumsoort==104320 | tumsoort==105310 | tumsoort==105320 | ///
 					tumsoort==105340 | tumsoort==105350 | tumsoort==105360 | ///
 					tumsoort==106310 | tumsoort==106320 | tumsoort==106330 | ///
 					tumsoort==106340 | tumsoort==107310
 	}
 	else if ("`disease'" == "HPB"){
 	/* HPB */ 		keep if tumsoort==207310 | tumsoort==207320 | ///
 					tumsoort==208310 | tumsoort==208320 | tumsoort==209310 | ///
 					tumsoort==209320 | tumsoort==208330 | tumsoort==208340 | ///
 					tumsoort==208350 | tumsoort==208360
 	}
 	else if ("`disease'" == "KIDN"){
 	/* KIDN */ 		keep if tumsoort==711310
 	}
 	else if ("`disease'" == "LUNG"){
 	/* LUNG */		keep if tumsoort==302310 | tumsoort==302320 | ///
 					tumsoort==302330 | tumsoort==302340 | tumsoort==302350
 	}
 	else if ("`disease'" == "MEL"){
 	/* MEL */		keep if tumsoort==441310 | tumsoort==441320 | ///
 					tumsoort==441330 | tumsoort==441340 | tumsoort==441350
 	}
 	else if ("`disease'" == "OFT"){
 	/* OFT */		keep if ((tumsoort==606310 | tumsoort==606320 | tumsoort==606340) & gesl == 2)
 	}
 	else if ("`disease'" == "PROST"){
 	/* PROST */		keep if (tumsoort==702300 & gesl == 1)
 	}
 	else if ("`disease'" == "SCC"){
 	/* SCC */ 		keep if tumsoort==403310 | tumsoort==403330 | tumsoort==403320
 	}
 	else if ("`disease'" == "TEST"){
	/* TEST */		keep if ((tumsoort==703310 | tumsoort==703320) & gesl == 1)
 	}
 	else if ("`disease'" == "THY"){
 	/* THY */		keep if tumsoort==901310 | tumsoort==901320 | ///
 					tumsoort==901330 | tumsoort==901340 | tumsoort==901350				
 	}
	
 	/* year of death */				
 	gen ovlyear=year(ovldat)
 	save "#\temp.dta", replace

 	forval year_val = 1989/2019 {
 		use "#\temp.dta", clear
 		/* Keep only one year */
 		keep if ovlyear==`year_val'
		
 		/* Count number of deaths in that year */
 		local nr_cancer_deaths = _N
		
 		/* Write to file */
 		file write CancerDeaths "`disease'" _tab "`year_val'" _tab "`nr_cancer_deaths'" _n
 		if (`year_val'==2019){
 			file write CancerDeaths "`disease'" _tab "2020" _tab "`nr_cancer_deaths'" _n
 			file write CancerDeaths "`disease'" _tab "2021" _tab "`nr_cancer_deaths'" _n
 		}
 	}
}
file close CancerDeaths
insheet using "#\Cancer_Deaths.txt", clear
save "#\Cancer_Deaths.dta", replace

// Load information on number of inhabitants in the Netherlands per year
insheet using "#\Bevolkingsteller_NL.csv", delimiter(;) clear
destring bevolking, replace dpcomma
replace bevolking = bevolking*1000000
save "#\Bevolkingsteller_NL.dta", replace

local diseases " "BLAD" "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "PROST" "SCC" "TEST" "THY" "ALL" "

foreach disease in `diseases'{
	if ("`bool_stage'" == "without_stage"){
		if ("`disease'" == "ALL"){
			local df_baseline = 10
			local df_spline_age = 3
			local df_spline_year = 3
			local df_TD = 2
		}
		else if ("`disease'" == "BLAD"){
			local df_baseline = 4
			local df_spline_age = 2
			local df_spline_year = 1
			local df_TD = 1
		}
		else if ("`disease'" == "CERV"){
			local df_baseline = 3
			local df_spline_age = 1
			local df_spline_year = 1
			local df_TD = 0
		}
		else if ("`disease'" == "CNS"){
			local df_baseline = 8
			local df_spline_age = 3
			local df_spline_year = 3
			local df_TD = 2
		}
		else if ("`disease'" == "CRC"){
			local df_baseline = 6
			local df_spline_age = 3
			local df_spline_year = 2
			local df_TD = 0
		}
		else if ("`disease'" == "ECS"){
			local df_baseline = 8
			local df_spline_age = 3
			local df_spline_year = 3
			local df_TD = 1
		}
		else if ("`disease'" == "ENDO"){
			local df_baseline = 3
			local df_spline_age = 2
			local df_spline_year = 1
			local df_TD = 0
		}
		else if ("`disease'" == "FBRE"){
			local df_baseline = 10
			local df_spline_age = 3
			local df_spline_year = 2
			local df_TD = 0
		}
		else if ("`disease'" == "HN"){
			local df_baseline = 5
			local df_spline_age = 3
			local df_spline_year = 2
			local df_TD = 1
		}
		else if ("`disease'" == "HPB"){
			local df_baseline = 9
			local df_spline_age = 3
			local df_spline_year = 3
			local df_TD = 2
		}
		else if ("`disease'" == "KIDN"){
			local df_baseline = 4
			local df_spline_age = 1
			local df_spline_year = 3
			local df_TD = 2
		}
		else if ("`disease'" == "LUNG"){
			local df_baseline = 9
			local df_spline_age = 3
			local df_spline_year = 2
			local df_TD = 1
		}
		else if ("`disease'" == "MEL"){
			local df_baseline = 3
			local df_spline_age = 2
			local df_spline_year = 2
			local df_TD = 0
		}
		else if ("`disease'" == "OFT"){
			local df_baseline = 6
			local df_spline_age = 3
			local df_spline_year = 1
			local df_TD = 0
		}
		else if ("`disease'" == "PROST"){
			local df_baseline = 10
			local df_spline_age = 2
			local df_spline_year = 2
			local df_TD = 1
		}
		else if ("`disease'" == "SCC"){
			local df_baseline = 2
			local df_spline_age = 2
			local df_spline_year = 2
			local df_TD = 0
		}
		else if ("`disease'" == "TEST"){
			local df_baseline = 2
			local df_spline_age = 2
			local df_spline_year = 1
			local df_TD = 0
		}
		else if ("`disease'" == "THY"){
			local df_baseline = 3
			local df_spline_age = 1
			local df_spline_year = 1
			local df_TD = 0
		}
	}	

	/* Calculate LE and LOLE with life expectancy of general population 
	   excluding cancer deaths */
	use "`results_data_path'\\`disease'\\`disease'_year`df_spline_year'_age`df_spline_age'_`bool_stage'.dta", clear
	if (`df_TD' == 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	use "`results_data_path'\\`disease'\\`disease'_patients_to_predict_`bool_stage'.dta", clear
	predict LOLE_unadjusted, lifelost mergeby(_jaar geslacht _lft) attage(_lft) attyear(_jaar) diagage(age) diagyear(jaar) nodes(40) tinf(`tinf_val') ///
			using(nedmort - LOLE) stub(surv) survprob(p) maxage(`max_CBS_age') maxyear(`max_fupdat') tcond(0)
	capture file close LOLEunadjusted
	file open LOLEunadjusted using "#\LOLE_`disease'_unadjusted.txt", write replace
	file write LOLEunadjusted "Disease" _tab "Gender" _tab "Year" _tab "Age" _tab "LE_unadjusted" _tab "LOLE_unadjusted" _n
	foreach gender_val in 1 2 {
		foreach year_val in 2000 2010 2019 {
			foreach age_val in 45 65 75 {
				// Life expectancy general population
				summarize survexp if (jaar==`year_val' & age==`age_val' & geslacht==`gender_val')
				local LE_unadjusted_val = (r(mean))
				summarize LOLE_unadjusted if (jaar==`year_val' & age==`age_val' & geslacht==`gender_val')
				local LOLE_unadjusted_val = (r(mean))
				file write LOLEunadjusted "`disease'" _tab "`gender_val'" _tab "`year_val'" _tab "`age_val'" _tab "`LE_unadjusted_val'" _tab "`LOLE_unadjusted_val'" _n
			}
		}
	}
	file close LOLEunadjusted

	/* Calculate LE and LOLE with life expectancy of general population 
	   excluding cancer deaths */
	// Add correction factor to nedmort
	// Calculate correction factor
	cd #
	// Load information on cancer deaths per year
	use "Cancer_Deaths", clear
	keep if disease=="`disease'"
	// Merge with number of inhabitants per year
	quietly merge m:1 jaar using "Bevolkingsteller_NL", keep(match master)
	quietly drop _merge	
	// alpha denotes the proportion of deaths in the external group due to the cancer of interest
	gen alpha = nr_of_deaths/bevolking*100
	quietly drop nr_of_deaths bevolking
	rename jaar _jaar
	save "#\Alpha.dta", replace

	cd "`strs_path'"
	quietly merge m:m _jaar using "nedmort", keep(match master)
	quietly drop _merge	

	/* Keep only necessary variables */
	keep geslacht _lft _jaar p alpha

	/* Specify mortality rate */
	gen rate = -ln(p)
	lab var rate "Mortality rate (rate=-ln(p))"

	/* Adjust for cancer deaths */
	replace p = p + alpha*(1-p)
	drop alpha
	
	/* sort data set
		_lft 0 to 95
		_jaar 1950 to 2021 */
	sort _jaar geslacht _lft
	 
	/* save in directory same as where strs is located! */
	save "`strs_path'\nedmort - LOLE - adjusted.dta", replace
	
	// Fit model
	use "`results_data_path'\\`disease'\\`disease'_year`df_spline_year'_age`df_spline_age'_`bool_stage'.dta", clear
	if (`df_TD' == 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	use "`results_data_path'\\`disease'\\`disease'_patients_to_predict_`bool_stage'.dta", clear
	predict LOLE_adjusted, lifelost mergeby(_jaar geslacht _lft) attage(_lft) attyear(_jaar) diagage(age) diagyear(jaar) nodes(40) tinf(`tinf_val') ///
			using(nedmort - LOLE - adjusted) stub(surv) survprob(p) maxage(`max_CBS_age') maxyear(`max_fupdat') tcond(0)
	capture file close LOLEadjusted
	file open LOLEadjusted using "#\LOLE_`disease'_adjusted.txt", write replace
	file write LOLEadjusted "Disease" _tab "Gender" _tab "Year" _tab "Age" _tab "LE_adjusted" _tab "LOLE_adjusted" _n
	foreach gender_val in 1 2 {
		foreach year_val in 2000 2010 2019 {
			foreach age_val in 45 65 75 {
				// Life expectancy of general population
				summarize survexp if (jaar==`year_val' & age==`age_val' & geslacht==`gender_val')
				local LE_adjusted_val = (r(mean))
				summarize LOLE_adjusted if (jaar==`year_val' & age==`age_val' & geslacht==`gender_val')
				local LOLE_adjusted_val = (r(mean))
				file write LOLEadjusted "`disease'" _tab "`gender_val'" _tab "`year_val'" _tab "`age_val'" _tab "`LE_adjusted_val'" _tab "`LOLE_adjusted_val'" _n
			}
		}
	}
	file close LOLEadjusted
}
