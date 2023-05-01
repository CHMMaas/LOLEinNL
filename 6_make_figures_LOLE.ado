*------------------------------------------------------------------------------*
* This scripts makes figures of loss in life expectancy (LOLE) estimates ------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop make_figures_LOLE
program make_figures_LOLE
args disease bool_CI bool_stage age1 age2 age3 age4 min_age max_age ///
		start_year end_year results_data_path ///
		max_since_years step
capture drop *

local xaxislabel_year = "`start_year' 2004 `end_year'"
local combined_figure_path = #

if ("`bool_stage'" == "without_stage"){	
	local lightmale = "110 212 244"
	local darkmale = "13 136 175"

	local lightfem = "238 163 205"
	local darkfem = "207 39 132"
	
	*--------------------------------------------------------------------------*
	*** Figure 2: LE of general population and cancer patients with CI*
	*--------------------------------------------------------------------------*
	display "Make Supplemental Figure"
	use "`results_data_path'\\results_`disease'_CLOLE_multiple_with_CI_without_stage.dta", clear
	
	/* titles */
	local name_title = "Loss of life expectancy"
	local pname_title = "Proportional loss of life expectancy"
	
	/* xaxis labels */
	su survexp_0 if (jaar==`start_year' & age==`age1'), meanonly
	local y_max_LE = ceil(r(max))
	if (`y_max_LE' > 30){
		local step_LE = 10
	}
	else{
		local step_LE = 5
	}
	local yaxislabel_LE = "0(`step_LE')`y_max_LE'"
	
	/* Plot (conditional) LOLE over time for four ages */
	foreach age_val in `age1' `age3' `age4' {
		use "`results_data_path'\results_`disease'_CLOLE_multiple_with_CI_without_stage.dta", clear
		
		// Hoog-over studie
		quietly keep if age==`age_val'
		if ("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | ///
			"`disease'" == "FBRE" | "`disease'" == "PROST" | "`disease'" == "TEST"){ // One gender
			if ("`disease'" == "PROST" | "`disease'" == "TEST"){
				quietly keep if geslacht==1 // Males
				local lightcol = "`lightmale'"
				local darkcol = "`darkmale'"
			}
			else{
				quietly keep if geslacht==2 // Females
				local lightcol = "`lightfem'"
				local darkcol = "`darkfem'"
			}
			
			if (("`disease'" == "ALL" | "`disease'" == "HPB") & `age_val' == `age4'){
				twoway (rarea survobs_lci_0 survobs_uci_0 jaar, lcolor("`lightcol'" "`lightcol'") color("`lightcol'")) ///
				|| (line survobs_0 survexp_0 jaar, lpatt(solid dash) lcolor("`darkcol'" "`darkcol'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2)
			}
			else if (("`disease'" == "ALL" | "`disease'" == "HPB") & `age_val' != `age4'){
				twoway (rarea survobs_lci_0 survobs_uci_0 jaar, lcolor("`lightcol'" "`lightcol'") color("`lightcol'")) ///
				|| (line survobs_0 survexp_0 jaar, lpatt(solid dash) lcolor("`darkcol'" "`darkcol'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) xsc(off fill)
			}
			else if (("`disease'" != "ALL" & "`disease'" != "HPB") & `age_val' == `age4'){
				twoway (rarea survobs_lci_0 survobs_uci_0 jaar, lcolor("`lightcol'" "`lightcol'") color("`lightcol'")) ///
				|| (line survobs_0 survexp_0 jaar, lpatt(solid dash) lcolor("`darkcol'" "`darkcol'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) ysc(off fill)
			}
			else if (("`disease'" != "ALL" & "`disease'" != "HPB") & `age_val' != `age4'){
				twoway (rarea survobs_lci_0 survobs_uci_0 jaar, lcolor("`lightcol'" "`lightcol'") color("`lightcol'")) ///
				|| (line survobs_0 survexp_0 jaar, lpatt(solid dash) lcolor("`darkcol'" "`darkcol'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) ysc(off fill) xsc(off fill)
			}
		}
		else{ // Both genders
			quietly gen survexp_male = survexp_0 if geslacht==1
			quietly gen survobs_male = survobs_0 if geslacht==1
			quietly gen survobs_lci_male = survobs_lci_0 if geslacht==1
			quietly gen survobs_uci_male = survobs_uci_0 if geslacht==1
			quietly gen survexp_fem = survexp_0 if geslacht==2
			quietly gen survobs_fem = survobs_0 if geslacht==2
			quietly gen survobs_lci_fem = survobs_lci_0 if geslacht==2
			quietly gen survobs_uci_fem = survobs_uci_0 if geslacht==2
			if (("`disease'" == "ALL" | "`disease'" == "HPB") & `age_val' == `age4'){
				twoway (rarea survobs_lci_male survobs_uci_male jaar, lcolor("`lightmale'" "`lightmale'") color("`lightmale'")) ///
				|| (rarea survobs_lci_fem survobs_uci_fem jaar, lcolor("`lightfem'" "`lightfem'") color("`lightfem'")) ///
				|| (line survobs_male survexp_male jaar, lpatt(solid dash) lcolor("`darkmale'" "`darkmale'")) ///
				|| (line survobs_fem survexp_fem jaar, lpatt(solid dash) lcolor("`darkfem'" "`darkfem'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2)
			}
			else if (("`disease'" == "ALL" | "`disease'" == "HPB") & `age_val' != `age4'){
				twoway (rarea survobs_lci_male survobs_uci_male jaar, lcolor("`lightmale'" "`lightmale'") color("`lightmale'")) ///
				|| (rarea survobs_lci_fem survobs_uci_fem jaar, lcolor("`lightfem'" "`lightfem'") color("`lightfem'")) ///
				|| (line survobs_male survexp_male jaar, lpatt(solid dash) lcolor("`darkmale'" "`darkmale'")) ///
				|| (line survobs_fem survexp_fem jaar, lpatt(solid dash) lcolor("`darkfem'" "`darkfem'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) xsc(off fill)
			}
			else if (("`disease'" != "ALL" & "`disease'" != "HPB") & `age_val' == `age4'){
				twoway (rarea survobs_lci_male survobs_uci_male jaar, lcolor("`lightmale'" "`lightmale'") color("`lightmale'")) ///
				|| (rarea survobs_lci_fem survobs_uci_fem jaar, lcolor("`lightfem'" "`lightfem'") color("`lightfem'")) ///
				|| (line survobs_male survexp_male jaar, lpatt(solid dash) lcolor("`darkmale'" "`darkmale'")) ///
				|| (line survobs_fem survexp_fem jaar, lpatt(solid dash) lcolor("`darkfem'" "`darkfem'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) ysc(off fill)
			}
			else if (("`disease'" != "ALL" & "`disease'" != "HPB") & `age_val' != `age4'){
				twoway (rarea survobs_lci_male survobs_uci_male jaar, lcolor("`lightmale'" "`lightmale'") color("`lightmale'")) ///
				|| (rarea survobs_lci_fem survobs_uci_fem jaar, lcolor("`lightfem'" "`lightfem'") color("`lightfem'")) ///
				|| (line survobs_male survexp_male jaar, lpatt(solid dash) lcolor("`darkmale'" "`darkmale'")) ///
				|| (line survobs_fem survexp_fem jaar, lpatt(solid dash) lcolor("`darkfem'" "`darkfem'")), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LE', labsize(*1.5)) aspectratio(2) ysc(off fill) xsc(off fill)
			}
		}
		
		graph save "`combined_figure_path'\ci_LOLE_`age_val'_`disease'", replace
	}
	
	*----------------------------------------------------------*
	*** Figure 3: LOLE for 3 ages below each other over time ***
	*----------------------------------------------------------*
	// Switch y-axis and x-axis on or off
	if (("`disease'" == "ALL" | "`disease'" == "HPB")){
		local yonoff = ""
	}
	else if (("`disease'" != "ALL" | "`disease'" != "HPB")){
		local yonoff = "ysc(off fill)"
	}
	
	// Create variables
	local yaxislabel_LOLE = "0(5)40"
	use "`results_data_path'\\results_`disease'_CLOLE_multiple_with_CI_without_stage.dta", clear
	foreach age_val in `age1' `age3' `age4' {
		quietly gen ll_`age_val' = ll_0 if age==`age_val'
		lab var ll_`age_val' "Age `age_val'"
		
		quietly gen ll_lci_`age_val' = ll_lci_0 if age==`age_val'
		lab var ll_lci_`age_val' "Age `age_val'"
		
		quietly gen ll_uci_`age_val' = ll_uci_0 if age==`age_val'
		lab var ll_uci_`age_val' "Age `age_val'"
	}
	
	// Males	
	if ("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | "`disease'" == "FBRE"){
		twoway (line ll_`age1' jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xsc(off fill) ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local xonoff = "xsc(off fill)"
		twoway (rarea ll_lci_`age1' ll_uci_`age1' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(solid solid)) ///
				|| (rarea ll_lci_`age3' ll_uci_`age3' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(dash dash)) ///
				|| (rarea ll_lci_`age4' ll_uci_`age4' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(longdash_dot longdash_dot)) ///
				|| (line ll_`age1' jaar if (geslacht==1), lc("`darkmale'") lp(solid)) ///
				|| (line ll_`age3' jaar if (geslacht==1), lc("`darkmale'") lp(dash)), ///
				|| (line ll_`age4' jaar if (geslacht==1), lc("`darkmale'") lp(longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LOLE', labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\LOLE_year_`disease'_male_`bool_stage'", replace
	
	// Females
	if ("`disease'" == "PROST" | "`disease'" == "TEST"){
		twoway (line ll_`age1' jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
		ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local xonoff = ""
		twoway (rarea ll_lci_`age1' ll_uci_`age1' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(solid solid)) ///
				|| (rarea ll_lci_`age3' ll_uci_`age3' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(dash dash)) ///
				|| (rarea ll_lci_`age4' ll_uci_`age4' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(longdash_dot longdash_dot)) ///
				|| (line ll_`age1' jaar if (geslacht==2), lc("`darkfem'") lp(solid)) ///
				|| (line ll_`age3' jaar if (geslacht==2), lc("`darkfem'") lp(dash)), ///
				|| (line ll_`age4' jaar if (geslacht==2), lc("`darkfem'") lp(longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(`yaxislabel_LOLE', labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\LOLE_year_`disease'_female_`bool_stage'", replace
	
	*-----------------------------------------------------------*
	*** Figure 4: PLOLE for 3 ages below each other over time ***
	*-----------------------------------------------------------*
	// Create variables
	use "`results_data_path'\\results_`disease'_CLOLE_multiple_with_CI_without_stage.dta", clear
	foreach age_val in `age1' `age3' `age4' {
		quietly gen PLOLE_`age_val' = ll_0/survexp_0 if age==`age_val'
		lab var PLOLE_`age_val' "Age `age_val'"
		
		quietly gen PLOLE_lci_`age_val' = ll_lci_0/survexp_0 if age==`age_val'
		lab var PLOLE_lci_`age_val' "Age `age_val'"
		
		quietly gen PLOLE_uci_`age_val' = ll_uci_0/survexp_0 if age==`age_val'
		lab var PLOLE_uci_`age_val' "Age `age_val'"
	}
	
	// Males
	if ("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | "`disease'" == "FBRE"){
		twoway (line PLOLE_`age1' jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xsc(off fill) ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local xonoff = "xsc(off fill)"
		twoway (rarea PLOLE_lci_`age1' PLOLE_uci_`age1' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(solid solid)) ///
				|| (rarea PLOLE_lci_`age3' PLOLE_uci_`age3' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(dash dash)) ///
				|| (rarea PLOLE_lci_`age4' PLOLE_uci_`age4' jaar if (geslacht==1), lc("`lightmale'", "`lightmale'") color("`lightmale'") lp(longdash_dot longdash_dot)) ///
				|| (line PLOLE_`age1' jaar if (geslacht==1), lc("`darkmale'") lp(solid)) ///
				|| (line PLOLE_`age3' jaar if (geslacht==1), lc("`darkmale'") lp(dash)), ///
				|| (line PLOLE_`age4' jaar if (geslacht==1), lc("`darkmale'") lp(longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\PLOLE_year_`disease'_male_`bool_stage'", replace
	
	// Females
	if ("`disease'" == "PROST" | "`disease'" == "TEST"){
		twoway (line PLOLE_`age1' jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
		ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local xonoff = ""
		twoway (rarea PLOLE_lci_`age1' PLOLE_uci_`age1' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(solid solid)) ///
				|| (rarea PLOLE_lci_`age3' PLOLE_uci_`age3' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(dash dash)) ///
				|| (rarea PLOLE_lci_`age4' PLOLE_uci_`age4' jaar if (geslacht==2), lc("`lightfem'", "`lightfem'") color("`lightfem'") lp(longdash_dot longdash_dot)) ///
				|| (line PLOLE_`age1' jaar if (geslacht==2), lc("`darkfem'") lp(solid)) ///
				|| (line PLOLE_`age3' jaar if (geslacht==2), lc("`darkfem'") lp(dash)), ///
				|| (line PLOLE_`age4' jaar if (geslacht==2), lc("`darkfem'") lp(longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\PLOLE_year_`disease'_female_`bool_stage'", replace
	
	*---------------------------------------------------*
	*** Figure 7: CPLOLE for 3 years for 65-year-olds ***
	*---------------------------------------------------*
	if (`max_since_years' > 0){
		/* yaxis label range */
		local yaxislabel_CLOLE = "0(5)10"
		local middle_year = 2005
		foreach gender in 1 2{
// 			local yaxislabel_CPLOLE = ""
// 			if ("`disease'" == "ALL" | "`disease'" == "HPB"){
// 				local yaxislabel_CPLOLE = "0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100" "
// 			}
			
			local xaxislabel_CPLOLE = ""
			if (`gender' == 1){
				local col1 = "207 241 251"
				local col2 = "158 226 248"
				local col3 = "110 212 244"
				local col4 = "13 136 175"
				local col5 = "9 91 116"
				
				local gender_str = "Males"
				local xonoff = "xsc(off fill)"
			}
			else if (`gender' == 2){
				local col1 = "249 224 238"
				local col2 = "243 194 221"
				local col3 = "238 163 205"
				local col4 = "207 39 132"
				local col5 = "138 26 88"
		
				local gender_str = "Females"
				local xaxislabel_CPLOLE = "0(2)`max_since_years'"
				local xonoff = ""
			}
			
			use "`results_data_path'\\results_`disease'_CLOLE_multiple_with_CI_without_stage.dta", clear

			if ((("`disease'" == "PROST" | "`disease'" == "TEST") & `gender'==2)){
				drop *
				set obs 3
				egen x = fill(0 5 10)
				egen y = fill(0 0.5 1)
				twoway (line y x, lc("white")), graphregion(color(white)) ///
					title("") legend(off) scheme(sj) ytitle("") xtitle("") ///
					xlabel(`xaxislabel_CPLOLE', labsize(*1.5)) 		       ///
					ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5)
					graph save "`combined_figure_path'\CPLOLE_`disease'_`gender_str'_`bool_stage'", replace
			} 
			else if (("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | "`disease'" == "FBRE") & `gender'==1){
				drop *
				set obs 3
				egen x = fill(0 5 10)
				egen y = fill(0 0.5 1)
				twoway (line y x, lc("white")), graphregion(color(white)) ///
					title("") legend(off) scheme(sj) ytitle("") xtitle("") ///
					xsc(off fill) ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5)
					graph save "`combined_figure_path'\CPLOLE_`disease'_`gender_str'_`bool_stage'", replace
			} 
			else {
				quietly keep if (geslacht==`gender' & age==65 & (jaar==`start_year' | jaar==`middle_year' | jaar==`end_year'))
				forval cond_year = 0(`step')`max_since_years' {
					quietly gen PLOLE_`cond_year' = ll_`cond_year'/survexp_`cond_year'
					quietly gen PLOLE_lci_`cond_year' = ll_lci_`cond_year'/survexp_`cond_year'
					quietly gen PLOLE_uci_`cond_year' = ll_uci_`cond_year'/survexp_`cond_year'
				}
				quietly keep PLOLE_*
				xpose, clear varname
				rename v1 PLOLE_`start_year'
				rename v2 PLOLE_`middle_year'
				rename v3 PLOLE_`end_year'
				egen id = seq(), f(1) t(33) b(1)
				egen x = seq(), f(0) t(`max_since_years') b(3)
				foreach cal_year in `start_year' `middle_year' `end_year'{
					quietly gen PLOLE_`cal_year'_est = PLOLE_`cal_year' if (_varname=="PLOLE_0" | _varname=="PLOLE_1" | _varname=="PLOLE_2" 					///
																				| _varname=="PLOLE_3" | _varname=="PLOLE_4" | _varname=="PLOLE_5" 				///
																				| _varname=="PLOLE_6" | _varname=="PLOLE_7" | _varname=="PLOLE_8"				///	
																				| _varname=="PLOLE_9" | _varname=="PLOLE_10")
					quietly gen PLOLE_`cal_year'_lci = PLOLE_`cal_year' if (_varname=="PLOLE_lci_0" | _varname=="PLOLE_lci_1" | _varname=="PLOLE_lci_2" 		///
																				| _varname=="PLOLE_lci_3" | _varname=="PLOLE_lci_4" | _varname=="PLOLE_lci_5" 	///
																				| _varname=="PLOLE_lci_6" | _varname=="PLOLE_lci_7" | _varname=="PLOLE_lci_8"	///
																				| _varname=="PLOLE_lci_9" | _varname=="PLOLE_lci_10")
					quietly gen PLOLE_`cal_year'_uci = PLOLE_`cal_year' if (_varname=="PLOLE_uci_0" | _varname=="PLOLE_uci_1" | _varname=="PLOLE_uci_2" 		///
																				| _varname=="PLOLE_uci_3" | _varname=="PLOLE_uci_4" | _varname=="PLOLE_uci_5" 	///	
																				| _varname=="PLOLE_uci_6" | _varname=="PLOLE_uci_7" | _varname=="PLOLE_uci_8"	///
																				| _varname=="PLOLE_uci_9" | _varname=="PLOLE_uci_10")
				}
				collapse (sum) PLOLE_`start_year'_est PLOLE_`start_year'_lci PLOLE_`start_year'_uci ///
								PLOLE_`middle_year'_est PLOLE_`middle_year'_lci PLOLE_`middle_year'_uci ///
								PLOLE_`end_year'_est PLOLE_`end_year'_lci PLOLE_`end_year'_uci, by (x)
				twoway (rarea PLOLE_`start_year'_lci PLOLE_`start_year'_uci x, lc("`col1'", "`col1'") color("`col1'") lp(solid solid)) ///
						|| (rarea PLOLE_`middle_year'_lci PLOLE_`middle_year'_uci x, lc("`col2'", "`col2'") color("`col2'") lp(dash dash)) ///
						|| (rarea PLOLE_`end_year'_lci PLOLE_`end_year'_uci x, lc("`col3'", "`col3'") color("`col3'") lp(longdash_dot longdash_dot)) ///
						|| (line PLOLE_`start_year'_est x, lc("`col5'") lp(solid)) ///
						|| (line PLOLE_`middle_year'_est x, lc("`col5'") lp(dash)) ///
						|| (line PLOLE_`end_year'_est x, lc("`col5'") lp(longdash_dot)), ///
					graphregion(color(white)) legend(off) title("") scheme(sj) ///
					ytitle("") xtitle("") 		  				///
					xlabel(`xaxislabel_CPLOLE', labsize(*1.5)) 	///
					ylabel(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) 	///
					xsize(1) ysize(1) `xonoff' `yonoff' aspectratio(1.5)
					graph save "`combined_figure_path'\CPLOLE_`disease'_`gender_str'_`bool_stage'", replace
			}
		}
	}
}
else if ("`bool_stage'" == "with_stage"){
	use "`results_data_path'\results_`disease'_CLOLE_multiple_with_CI_with_stage.dta", clear
	
	// Only for median age
	quietly keep if age == 65
	
	*-----------------------------*
	*** Figure S1: LOLE by stage ***
	*-----------------------------*
	display "Make figure S1"
	local year_cond  = 0
	
	// Generate (C)LOLE for all stages
	capture drop PLOLE_localized PLOLE_lci_localized PLOLE_uci_localized
	quietly gen PLOLE_localized = ll_`year_cond'/survexp_`year_cond' if stage1==1
	quietly gen PLOLE_lci_localized = ll_lci_`year_cond'/survexp_`year_cond' if stage1==1
	quietly gen PLOLE_uci_localized = ll_uci_`year_cond'/survexp_`year_cond' if stage1==1
	
	capture drop PLOLE_regional PLOLE_lci_regional PLOLE_uci_regional
	quietly gen PLOLE_regional = ll_`year_cond'/survexp_`year_cond' if stage2==1
	quietly gen PLOLE_lci_regional = ll_lci_`year_cond'/survexp_`year_cond' if stage2==1
	quietly gen PLOLE_uci_regional = ll_uci_`year_cond'/survexp_`year_cond' if stage2==1
	
	capture drop PLOLE_distant PLOLE_lci_distant PLOLE_uci_distant
	quietly gen PLOLE_distant = ll_`year_cond'/survexp_`year_cond' if stage3==1
	quietly gen PLOLE_lci_distant = ll_lci_`year_cond'/survexp_`year_cond' if stage3==1
	quietly gen PLOLE_uci_distant = ll_uci_`year_cond'/survexp_`year_cond' if stage3==1

	// Switch y-axis and x-axis on or off
	if (("`disease'" == "ALL" | "`disease'" == "HPB")){
		local yonoff = ""
	}
	else if (("`disease'" != "ALL" | "`disease'" != "HPB")){
		local yonoff = "ysc(off fill)"
	}
	
	// Males
	if ("`disease'" == "CERV" | "`disease'" == "OFT" | "`disease'" == "ENDO" | "`disease'" == "FBRE"){
		twoway (line PLOLE_localized jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xsc(off fill) ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local male1 = "207 241 251"
		local male2 = "158 226 248"
		local male3 = "110 212 244"
		local male4 = "13 136 175"
		local male5 = "9 91 116"
		
		local xonoff = "xsc(off fill)"
		
		twoway (rarea PLOLE_lci_localized PLOLE_uci_localized jaar if (geslacht==1), lc("`male1'", "`male1'") color("`male1'") lp(solid solid)) ///
				|| (rarea PLOLE_lci_regional PLOLE_uci_regional jaar if (geslacht==1), lc("`male2'", "`male2'") color("`male2'") lp(dash dash)) ///
				|| (rarea PLOLE_lci_distant PLOLE_uci_distant jaar if (geslacht==1), lc("`male3'", "`male3'") color("`male3'") lp(longdash_dot longdash_dot)) ///
				|| (line PLOLE_localized jaar if (geslacht==1), lc("`male5'", "`male5'") lp(solid solid)) ///
				|| (line PLOLE_regional jaar if (geslacht==1), lc("`male5'", "`male5'") lp(dash dash)), ///
				|| (line PLOLE_distant jaar if (geslacht==1), lc("`male5'", "`male5'") lp(longdash_dot longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\PLOLE_`disease'_male_`bool_stage'", replace
	
	// Females
	if ("`disease'" == "PROST" | "`disease'" == "TEST"){
		twoway (line PLOLE_localized jaar, lc("white")), graphregion(color(white))   ///
		title("") legend(off) scheme(sj) ytitle("") xtitle("") aspectratio(1.5) ///
		xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
		ysc(off fill) ylab(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", nogrid)
	}
	else{
		local fem1 = "249 224 238"
		local fem2 = "243 194 221"
		local fem3 = "238 163 205"
		local fem4 = "207 39 132"
		local fem5 = "138 26 88"
		
		local xonoff = ""
		
		twoway (rarea PLOLE_lci_localized PLOLE_uci_localized jaar if (geslacht==2), lc("`fem1'", "`fem1'") color("`fem1'") lp(solid solid)) ///
				|| (rarea PLOLE_lci_regional PLOLE_uci_regional jaar if (geslacht==2), lc("`fem2'", "`fem2'") color("`fem2'") lp(dash dash)) ///
				|| (rarea PLOLE_lci_distant PLOLE_uci_distant jaar if (geslacht==2), lc("`fem3'", "`fem3'") color("`fem3'") lp(longdash_dot longdash_dot)) ///
				|| (line PLOLE_localized jaar if (geslacht==2), lc("`fem5'", "`fem5'") lp(solid solid)) ///
				|| (line PLOLE_regional jaar if (geslacht==2), lc("`fem5'", "`fem5'") lp(dash dash)), ///
				|| (line PLOLE_distant jaar if (geslacht==2), lc("`fem5'", "`fem5'") lp(longdash_dot longdash_dot)), ///
				graphregion(color(white)) title("") legend(off) scheme(sj) 				///
				ytitle("") xtitle("") xlabel(`xaxislabel_year', labsize(*1.5) angle(0)) ///
				ylabel(0 "0" 0.2 "20" 0.4 "40" 0.6 "60" 0.8 "80" 1 "100", labsize(*1.5)) aspectratio(1.5) `xonoff' `yonoff'
	}
	graph save "`combined_figure_path'\PLOLE_`disease'_female_`bool_stage'", replace	
}

end
