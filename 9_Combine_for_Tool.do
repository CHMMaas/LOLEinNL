local dis = "BLAD"
use #, clear
gen type = "`dis'"
local data_path = #
save "`data_path'\file_for_tool.dta", replace

capture drop type
gen type = ""
local diseases " "CERV" "CNS" "CRC" "ECS" "ENDO" "FBRE" "HN" "HPB" "KIDN" "LUNG" "MEL" "OFT" "PROST" "TEST" "THY" "ALL" "
use "`data_path'\file_for_tool.dta", clear
foreach dis in `diseases'{
	display "`dis'\results_`dis'_CLOLE_multiple_with_CI_with_stage.dta"
	append using #, nolabel
    replace type = "`dis'" if mi(type)
}

append using "#\results_SCC_CLOLE_multiple_with_CI_with_stage.dta", nolabel
replace type = "SCC" if mi(type)

save "`data_path'\file_for_tool.dta", replace
