#!/usr/bin/Rscript


args<-commandArgs(TRUE)
country <- "China"

#----------------------------------------Block for calculate impacts simulation------------------------------------------#

effs <- c(0.40, 0.60, 0.80)
covs <- c(0.30, 0.70)
waning <- c(10, 20)
states <- c('S', 'L', 'LR', 'SLR')
vaccines <- c('E_p', 'E_q', 'E_rl', 'E_rs_E_rdef_E_rn', 'E_rl_E_p_E_rs_E_rdef_E_rn_E_q')
vaccines_aux <- c('E_p', 'E_q', 'E_rl', 'E_relapse', 'All')
Vac_text <- c('Fast progression', 'Exogenous reactivation', 'Endogenous reactivation', 'Relapse', 'All')
#age <- 12

for(cm_mod in c(1,3)){
    index <- 1
    plot_list <- list()
    cmmod=cm_mod
    for(vaccine in vaccines){
        #Adol
        dpA <- read.table(paste0("Data_plots/Impactos/impacto_", country, "_", 3, "_", cmmod, "_", vaccine, ".txt"), header=T)
        dpA$waning <- as.factor(dpA$waning)
        dpA$axisx <- paste0(dpA$state)
        
        dpA$vac <- rep(vaccines_aux[index], length(dpA$n))
        dpA$axisx <- NULL
        dpA <- dpA[, c("n", "age", "vac", "state", "e", "cov", "waning", "impact", "impact_low", "impact_hi", "irr", "irr_low", "irr_hi")]
        
        
        #elder
        dpE <- read.table(paste0("Data_plots/Impactos/impacto_", country, "_", 12, "_", cmmod, "_", vaccine, ".txt"), header=T)
        dpE$waning <- as.factor(dpE$waning)
        dpE$axisx <- paste0(dpE$state)
        
        dpE$vac <- rep(vaccines_aux[index], length(dpE$n))
        dpE$axisx <- NULL
        dpE <- dpE[, c("n", "age", "vac", "state", "e", "cov", "waning", "impact", "impact_low", "impact_hi", "irr", "irr_low", "irr_hi")]
         
        #Surpasses?
        dpA$AsurpE <- dpA$irr > dpE$irr
        dpE$AsurpE <- dpA$irr > dpE$irr
        
        dpA$AsurpE[dpA$AsurpE==TRUE] = 1
        dpA$AsurpE[dpA$AsurpE==FALSE] = 0
        
        dpE$AsurpE[dpA$AsurpE==TRUE] = 1
        dpE$AsurpE[dpA$AsurpE==FALSE] = 0
         
        #save
        if(index==1){
            write.table(dpA, paste0("Data/impacto_all_info_", country, "_", 3, "_", cmmod, ".txt"), row.names = F, quote = F)
            
            write.table(dpE, paste0("Data/impacto_all_info_", country, "_", 12, "_", cmmod, ".txt"), row.names = F, quote = F)
            
        } else{
            write.table(dpA, paste0("Data/impacto_all_info_", country, "_", 3, "_", cmmod, ".txt"), col.names = F, row.names = F, quote = F, append=T)
            
            write.table(dpE, paste0("Data/impacto_all_info_", country, "_", 12, "_", cmmod, ".txt"), col.names = F, row.names = F, quote = F, append=T)
        }
        index <- index + 1
    }
}

