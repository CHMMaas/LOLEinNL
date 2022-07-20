*------------------------------------------------------------------------------*
* This script prepares the general population, patient data, fits flexible ----*
* parametric survival model, makes predictions, creates figures, and performs -*
* sensitivity analysis --------------------------------------------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop run_analysis
program run_analysis
args path_ado_files data_path results_data_path SA_path ///
		disease start_year end_year max_fupdat 	 		///
		min_age max_age max_CBS_age 			 		///
		df_spline_year df_spline_age df_baseline 		///
		df_TD time_of_cure 						 		///
		max_since_years step 					 		///
		bool_CI bool_stage 						 		///
		year1 year2 year3 year4 				 		///
		age1 age2 age3 age4 					 		///
		bool_SA spline_min spline_max 			 		///
		baseline_min baseline_max 				 		///
		TD_min TD_max
capture drop * 

/* Check user input */
display "Check these directories exist:"
display "Directory code:     `path_ado_files'"
display "Directory data:     `data_path'"
display "Directory results:  `results_data_path'"
display "Directory SA:       `SA_path'"

display "Check parameters:"
display "Current disease:    `disease'"
display "Starting year:      `start_year'"
display "Ending year:        `end_year'"
display "Maximum follow-up:  `max_fupdat'"
display "Minimum age:        `min_age'"
display "Maximum age:        `max_age'"
display "Maximum age CBS:    `max_CBS_age'"
display "Df year at diag.:   `df_spline_year'"
display "Df age at diag.:    `df_spline_age'"
display "Df baseline hazard: `df_baseline'"
display "Df time-dependent:  `df_TD'"
display "Time of cure:       `time_of_cure'"
display "Max CLOLE:          `max_since_years'"
display "In steps of:        `step'"
display "Compute CI:         `bool_CI'"
display "Add stage to model: `bool_stage'"
display "Years in results:   `year1', `year2', `year3', `year4'"
display "Ages in results:    `age1', `age2', `age3', `age4'"

display "Check parameters of sensitivity analysis:"
display "Perform SA:         `bool_SA'"
display "Min. df age year:   `spline_min'"
display "Max. df age year:   `spline_max'"
display "Min. df baseline:   `baseline_min'"
display "Max. df baseline:   `baseline_max'"
display "Min. df time-dep:   `TD_min'"
display "Max. df time-dep:   `TD_max'" 

/* Directory that is the same for all diseases: */
local strs_path = "G:\IKNL\Registratie en Onderzoek\stata\strs"

/* Prepare general population
   do not smooth general population */
// quietly cd "`path_ado_files'"
// run 1_prepare_general_population.ado
// prepare_general_population "0" "`max_CBS_age'" "`strs_path'"

// /* Select patient population */
// quietly cd "`path_ado_files'"
// run 2_prepare_patient_data.ado
// prepare_patient_data "`data_path'" "`results_data_path'" 			///
// 						"`start_year'" "`end_year'" "`max_fupdat'" 	///
// 						"`min_age'" "`max_age'" "`disease'"

// /* prepare disease specific data */
// display "Select specific disease"
// quietly cd "`path_ado_files'"
// run 2_prepare_`disease'.ado
// prepare_`disease' "`bool_stage'" "`data_path'" "`results_data_path'" "`disease'"
//
// /* set survival data */
// quietly cd "`path_ado_files'"				
// run 3_prepare_disease_specific_data.ado
// prepare_disease_specific_data "`bool_stage'" "`max_CBS_age'" 			///
// 								"`strs_path'" "`results_data_path'"  	///
// 								"`spline_min'" "`spline_max'" 			///
// 								"`time_of_cure'" "`disease'"
//
// /* create file with artificial patients to estimate predictions for */
// quietly cd "`path_ado_files'"
// run 4_create_predict_file.ado
// create_predict_file "`max_since_years'" "`bool_CI'" "`bool_stage'" "`spline_min'" "`spline_max'" "`strs_path'" ///
// 				"`results_data_path'" "`disease'" ///
// 				"`start_year'" "`end_year'" "`min_age'" "`max_age'"

if ("`bool_SA'" == "no"){
// 	/* Fit flexible parametric survival model and make predictions */ 
// 	quietly cd "`path_ado_files'"
// 	run 5_LOLE_analysis.ado
//	
// 	if (`max_since_years' == 0) {
// 		/* LOLE */
// 		LOLE_analysis "0" "`bool_CI'" "`bool_stage'" "`df_spline_year'" "`df_spline_age'" "`df_baseline'" "`df_TD'" ///
// 					"`max_CBS_age'" "`max_fupdat'" 					///
// 					"`strs_path'" "`results_data_path'" "`path_ado_files'" "`disease'" ///
// 					"`age1'" "`age2'" "`age3'" "`age4'" 			///
// 					"`min_age'" "`max_age'" 						///
// 					"`year1'" "`year2'" "`year3'" "`year4'" 		///
// 					"`start_year'" "`end_year'" "`max_since_years'" "single"
// 	}
// 	else if (`max_since_years' > 0) {
// 		/* Conditional LOLE */
// 		forval i = 0(`step')`max_since_years'{
// 		    display "`i'-year conditional LOLE"
// 			LOLE_analysis "`i'" "`bool_CI'" "`bool_stage'" "`df_spline_year'" "`df_spline_age'" "`df_baseline'" "`df_TD'" ///
// 					"`max_CBS_age'" "`max_fupdat'" 				///
// 					"`strs_path'" "`results_data_path'" "`path_ado_files'" "`disease'" ///
// 					"`age1'" "`age2'" "`age3'" "`age4'" 		///
// 					"`min_age'" "`max_age'" 					///
// 					"`year1'" "`year2'" "`year3'" "`year4'" 	///
// 					"`start_year'" "`end_year'" "`max_since_years'" "multiple"
// 		}
// 	}
	
	/* Make figures */
	quietly cd "`path_ado_files'"
	run 6_make_figures_LOLE.ado
	make_figures_LOLE "`disease'" "`bool_CI'" "`bool_stage'" 	///
				"`age1'" "`age2'" "`age3'" "`age4'" 			///
				"`min_age'" "`max_age'" 						///
				"`year1'" "`year2'" "`year3'" "`year4'"			///
				"`start_year'" "`end_year'" 					///
				"`results_data_path'" 							///
				"`max_since_years'" "`step'"
}
else if ("`bool_SA'" == "yes"){
    /* Sensitivity analysis */
	quietly cd "`path_ado_files'"
	run 7_sensitivity_analysis.ado
	sensitivity_analysis "`baseline_min'" "`baseline_max'" 	///
				"`spline_min'" "`spline_max'" 				///
				"`TD_min'" "`TD_max'" 						///
				"`df_spline_year'" "`df_spline_age'" 		///
				"`df_baseline'" "`df_TD'" 					///
				"`max_CBS_age'" "`max_fupdat'" "without_CI" ///
				"`bool_stage'" "`strs_path'"				/// 
				"`results_data_path'" "`SA_path'" 			///
				"`path_ado_files'" "`disease'" 				///
				"`age1'" "`age2'" "`age3'" "`age4'" 		///
				"`start_year'" "`end_year'"	
}

end