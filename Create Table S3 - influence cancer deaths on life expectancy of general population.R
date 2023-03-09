###
### Descriptive Statistics
### Author: C. Maas
###

# clear history
rm(list = ls(all.names=TRUE))
if(!is.null(dev.list())) dev.off()
cat('\014')

# set parameters
file.path <- "G:/IKNL/Registratie en Onderzoek/Onderzoek/projecten lopend/LOLE/Hoog-over/Results/Review/Cancer deaths"
diseases <- c("ALL", "BLAD", "CERV", 
              "CNS", "CRC", "ECS", "ENDO", "FBRE", 
              "HN", "HPB", 
              "KIDN", "LUNG", "MEL", "OFT", "PROST", 
              "SCC", "TEST", "THY")
all.results <- c()
for (disease in diseases){
  unadjusted <- as.data.frame(read.delim(paste0(file.path, "/LOLE_", disease, "_unadjusted.txt")))
  adjusted <- as.data.frame(read.delim(paste0(file.path, "/LOLE_", disease, "_adjusted.txt")))
  merge <- cbind(unadjusted[, c("Disease", "Gender", "Year", "Age")],
                 as.numeric(unadjusted$LE_unadjusted), 
                 as.numeric(adjusted$LE_adjusted),
                 as.numeric(unadjusted$LE_unadjusted)-as.numeric(adjusted$LE_adjusted),
                 as.numeric(unadjusted$LOLE_unadjusted),
                 as.numeric(adjusted$LOLE_adjusted),
                 as.numeric(unadjusted$LOLE_unadjusted)-as.numeric(adjusted$LOLE_adjusted))
  all.results <- rbind(all.results, merge)
}
colnames(all.results) <- c("Disease", "Gender", "Year", "Age", 
                           "LE_unadjusted", "LE_adjusted", "LE_diff", 
                           "LOLE_unadjusted", "LOLE_adjusted", "LOLE_diff")
all.results <- all.results[!is.na(all.results$LE_unadjusted),]

openxlsx::write.xlsx(all.results, 
                     file=paste0(file.path, "/Adjusting for cancer deaths.xlsx"), 
                     asTable=FALSE, overwrite=TRUE, rowNames=FALSE, sheetName="Comparison")