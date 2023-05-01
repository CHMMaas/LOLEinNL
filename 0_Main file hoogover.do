*------------------------------------------------------------------------------*
* This script calculates the loss of life expectancy of 16 leading cancers in -*
* the Netherlands from 1989 to 2019 -------------------------------------------*
*------------------------------------------------------------------------------*

/* delete previous variables and programs */
capture drop *
capture program drop *

/* Choose if sensitivity analysis should be done or not, enter "yes" or "no" */
local bool_SA = "no"

/* Choose if analysis should be run with or without CI, enter "yes" or "no" */
local bool_CI = "yes"

/* Conditional LOLE for 0, ... `max_since_years' with steps of `step', 
   e.g. from 0 to max_since_years=10 with steps of step=5 gives: 
   LOLE, CLOLE-5, and CLOLE-10 */
local max_since_years = 10
local step = 1

/* Abbreviations of cancer types */
/* Choose if model should include stage, enter "yes" or "no" */
local bool_stage = "with_stage"

local diseases " "BLAD" "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "PROST" "SCC" "TEST" "THY" "ALL" "
// local diseases " "MEL" "

/* Run analysis for each disease */
foreach disease in `diseases'{
	display "`disease'"
	/* The path in which the code is located */
	local path_ado_files = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Code"
	
	/* The path in which to retrieve and store data files */
	local data_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Data"
	
	/* The path in which to store results */
	local results_data_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\\`disease'"
	
	/* The path in which to results to sensitivity analysis */
	local SA_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Results\SA"
	
	/* Specify the start and end year */
	local start_year = 1989
	local end_year = 2019
	/* Maximum follow up date in patient file */
	local max_fupdat = 2021
	
	/* Specify the minimum and maximum age */
	local min_age = 18
	local max_age = 90
	/* maximum age of CBS life table */
	local max_CBS_age = 95
	
	/* Parameter specifications */
	/* Set statistical time of cure */
	local time_of_cure = 10
	
	if ("`bool_SA'" == "yes"){
		/* The initial settings for the most simple model for sensitivity analysis */
		local df_baseline = 1
		local df_spline_age = 1
		local df_spline_year = 1
		local df_TD = 0
	}
	else{
		/* Parameter settings resulting from sensitivity analysis for 
			the model with and without stage added to the model */	
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
		else if ("`bool_stage'" == "with_stage"){
			if ("`disease'" == "ALL"){
				local df_baseline = 7
				local df_spline_age = 3
				local df_spline_year = 3
				local df_TD = 0
			}
			else if ("`disease'" == "BLAD"){
				local df_baseline = 4
				local df_spline_age = 2
				local df_spline_year = 2
				local df_TD = 1
			}
			else if ("`disease'" == "CERV"){
				local df_baseline = 3
				local df_spline_age = 1
				local df_spline_year = 1
				local df_TD = 0
			}
			else if ("`disease'" == "CNS"){
				local df_baseline = 7
				local df_spline_age = 3
				local df_spline_year = 3
				local df_TD = 2
			}
			else if ("`disease'" == "CRC"){
				local df_baseline = 7
				local df_spline_age = 3
				local df_spline_year = 3
				local df_TD = 1
			}
			else if ("`disease'" == "ECS"){
				local df_baseline = 9
				local df_spline_age = 3
				local df_spline_year = 3
				local df_TD = 2
			}
			else if ("`disease'" == "ENDO"){
				local df_baseline = 3
				local df_spline_age = 1
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
				local df_TD = 0
			}
			else if ("`disease'" == "KIDN"){
				local df_baseline = 3
				local df_spline_age = 2
				local df_spline_year = 3
				local df_TD = 2
			}
			else if ("`disease'" == "LUNG"){
				local df_baseline = 4
				local df_spline_age = 3
				local df_spline_year = 3
				local df_TD = 0
			}
			else if ("`disease'" == "MEL"){
				local df_baseline = 3
				local df_spline_age = 1
				local df_spline_year = 2
				local df_TD = 2
			}
			else if ("`disease'" == "OFT"){
				local df_baseline = 6
				local df_spline_age = 3
				local df_spline_year = 1
				local df_TD = 0
			}
			else if ("`disease'" == "PROST"){
				local df_baseline = 5
				local df_spline_age = 2
				local df_spline_year = 3
				local df_TD = 1
			}
			else if ("`disease'" == "SCC"){
				local df_baseline = 2
				local df_spline_age = 2
				local df_spline_year = 2
				local df_TD = 0
			}
			else if ("`disease'" == "TEST"){
				local df_baseline = 4
				local df_spline_age = 1
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
	}

	
	/* Calendar years to display in results */
	local year1 = 1990
	local year2 = 2000 
	local year3 = 2010
	local year4 = 2019
	
	/* Age at diagnosis to display in results */
	local age1 = 45
	local age2 = 50
	local age3 = 65
	local age4 = 75
	
	/* Range of degrees of freedom for age and year at diagnosis */
	local spline_min = 1
	local spline_max = 3
	/* Range of degrees of freedom for baseline hazard */
	local baseline_min = 1
	local baseline_max = 10
	/* Range of degrees of freedom for time-dependent effects */
	local TD_min = 0
	local TD_max = 2

	/* Run analysis */
	quietly cd "`path_ado_files'"
	run 0_run_analysis.ado
	run_analysis "`path_ado_files'" "`data_path'"                 ///
					"`results_data_path'" "`SA_path'" "`disease'" ///
					"`start_year'" "`end_year'" "`max_fupdat'"    ///
					"`min_age'" "`max_age'" "`max_CBS_age'"       ///
					"`df_spline_year'" "`df_spline_age'"          ///
					"`df_baseline'" "`df_TD'" "`time_of_cure'"    ///
					"`max_since_years'" "`step'"                  ///
					"`bool_CI'" "`bool_stage'" 					  ///
					"`year1'" "`year2'" "`year3'" "`year4'"       ///
					"`age1'" "`age2'" "`age3'" "`age4'"           ///
					"`bool_SA'" "`spline_min'" "`spline_max'"     ///
					"`baseline_min'" "`baseline_max'"             ///
					"`TD_min'" "`TD_max'"
}