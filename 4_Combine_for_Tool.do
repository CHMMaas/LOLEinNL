local dis = "BLAD"
use "G:/IKNL/Registratie en Onderzoek/Onderzoek/projecten lopend/LOLE/Hoog-over/`dis'/results_`dis'_CLOLE_multiple_with_CI_with_stage.dta", clear
gen type = "`dis'"
local data_path = "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Data"
save "`data_path'\file_for_tool.dta", replace

capture drop type
gen type = ""
local diseases " "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "PROST" "SCC" "TEST" "THY" "ALL" "
use "`data_path'\file_for_tool.dta", clear
foreach dis in `diseases'{
	if ("`dis'" == "SCC"){
		append using "G:/IKNL/Registratie en Onderzoek/Onderzoek/projecten lopend/LOLE/Hoog-over/`dis'/results_`dis'_CLOLE_multiple_with_CI_without_stage.dta", nolabel
	} 
	else{
		if ("`dis'" == "SCC"){
			
		}
		append using "G:/IKNL/Registratie en Onderzoek/Onderzoek/projecten lopend/LOLE/Hoog-over/`dis'/results_`dis'_CLOLE_multiple_with_CI_with_stage.dta", nolabel
	}
    replace type = "`dis'" if mi(type)
}

save "`data_path'\file_for_tool.dta", replace