#!/usr/bin/Rscript

library(ggplot2)
library(cowplot)
library(grid)
library(gridExtra)
library(Cairo)
pdf(NULL)

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

plot_list10 <- list()
plot_list10e <- list()
index <- 1

data_plotM1 <- read.table(paste0("Data/impacto_all_info_", country, "_", 3, "_", 1, ".txt"), header=T)
data_plotM3 <- read.table(paste0("Data/impacto_all_info_", country, "_", 3, "_", 3, ".txt"), header=T)

data_plotM1e <- read.table(paste0("Data/impacto_all_info_", country, "_", 12, "_", 1, ".txt"), header=T)
data_plotM3e <- read.table(paste0("Data/impacto_all_info_", country, "_", 12, "_", 3, ".txt"), header=T)

#######
label_vac <- c(bquote(E[p]), bquote(E[q]), bquote(E[rl]), bquote(E[relapse]), 'All')
#######

for(state in states){
    target_pop <- state
    
    #Adol
    df_st_M1_w10 <- subset(data_plotM1, waning==20 & state==target_pop)
    df_st_M1_w10$cmod <- as.factor(rep('Pairwise correction', length(Vac_text)))
    
    df_st_M3_w10 <- subset(data_plotM3, waning==20 & state==target_pop)
    df_st_M3_w10$cmod <- as.factor(rep('Intrinsic connectivity', length(Vac_text)))
    
    df_st_w10 <- rbind(df_st_M1_w10, df_st_M3_w10)
    
    tagw10 <- paste0("Vaccine waning=", 20, " years")

    Impact_bar_w10 <- ggplot(data=df_st_w10, aes(x=vac, y=irr, fill=cmod)) +
                    geom_bar(colour="black", stat="identity", position=position_dodge()) +
                        
                    geom_errorbar(aes(x=vac, ymax = irr_hi, ymin = irr_low), position=position_dodge(width=0.9), width = .3, size=.8) +
                        
                    #scale_fill_manual(values=c("#999999",  "#56B4E9")) +
                    #scale_fill_manual(values=c("darkgoldenrod2",  "purple2")) +
                    scale_fill_manual(values=c("#DCBAF4",  "#682DC4")) +
                    scale_x_discrete(limits=c('E_p', 'E_q', 'E_rl', 'E_relapse', 'All'), labels=label_vac) +
                    theme_minimal() +
                    theme(text = element_text(size=18, family='serif'), legend.position='top', plot.subtitle = element_text(size=16, hjust=0.5)) +
                    labs(x = "", y = "", fill="", subtitle = "15-19y")
                              
    plot_list10[[index]] <- Impact_bar_w10
    
    #Elder
    df_st_M1_w10e <- subset(data_plotM1e, waning==20 & state==target_pop)
    df_st_M1_w10e$cmod <- as.factor(rep('Pairwise correction', length(Vac_text)))
    
    df_st_M3_w10e <- subset(data_plotM3e, waning==20 & state==target_pop)
    df_st_M3_w10e$cmod <- as.factor(rep('Intrinsic connectivity', length(Vac_text)))
    
    df_st_w10e <- rbind(df_st_M1_w10e, df_st_M3_w10e)
    
    
    Impact_bar_w10e <- ggplot(data=df_st_w10e, aes(x=vac, y=irr, fill=cmod)) +
                    geom_bar(colour="black", stat="identity", position=position_dodge()) +
                        
                    geom_errorbar(aes(x=vac, ymax = irr_hi, ymin = irr_low), position=position_dodge(width=0.9), width = .3, size=.8) +
                        
                    #scale_fill_manual(values=c("darkgoldenrod2",  "purple2")) +
                    scale_fill_manual(values=c("#DCBAF4",  "#682DC4")) +
                    scale_x_discrete(limits=c('E_p', 'E_q', 'E_rl', 'E_relapse', 'All'), labels=label_vac) +
                    theme_minimal() +
                    theme(text = element_text(size=18, family='serif'), legend.position='top', plot.subtitle = element_text(size=16, hjust=0.5)) +
                    labs(x = "", y = "", fill="", subtitle = "60-64y")
                              
    plot_list10e[[index]] <- Impact_bar_w10e
    index <- index + 1

}

