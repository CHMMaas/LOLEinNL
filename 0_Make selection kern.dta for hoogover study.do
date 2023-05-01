*-------------------------------------------------------------*
***** Analysis of NCR data during the period 1989 to 2018 ***** OP BASIS VAN KERN
*-------------------------------------------------------------*

set more off, perm

*----------------------------*
***** SELECTION CRITERIA *****
*----------------------------*

/* open dataset */				use "G:\IKNL\Registratie en Onderzoek\onderzoeksbestanden\STATAData\RANK\Kern\kern.dta", clear

/* keep period 1989-2019 */		drop if incjr>2019
/* keep complete records */		drop if regstat==9
/* keep NL */					drop if nl_incl==0
/* drop hermaphrodite */		drop if gesl==3
/* keep only DIA and OBD */		keep if inlist(epis,"DIA","OBD")

/* tumorsoort label */			run "G:\IKNL\Registratie en Onderzoek\stata\OMZET\label_tumsoort.do" 	/* labels tumorsoort */
								lab val tumsoort tslbl
								
/* drop BCC */					drop if tumsoort==401300
/* drop DCIS */					drop if tumsoort==502200								

/* create stage groups */		merge 1:m eid using "G:\IKNL\Registratie en Onderzoek\stata\tumor_dia.dta", keepusing(ess_tnm)
								drop if _merge==2
								drop _merge
								
								lab def esslbl 1 "T1/T2" 2 "T3/T4" 3 "N+" 4 "M1" 9 "Unknown"
								lab val ess esslbl
								
								capture drop stage 
								gen byte stage = 9
								replace stage = 0 if inlist(ess,1,2)
								replace stage = 1 if ess==3
								replace stage = 2 if ess==4
								lab def stagelbl 0 "Localized" 1 "Regional" 2 "Distant" 9 "Unknown", modify
								lab val stage stagelbl 
								lab var stage "Stage at diagnosis"
								
								drop ess
								
/* compress dataset */			compress

/* keep vars */					keep rn zid eid incjr epis1 epis gesl gebdat leeft ovldat vit_stat_dat vit_stat vit_stat_int incdat topo morf gedrag diffgrad tumsoort diag_basis stage

/* create grade groups */		merge 1:m eid using "G:\IKNL\Registratie en Onderzoek\stata\tumor_dia.dta", keepusing(diff stadium)
								drop if _merge==2
								drop _merge
								
								replace stadium="X"
								replace stadium="Graad 1" if diff==1
								replace stadium="Graad 2" if diff==2
								replace stadium="Graad 3" if diff==3
								replace stadium="Graad 4" if diff==4
								replace stadium="Graad 1" if inlist(morf,9161,9350,9351,9352,9361,9383,9384,9412,9413,9421,9431,9432,9492,9493,9509,9582)
								replace stadium="Graad 1" if gedrag==0 & inlist(morf,8000,9390,9490,9530,9531,9532,9533,9534,9535,9537,9540,9560)
								replace stadium="Graad 1" if gedrag==1 & inlist(morf,8680,8693,9505)
								*! Myxopapillair ependymoom (9394) van graad 1 naar graad 2 in nieuwe WHO-classificatie
								replace stadium="Graad 2" if inlist(morf,9391,9393,9394,9425,9444,9506) | (gedrag==1 & morf==9390)
								replace stadium="Graad 2" if diff==1 & inlist(morf,9382,9400,9410,9411,9420,9450)
								replace stadium="Graad 3" if diff==9 & inlist(morf,9392,9401,9451)
								replace stadium="Graad 3" if gedrag==3 & inlist(morf,9390,9505,9530,9538)
								replace stadium="Graad 3" if diff==4 & inlist(morf,9382,9401,9450,9451)
								replace stadium="Graad 4" if inlist(morf,9440,9441,9442,9470,9471,9472,9473,9474,9475,9476,9477,9478,9508)
								replace stadium="Graad 4" if gedrag==3 & inlist(morf,9490,9500,9501)
								
								rename stadium grade 
								lab var grade "Tumor grade"
								
								replace grade = "Graad 1/2" if inlist(grade,"Graad 1","Graad 2")
								replace grade = "Onbekend" if grade=="X"
								
								drop diff
								
								save "G:\IKNL\Registratie en Onderzoek\Onderzoek\projecten lopend\LOLE\Hoog-over\Data\kern1508.dta", replace


