capture drop *
capture program drop *

cd "G:\IKNL\Registratie en Onderzoek\stata\strs"

local results_data_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\\`disease'"
local combined_figure_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Results\Review"
local max_fupdat = 2021
local max_CBS_age = 95
local min_age = 18
local tinf_val = 100 - `min_age'
local bool_stage = "without_stage"

// local diseases " "CNS" "
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
	
	// Load patient data
	use "`results_data_path'\\`disease'\\`disease'_year`df_spline_year'_age`df_spline_age'_`bool_stage'.dta", clear

	// scale(hazard) requests the model to be fitted on the log cumulative hazard scale
	if (`df_TD' == 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate)
	}
	else if (`df_TD' > 0){
		quietly stpm2 syr* fem* sag*, scale(hazard) df(`df_baseline') bhazard(rate) tvc(syr* fem* sag*) dftvc(`df_TD')
	}
	
	// cure model
	// TODO: no time-varying variables in cure model?
	// quietly stpm2 fem sag* syr*, scale(hazard) df(`df_baseline') bhazard(rate) cure
	
	// baseline survival function: predict base_hz, survival zeros
	// log cumulative hazard: predict logCH, xb zeros
	// survival function: predict surv, survival zeros

	// hazard function
	// The zeros option sets the values of all covariates, other than those specified in the the at() option, to zero.
	predict hz, hazard zeros 

	// plots
	twoway (line hz _t, sort), ///
		ytitle("") ///
		xtitle("") title("`disease'") ///
		name("hazard_`disease'", replace) graphregion(color(white))
	graph save "`combined_figure_path'\Hazard plot\hazard_`disease'.gph", replace
}

cd "`combined_figure_path'\Hazard plot"
graph combine hazard_BLAD.gph hazard_CERV.gph hazard_CNS.gph hazard_CRC.gph hazard_ECS.gph hazard_ENDO.gph ///
		hazard_FBRE.gph hazard_HN.gph hazard_HPB.gph hazard_KIDN.gph hazard_LUNG.gph hazard_MEL.gph ///
		hazard_OFT.gph hazard_PROST.gph hazard_SCC.gph hazard_TEST.gph hazard_THY.gph, ///
		col(5) graphregion(color(white)) l1(Hazard) ///
		b1(Years from Diagnosis) ycommon
graph export "`combined_figure_path'\Hazard plot\hazards.png", width(1000) height(1000) replace
