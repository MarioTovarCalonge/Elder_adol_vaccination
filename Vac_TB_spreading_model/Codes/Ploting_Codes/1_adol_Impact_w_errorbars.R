#!/usr/bin/Rscript

args<-commandArgs(TRUE)
country <- "China"

#------------------------------------------------------------------------------------------------------------------------------------#

#----------------------------------------Block for calculate impacts simulation------------------------------------------#

scaling <- 1000000
auxPath <- path.expand("~")
e = 0.80
cov = 0.70
waning <- c(10, 20)
states <- c('S', 'L', 'LR', 'SLR')
vaccines <- c('E_p', 'E_q', 'E_rl', 'E_rs_E_rdef_E_rn', 'E_rl_E_p_E_rs_E_rdef_E_rn_E_q')

age <- 3
age_mod <- age

miniter <- 1
maxiter <- 500
saved_impact <- numeric( maxiter - miniter )
saved_IRR <- numeric( maxiter - miniter )

for(cm_mod in c(1,3)){
    con_mod=cm_mod
    for(vaccine in vaccines){
        sent = 1
        fileout <- paste0("Data_plots/Impactos/impacto_", country, "_", age_mod, "_", cm_mod, "_", vaccine, ".txt")
        for(state in states){
            for(w in waning){
                e_prime = 1
                c_prime = e*cov
                        
                print("Reading outputs\n")
                pb <- txtProgressBar(min = 1, max = (maxiter - miniter), style = 3)
                for(iter in miniter:maxiter){
                    index = iter - miniter + 1
                            
                    path_base <- paste0(auxPath, "/TB_SIM_OUT/", country, '_cm_', con_mod, '/Vaccines/TBlock_', vaccine, '/',
                                sprintf("T_%d-E_%.2f-C_%.2f-W_%.2f-", age, e_prime, c_prime, w), state,
                                '/Iters/Output_vaccine_It_', sprintf("%03d", index), '.txt')
                            
                    dat <- read.table(path_base, header=T)
                    i <- dat$inc_annual
                    imp <- dat$inc_acum

                    i_vac <- dat$inc_vac_annual
                    imp_vac <- dat$inc_vac_acum
                         
                    saved_impact[index] = (imp[length(imp)] - imp_vac[length(imp)])/imp[length(imp)]*100
                    saved_IRR[index] = (i[length(i)] - i_vac[length(i)])/i[length(i)]*100

                    setTxtProgressBar(pb, index)
                }
                close(pb)

                impact_low <- quantile(saved_impact, .025)
                impact_up <- quantile(saved_impact, .975)
                impact_median <- quantile(saved_impact, .5)
                            
                IRR_low <- quantile(saved_IRR, .025)
                IRR_up <- quantile(saved_IRR, .975)
                IRR_median <- quantile(saved_IRR, .5)
                        
                if(sent==1){
                    line <- paste0("n age state e cov waning impact impact_low impact_hi irr irr_low irr_hi")
                    write(line, fileout)
                            
                    line <- sprintf("1 %d %s %.2f %.2f %d %f %f %f %f %f %f", age, state, e, cov, w, impact_median, impact_low, impact_up, IRR_median, IRR_low, IRR_up)

                    write(line, fileout, append=T)
                    sent = 0
                } else{
                    aux <- read.table(fileout, header=FALSE)
                    l <- length(aux$V1)
                    line <- sprintf("%d %d %s %.2f %.2f %d %f %f %f %f %f %f", l, age, state, e, cov, w, impact_median, impact_low, impact_up, IRR_median, IRR_low, IRR_up)

                    write(line, fileout, append=T)
                }
                    
            }
        }

    }
}


    
    
    

