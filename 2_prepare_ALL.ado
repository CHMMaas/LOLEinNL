*------------------------------------------------------------------------------*
* This script selects patients with all cancers combined-----------------------*
*------------------------------------------------------------------------------*

*-------------------------------*
*** Install relevant packages ***
*-------------------------------*

* tell Stata to never pause
set more off, perm  
* style of decimal point is a comma
set dp comma, perm

capture program drop prepare_ALL
program prepare_ALL
args bool_stage data_path results_data_path disease
capture drop *

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open selected patients */	use "`data_path'\\patient_data.dta", clear
								display _N

/* BLAD */						keep if tumsoort==712310 | tumsoort==712320 | tumsoort==713310 | ///
								tumsoort==713330 | tumsoort==713340 | ///
								tumsoort==719310 | tumsoort==719330 | /// 
/* CERV */						(tumsoort==603300 & gesl == 2) | ///
/* CNS */						tumsoort==961300 | tumsoort==961310 | ///
								tumsoort==962300 | tumsoort==962310 | tumsoort==963310 | ///
								tumsoort==963320 | tumsoort==963330 | tumsoort==964310 | ///
								tumsoort==964320 | tumsoort==964330 | tumsoort==966300 | ///
								tumsoort==966310 | ///
/* CRC */						tumsoort==205310 | tumsoort==205320 | ///
								tumsoort==205330 | tumsoort==205340 | ///
/* ECS */						tumsoort==201310 | ///
								tumsoort==201320 | tumsoort==202300 | tumsoort==203300 | ///
/* ENDO */						(tumsoort==604300 & gesl == 2) | ///
/* FBRE */ 						(tumsoort==501300 & gesl == 2) | /// 
/* HN */ 						tumsoort==101300 | tumsoort==102310 | ///
								tumsoort==102320 | tumsoort==102330 | tumsoort==102340 | ///
								tumsoort==102350 | tumsoort==103310 | tumsoort==103320 | ///
								tumsoort==103330 | tumsoort==103340 | tumsoort==104310 | ///
								tumsoort==104320 | tumsoort==105310 | tumsoort==105320 | ///
								tumsoort==105340 | tumsoort==105350 | tumsoort==105360 | ///
								tumsoort==106310 | tumsoort==106320 | tumsoort==106330 | ///
								tumsoort==106340 | tumsoort==107310 | ///
/* HPB */ 						tumsoort==207310 | tumsoort==207320 | ///
								tumsoort==208310 | tumsoort==208320 | tumsoort==209310 | ///
								tumsoort==209320 | tumsoort==208330 | tumsoort==208340 | ///
								tumsoort==208350 | tumsoort==208360 | ///
/* KIDN */ 						tumsoort==711310 | ///
/* LUNG */						tumsoort==302310 | tumsoort==302320 | ///
								tumsoort==302330 | tumsoort==302340 | tumsoort==302350 | ///
/* MEL */						tumsoort==441310 | tumsoort==441320 | ///
								tumsoort==441330 | tumsoort==441340 | tumsoort==441350 | ///
/* OFT */						((tumsoort==606310 | tumsoort==606320 | tumsoort==606340) & gesl == 2) | ///
/* PROST */						(tumsoort==702300 & gesl == 1) | ///
/* SCC */ 						tumsoort==403310 | tumsoort==403330 | tumsoort==403320 | ///
/* TEST */						((tumsoort==703310 | tumsoort==703320) & gesl == 1) | ///
/* THY */						tumsoort==901310 | tumsoort==901320 | ///
								tumsoort==901330 | tumsoort==901340 | tumsoort==901350
								display _N							
								
/* compress */					quietly compress	
								save "`results_data_path'\\`disease'_descriptives_`bool_stage'.dta", replace
end