#Common axis
y.grob <- textGrob("IRR (%)", gp=gpar(fontface="bold", col="black", fontsize=17), rot=90)
x.grob <- textGrob("Type of vaccine", gp=gpar(fontface="bold", col="black", fontsize=17))

#Columna izquierda -> adol w10
plot1 <- plot_list10[[1]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 40)
plot2 <- plot_list10[[2]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 15)
plot3 <- plot_list10[[3]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 15)
plot4 <- plot_list10[[4]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 45)

#Columna dcha -> elder w10
p1 <- plot_list10e[[1]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 40)
p2 <- plot_list10e[[2]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 15)
p3 <- plot_list10e[[3]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 15)
p4 <- plot_list10e[[4]] + theme(legend.position="none", axis.title.y = element_blank()) + ylim(0, 45)

#Extract the legend grob from one of those objects.
grobs <- ggplotGrob(plot_list10[[1]])$grobs
legend <- grobs[[which(sapply(grobs, function(x) x$name) == "guide-box")]]

#Susceptibles
pl1 <- plot_grid(plot1, NULL, p1, align='vh', ncol = 3, scale = 1, rel_widths=c(1, .1, 1), labels = c('A', '', 'B'), label_size = 15, hjust = -0.5, vjust = 1.4)
#title <- ggdraw() + draw_label(paste0("Efficacy before infection (S)"), fontface = 'bold', x = 0.01, hjust = 0)
title <- ggdraw() + draw_label(paste0("Efficacy before infection (S)"), fontfamily = "serif", fontface = 'bold', color='#09828E', x = 0.01, hjust = 0)
pl1 <- plot_grid(title, pl1, ncol = 1, rel_heights = c(0.1, 1))


#Latentes
pl2 <- plot_grid(plot2, NULL, p2, align='vh', ncol = 3, scale = 1, rel_widths=c(1, .1, 1), labels = c('C', '', 'D'), label_size = 15, hjust = -0.5, vjust = 1.4)
#title <- ggdraw() + draw_label(paste0("Efficacy after infection (L)"), fontface = 'bold', x = 0.01, hjust = 0)
title <- ggdraw() + draw_label(paste0("Efficacy after infection (L)"), fontfamily = "serif", fontface = 'bold', color='#09828E', x = 0.01, hjust = 0)
pl2 <- plot_grid(title, pl2, ncol = 1, rel_heights = c(0.1, 1))


#L & R
pl3 <- plot_grid(plot3, NULL, p3, align='vh', ncol = 3, scale = 1, rel_widths=c(1, .1, 1), labels = c('E', '', 'F'), label_size = 15, hjust = -0.5, vjust = 1.5)
#title <- ggdraw() + draw_label(paste0("Efficacy after infection & recovery (L+R)"), fontface = 'bold', x = 0.01, hjust = 0)
title <- ggdraw() + draw_label(paste0("Efficacy after infection & recovery (L+R)"), fontfamily = "serif", fontface = 'bold', color='#09828E', x = 0.01, hjust = 0)
pl3 <- plot_grid(title, pl3, ncol = 1, rel_heights = c(0.1, 1))


#ALL
pl4 <- plot_grid(plot4, NULL, p4, align='vh', ncol = 3, scale = 1, rel_widths=c(1, .1, 1), labels = c('G', '', 'H'), label_size = 15, hjust = -0.5, vjust = 1.4)
title <- ggdraw() + draw_label(paste0("Efficacy before & after infection (All)"), fontfamily = "serif", fontface = 'bold', color='#09828E', x = 0.01, hjust = 0)
#title <- ggdraw() + draw_label(paste0("Efficacy before & after infection (All)"), fontface = 'bold', x = 0.01, hjust = 0)
pl4 <- plot_grid(title, pl4, ncol = 1, rel_heights = c(0.1, 1))



#Construyo el plot por columnas
#Horizontal
pcol <- plot_grid(pl1, NULL, pl2, pl3, NULL, pl4, ncol=3, rel_widths=c(1, .05, 1, 1, .05, 1))
# add legend
pgrid <- plot_grid(legend, pcol, ncol = 1, rel_heights = c(.06, 1))

#add to plot and save
pdf(paste0('CompW20', country, '.pdf'), width = 17, height = 10)
grid.arrange(arrangeGrob(pgrid, left = y.grob))
dev.off()




