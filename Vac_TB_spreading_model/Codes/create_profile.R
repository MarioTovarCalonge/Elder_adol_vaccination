#!/usr/bin/Rscript

#Crea un archivo que contiene el perfil de la vacuna que queremos testar en la población general.
#Requiere como parámetros: $eficacia $coverage $vacuna en población S, L o R y waning 10 o 20 años.

args<-commandArgs(TRUE)

eff <- as.numeric(args[1])
cov <- as.numeric(args[2])
target <- 3 #Old: 12, teenagers: 3
target_group <- args[3]
Harris_waning <- as.numeric(args[4])
waning <- 0.00

path_vaccine <- "../Inputs/General_Inputs/perfil.txt"

line <- sprintf("target = %d", target)
write(line, path_vaccine)
line <- sprintf("waning_harris = %f", Harris_waning)
write(line, path_vaccine, append=TRUE)
line <- "transition age S_L_R efficacy e_low e_hi coverage c_low c_hi waning w_low w_hi blocking b_low b_hi"
write(line, path_vaccine, append=TRUE)
line <- paste0("E_rl ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)
line <- paste0("E_p ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)
line <- paste0("E_rs ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)
line <- paste0("E_rdef ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)
line <- paste0("E_rn ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)
line <- paste0("E_q ", sprintf("%d ", target), target_group, " 1.0 1.0 1.0 ", sprintf("%.2f %.2f %.2f", eff*cov, eff*cov, eff*cov), sprintf(" %.2f %.2f %.2f", waning, waning, waning), " 0.0 0.0 0.0")
write(line, path_vaccine, append=TRUE)

