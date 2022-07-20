*---------------------------------------------------------------------------------*
***** Analysis of Hematology Data in the NCR data for the period 1989 to 2019 ***** 
*---------------------------------------------------------------------------------*

/* delete previous variables and programs */
capture drop *
capture program drop *

/* Set directory */
local combined_figure_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Results\"
cd "`combined_figure_path'\Figures"

/* Figure 2 LE CI cancer patients and LE general population */
graph combine ci_LOLE_45_ALL.gph ci_LOLE_45_BLAD.gph ci_LOLE_45_CERV.gph ///
		ci_LOLE_45_CNS.gph ci_LOLE_45_CRC.gph ci_LOLE_45_ECS.gph ///
		ci_LOLE_45_ENDO.gph ci_LOLE_45_FBRE.gph ci_LOLE_45_HN.gph, ///
		col(9) name("Fig2a", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine ci_LOLE_65_ALL.gph ci_LOLE_65_BLAD.gph ci_LOLE_65_CERV.gph ///
		ci_LOLE_65_CNS.gph ci_LOLE_65_CRC.gph ci_LOLE_65_ECS.gph ///
		ci_LOLE_65_ENDO.gph ci_LOLE_65_FBRE.gph ci_LOLE_65_HN.gph, ///
		col(9) name("Fig2b", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine ci_LOLE_75_ALL.gph ci_LOLE_75_BLAD.gph ci_LOLE_75_CERV.gph ///
		ci_LOLE_75_CNS.gph ci_LOLE_75_CRC.gph ci_LOLE_75_ECS.gph ///
		ci_LOLE_75_ENDO.gph ci_LOLE_75_FBRE.gph ci_LOLE_75_HN.gph, ///
		col(9) name("Fig2c", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine Fig2a Fig2b Fig2c, ///
		col(1) imargin(0 0 -6 -6) graphregion(color(white)) l1(Life years remaining) ///
		b1(Year of diagnosis) name("Fig2", replace) xsize(10) ysize(6) iscale(1.2) ///
		xcommon ycommon
graph export "`combined_figure_path'\Figure 2 - LE\Fig2a.emf", replace
/* Figure 2 continued: LE CI cancer patients and LE general population */
graph combine ci_LOLE_45_HPB.gph ci_LOLE_45_KIDN.gph ci_LOLE_45_LUNG.gph ///
		ci_LOLE_45_MEL.gph ci_LOLE_45_OFT.gph ci_LOLE_45_PROST.gph ///
		ci_LOLE_45_SCC.gph ci_LOLE_45_TEST.gph ci_LOLE_45_THY.gph, ///
		col(9) name("Fig2d", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine ci_LOLE_65_HPB.gph ci_LOLE_65_KIDN.gph ci_LOLE_65_LUNG.gph ///
		ci_LOLE_65_MEL.gph ci_LOLE_65_OFT.gph ci_LOLE_65_PROST.gph ///
		ci_LOLE_65_SCC.gph ci_LOLE_65_TEST.gph ci_LOLE_65_THY.gph, ///
		col(9) name("Fig2e", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine ci_LOLE_75_HPB.gph ci_LOLE_75_KIDN.gph ci_LOLE_75_LUNG.gph ///
		ci_LOLE_75_MEL.gph ci_LOLE_75_OFT.gph ci_LOLE_75_PROST.gph ///
		ci_LOLE_75_SCC.gph ci_LOLE_75_TEST.gph ci_LOLE_75_THY.gph, ///
		col(9) name("Fig2f", replace) imargin(-5 4 -8 -8) iscale(.36) fysize(33) ///
		xcommon ycommon
graph combine Fig2d Fig2e Fig2f, ///
		col(1) imargin(0 0 -6 -6) graphregion(color(white)) l1(Life years remaining) ///
		b1(Year of diagnosis) name("Fig2cont", replace) xsize(10) ysize(6) iscale(1.2) ///
		xcommon ycommon
graph export "`combined_figure_path'\Figure 2 - LE\Fig2b.emf", replace

/* Figure S1: LOLE by stage */
graph combine PLOLE_ALL_male_with_stage.gph PLOLE_BLAD_male_with_stage.gph PLOLE_CERV_male_with_stage.gph ///
		PLOLE_CNS_male_with_stage.gph PLOLE_CRC_male_with_stage.gph PLOLE_ECS_male_with_stage.gph ///
		PLOLE_ENDO_male_with_stage.gph PLOLE_FBRE_male_with_stage.gph PLOLE_HN_male_with_stage.gph, ///
		col(9) name("FigS1a", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_ALL_female_with_stage.gph PLOLE_BLAD_female_with_stage.gph PLOLE_CERV_female_with_stage.gph ///
		PLOLE_CNS_female_with_stage.gph PLOLE_CRC_female_with_stage.gph PLOLE_ECS_female_with_stage.gph ///
		PLOLE_ENDO_female_with_stage.gph PLOLE_FBRE_female_with_stage.gph PLOLE_HN_female_with_stage.gph, ///
		col(9) name("FigS1b", replace) imargin(-5 3 0 0) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_HPB_male_with_stage.gph PLOLE_KIDN_male_with_stage.gph PLOLE_LUNG_male_with_stage.gph ///
		PLOLE_MEL_male_with_stage.gph PLOLE_OFT_male_with_stage.gph PLOLE_PROST_male_with_stage.gph ///
		PLOLE_TEST_male_with_stage.gph PLOLE_THY_male_with_stage.gph, ///
		col(8) name("FigS1c", replace) imargin(-7 2 -11 -4) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_HPB_female_with_stage.gph PLOLE_KIDN_female_with_stage.gph PLOLE_LUNG_female_with_stage.gph ///
		PLOLE_MEL_female_with_stage.gph PLOLE_OFT_female_with_stage.gph PLOLE_PROST_female_with_stage.gph ///
		PLOLE_TEST_female_with_stage.gph PLOLE_THY_female_with_stage.gph, ///
		col(8) name("FigS1d", replace) imargin(-12 1 -5 -5) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine FigS1a FigS1b FigS1c FigS1d, ///
		col(1) graphregion(color(white)) l1(Proportion of life lost (%)) ///
		b1(Year of diagnosis) name("FigS1", replace) xsize(10) ysize(6) iscale(0.1)
graph export "`combined_figure_path'\Figure S1 - LOLE by stage\FigS1.emf", replace

/* Figure 3 LOLE 3 ages below each other over time */
graph combine LOLE_year_ALL_male_without_stage.gph LOLE_year_BLAD_male_without_stage.gph LOLE_year_CERV_male_without_stage.gph ///
		LOLE_year_CNS_male_without_stage.gph LOLE_year_CRC_male_without_stage.gph LOLE_year_ECS_male_without_stage.gph ///
		LOLE_year_ENDO_male_without_stage.gph LOLE_year_FBRE_male_without_stage.gph LOLE_year_HN_male_without_stage.gph, ///
		col(9) name("Fig3a", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine LOLE_year_ALL_female_without_stage.gph LOLE_year_BLAD_female_without_stage.gph LOLE_year_CERV_female_without_stage.gph ///
		LOLE_year_CNS_female_without_stage.gph LOLE_year_CRC_female_without_stage.gph LOLE_year_ECS_female_without_stage.gph ///
		LOLE_year_ENDO_female_without_stage.gph LOLE_year_FBRE_female_without_stage.gph LOLE_year_HN_female_without_stage.gph, ///
		col(9) name("Fig3b", replace) imargin(-7 3 0 0) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine LOLE_year_HPB_male_without_stage.gph LOLE_year_KIDN_male_without_stage.gph LOLE_year_LUNG_male_without_stage.gph ///
		LOLE_year_MEL_male_without_stage.gph LOLE_year_OFT_male_without_stage.gph LOLE_year_PROST_male_without_stage.gph ///
		LOLE_year_SCC_male_without_stage.gph LOLE_year_TEST_male_without_stage.gph LOLE_year_THY_male_without_stage.gph, ///
		col(9) name("Fig3c", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine LOLE_year_HPB_female_without_stage.gph LOLE_year_KIDN_female_without_stage.gph LOLE_year_LUNG_female_without_stage.gph ///
		LOLE_year_MEL_female_without_stage.gph LOLE_year_OFT_female_without_stage.gph LOLE_year_PROST_female_without_stage.gph ///
		LOLE_year_SCC_female_without_stage.gph LOLE_year_TEST_female_without_stage.gph LOLE_year_THY_female_without_stage.gph, ///
		col(9) name("Fig3d", replace) imargin(-7 1 -5 -5) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine Fig3a Fig3b Fig3c Fig3d, ///
		col(1) graphregion(color(white)) l1(Life years lost) ///
		b1(Year of diagnosis) name("Fig3", replace) xsize(10) ysize(6) iscale(0.1)
graph export "`combined_figure_path'\Figure 3 - LOLE\Fig3.emf", replace

/* Figure 4 PLOLE 3 ages below each other over time */
graph combine PLOLE_year_ALL_male_without_stage.gph PLOLE_year_BLAD_male_without_stage.gph PLOLE_year_CERV_male_without_stage.gph ///
		PLOLE_year_CNS_male_without_stage.gph PLOLE_year_CRC_male_without_stage.gph PLOLE_year_ECS_male_without_stage.gph ///
		PLOLE_year_ENDO_male_without_stage.gph PLOLE_year_FBRE_male_without_stage.gph PLOLE_year_HN_male_without_stage.gph, ///
		col(9) name("Fig4a", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_year_ALL_female_without_stage.gph PLOLE_year_BLAD_female_without_stage.gph PLOLE_year_CERV_female_without_stage.gph ///
		PLOLE_year_CNS_female_without_stage.gph PLOLE_year_CRC_female_without_stage.gph PLOLE_year_ECS_female_without_stage.gph ///
		PLOLE_year_ENDO_female_without_stage.gph PLOLE_year_FBRE_female_without_stage.gph PLOLE_year_HN_female_without_stage.gph, ///
		col(9) name("Fig4b", replace) imargin(-7 3 0 0) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_year_HPB_male_without_stage.gph PLOLE_year_KIDN_male_without_stage.gph PLOLE_year_LUNG_male_without_stage.gph ///
		PLOLE_year_MEL_male_without_stage.gph PLOLE_year_OFT_male_without_stage.gph PLOLE_year_PROST_male_without_stage.gph ///
		PLOLE_year_SCC_male_without_stage.gph PLOLE_year_TEST_male_without_stage.gph PLOLE_year_THY_male_without_stage.gph, ///
		col(9) name("Fig4c", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine PLOLE_year_HPB_female_without_stage.gph PLOLE_year_KIDN_female_without_stage.gph PLOLE_year_LUNG_female_without_stage.gph ///
		PLOLE_year_MEL_female_without_stage.gph PLOLE_year_OFT_female_without_stage.gph PLOLE_year_PROST_female_without_stage.gph ///
		PLOLE_year_SCC_female_without_stage.gph PLOLE_year_TEST_female_without_stage.gph PLOLE_year_THY_female_without_stage.gph, ///
		col(9) name("Fig4d", replace) imargin(-7 1 -5 -5) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine Fig4a Fig4b Fig4c Fig4d, ///
		col(1) graphregion(color(white)) l1(Proportion of life lost (%)) ///
		b1(Year of diagnosis) name("Fig4", replace) xsize(10) ysize(6) iscale(0.1)
graph export "`combined_figure_path'\Figure 4 - PLOLE\Fig4.emf", replace

/* Figure 5: x-axis change in PLOLE, y-axis PLOLE in 2019 */
foreach gender_bool in 1 2 {
	if (`gender_bool' == 1){
		local diseases " "ALL" "BLAD" "CNS" "CRC" "ECS" "HN" "HPB" "KIDN" "LUNG" "MEL" "PROST" "SCC" "TEST" "THY" "
		local gender = "males"
	}
	else if (`gender_bool' == 2){
		local diseases " "ALL" "BLAD" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "SCC" "THY" "
		local gender = "females"
	}
	
	capture file close fig5_`gender'
	file open fig5_`gender' using "`combined_figure_path'\Figure 5 - change PLOLE vs PLOLE 2019\Fig5_`gender'.txt", write replace
	file write fig5_`gender' "Disease" _tab "LOLE 45 2019" _tab "change" _tab "PLOLE 45 2019" _tab "change" ///
									    _tab "LOLE 65 2019" _tab "change" _tab "PLOLE 65 2019" _tab "change" ///
									    _tab "LOLE 75 2019" _tab "change" _tab "PLOLE 75 2019" _tab "change" _n
	foreach dis in `diseases'{
		file write fig5_`gender' "`dis'"
		foreach age_val in "45" "65" "75"{
			use "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\\`dis'\results_`dis'_CLOLE_multiple_with_CI_without_stage", replace
			summarize ll_0 if jaar == 1989 & geslacht == `gender_bool' & age == `age_val'
			local LOLE1989 = (r(mean))
			summarize ll_0 if jaar == 2019 & geslacht == `gender_bool' & age == `age_val'
			local LOLE2019 = (r(mean))
			
			local change = `LOLE2019' - `LOLE1989'
			
			summarize survexp_0 if jaar == 1989 & geslacht == `gender_bool' & age == `age_val'
			local survexp1989 = (r(mean))
			summarize survexp_0 if jaar == 2019 & geslacht == `gender_bool' & age == `age_val'
			local survexp2019 = (r(mean))
			
			local PLOLE1989 = `LOLE1989'/`survexp1989'
			local PLOLE2019 = `LOLE2019'/`survexp2019'
			local PLOLEchange = `PLOLE2019' - `PLOLE1989'
			
			file write fig5_`gender' _tab "`LOLE2019'" _tab "`change'" _tab "`PLOLE2019'" _tab "`PLOLEchange'"
		}
		file write fig5_`gender' _n
	}
	file close fig5_`gender'
}

/* Figure 6: x-axis change in PLOLE, y-axis PLOLE in 2019 by stage for 65-year-old patients */
foreach gender_bool in 1 2 {
	if (`gender_bool' == 1){
		local diseases " "ALL" "BLAD" "CNS" "CRC" "ECS" "HN" "HPB" "KIDN" "LUNG" "MEL" "PROST" "TEST" "THY" "
		local gender = "males"
	}
	else if (`gender_bool' == 2){
		local diseases " "ALL" "BLAD" "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "THY" "
		local gender = "females"
	}
	
	capture file close fig6_`gender'
	file open fig6_`gender' using "`combined_figure_path'\Figure 6 - change PLOLE vs PLOLE 2019 by stage\Fig6_`gender'.txt", write replace
	file write fig6_`gender' "Disease" _tab "LOLE localized 2019" _tab "change" _tab "PLOLE localized 2019" _tab "change" ///
									   _tab "LOLE regional 2019" _tab "change" _tab "PLOLE regional 2019" _tab "change" ///
									   _tab "LOLE distant 2019" _tab "change" _tab "PLOLE distant 2019" _tab "change" _n
	foreach dis in `diseases'{
		file write fig6_`gender' "`dis'"
		foreach stage_num in "1" "2" "3"{
			use "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\\`dis'\results_`dis'_CLOLE_multiple_with_CI_with_stage", replace
			summarize ll_0 if jaar == 1989 & geslacht == `gender_bool' & age == 65 & stage`stage_num' == 1
			local LOLE1989 = (r(mean))
			summarize ll_0 if jaar == 2019 & geslacht == `gender_bool' & age == 65 & stage`stage_num' == 1
			local LOLE2019 = (r(mean))
			
			local change = `LOLE2019' - `LOLE1989'
			
			summarize survexp_0 if jaar == 1989 & geslacht == `gender_bool' & age == 65 & stage`stage_num' == 1
			local survexp1989 = (r(mean))
			summarize survexp_0 if jaar == 2019 & geslacht == `gender_bool' & age == 65 & stage`stage_num' == 1
			local survexp2019 = (r(mean))
			
			local PLOLE1989 = `LOLE1989'/`survexp1989'
			local PLOLE2019 = `LOLE2019'/`survexp2019'
			local PLOLEchange = `PLOLE2019' - `PLOLE1989'
			
			file write fig6_`gender' _tab "`LOLE2019'" _tab "`change'" _tab "`PLOLE2019'" _tab "`PLOLEchange'"
		}
		file write fig6_`gender' _n
	}
	file close fig6_`gender'
}

/* Figure 7 CPLOLE for 3 calendar years */
graph combine CPLOLE_ALL_Males_without_stage.gph CPLOLE_BLAD_Males_without_stage.gph CPLOLE_CERV_Males_without_stage.gph ///
		CPLOLE_CNS_Males_without_stage.gph CPLOLE_CRC_Males_without_stage.gph CPLOLE_ECS_Males_without_stage.gph ///
		CPLOLE_ENDO_Males_without_stage.gph CPLOLE_FBRE_Males_without_stage.gph CPLOLE_HN_Males_without_stage.gph, ///
		col(9) name("Fig7a", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine CPLOLE_ALL_Females_without_stage.gph CPLOLE_BLAD_Females_without_stage.gph CPLOLE_CERV_Females_without_stage.gph ///
		CPLOLE_CNS_Females_without_stage.gph CPLOLE_CRC_Females_without_stage.gph CPLOLE_ECS_Females_without_stage.gph ///
		CPLOLE_ENDO_Females_without_stage.gph CPLOLE_FBRE_Females_without_stage.gph CPLOLE_HN_Females_without_stage.gph, ///
		col(9) name("Fig7b", replace) imargin(-7 3 0 0) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine CPLOLE_HPB_Males_without_stage.gph CPLOLE_KIDN_Males_without_stage.gph CPLOLE_LUNG_Males_without_stage.gph ///
		CPLOLE_MEL_Males_without_stage.gph CPLOLE_OFT_Males_without_stage.gph CPLOLE_PROST_Males_without_stage.gph ///
		CPLOLE_SCC_Males_without_stage.gph CPLOLE_TEST_Males_without_stage.gph CPLOLE_THY_Males_without_stage.gph, ///
		col(9) name("Fig7c", replace) imargin(-5 2 -11 -4) graphregion(color(white)) iscale(3.6) /// // imargin: left right bottom top
		xcommon ycommon xsize(12) ysize(1.9)
graph combine CPLOLE_HPB_Females_without_stage.gph CPLOLE_KIDN_Females_without_stage.gph CPLOLE_LUNG_Females_without_stage.gph ///
		CPLOLE_MEL_Females_without_stage.gph CPLOLE_OFT_Females_without_stage.gph CPLOLE_PROST_Females_without_stage.gph ///
		CPLOLE_SCC_Females_without_stage.gph CPLOLE_TEST_Females_without_stage.gph CPLOLE_THY_Females_without_stage.gph, ///
		col(9) name("Fig7d", replace) imargin(-7 1 -5 -5) graphregion(color(white)) iscale(3.6) ///
		xcommon ycommon xsize(12) ysize(1.9)
graph combine Fig7a Fig7b Fig7c Fig7d, ///
		col(1) graphregion(color(white)) l1(Proportion of life lost (%)) ///
		b1(Years survived after diagnosis) name("Fig7", replace) xsize(10) ysize(6) iscale(0.1)
graph export "`combined_figure_path'\Figure 7 - CPLOLE\Fig7.emf", replace