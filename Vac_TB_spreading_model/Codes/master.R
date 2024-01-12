#!/usr/bin/Rscript

if(!file.exists("fitter.so")){
    if(!file.exists("fitter.c")){
        print(paste0('Neither fitter.so nor fitter.c available in current directory. Raising error...'))
        stop()
    }
    print("Building fitter shared library..")
    system("R CMD SHLIB fitter.c")
}

if(!file.exists("R2C_runner.so")){
    if(!file.exists("R2C_runner.c")){
        print(paste0('Neither R2C_runner.so nor R2C_runner.c available in current directory. Raising error...'))
        stop()
    }
    print("Building runner shared library..")
    system("R CMD SHLIB R2C_runner.c")
}

dyn.load("fitter.so")
dyn.load("R2C_runner.so")
source("Functions.R")

args<-commandArgs(TRUE)
if(length(args)==2){
    country <- args[1]
    mode_contact <- as.integer(args[2])
    iter <- 0
    TB_file = paste0("../Inputs/Input_countries/", country, "/TB_burden.txt")
} else{
    stop("Error with arguments. They must be 1:Country and 2:Contact_mode")
}

available <- c(1, 0, 1, 2, 2, 3, 2, 1, 1, 1, 2, 1, 2, 1, 1, 2, 2, 2, 0, 2, 1, 2, 2, 2)
names(available) <- c('Bangladesh', 'Canada', 'China', 'Dem_Congo', 'Democratic_Republic_of_the_Congo', 'Ecuador', 'Ethiopia', 'India', 'Indonesia', 'Madagascar', 'Morocco', 'Myanmar', 'Nigeria', 'Pakistan', 'Philippines', 'Somalia', 'South_Africa', 'Tanzania', 'Ukraine', 'United_Republic_of_Tanzania', 'Viet_Nam', 'Uganda', 'Zambia', 'Kenya')
if(!(country %in% names(available))){
     print(paste0(ctr, ' is not available in the database. Raising error...'))
     stop()
}
region <- as.numeric(available[country])

fitness = fitness_INC_MORT 

start_time <- Sys.time() 

FIT = FALSE
RUN = TRUE
VAC = TRUE
BASELINE = TRUE
ITERATIONS = TRUE

if(BASELINE){

out <- tryCatch(
{
    simTB_iter(country, iter, mode_contact, fitting=FIT, running=RUN, running_vaccine=VAC, FuncFitness = fitness, TB_burden_file = TB_file)
    print("Baseline fitted")
},
error=function(condition) {
    print(condition)
    handler = 0
    sentinel = 1
    while(handler==0){
        line <- sprintf("Baseline, attempt = %d", sentinel)
        print(line)
        aux <- tryCatch(
        {   
            create_initial_fit_param(country, iter, mode_contact)   
            simTB_iter(country, iter, mode_contact, fitting=FIT, running=RUN, running_vaccine=VAC, FuncFitness = fitness, TB_burden_file = TB_file)
            handler=1
        },
        error=function(condition2) {
            print(condition2)
        },
        warning=function(condition2) {
            print(condition2)
            handler=1
        }) 
        sentinel = sentinel + 1 
    }
})
}

if(ITERATIONS){
library(parallel)
library(iterators)
library(foreach)
library(doParallel)

numCores <- detectCores()
registerDoParallel(numCores)  # use multicore, set to the number of our cores

IterMin = 1
IterMax = 500
start_to_end <- IterMin:IterMax

auxPath <- path.expand("~")
#Recorro la carpeta de outputs buscando las simulaciones que tengo que lanzar basándome en las que ya se han completado
if(FIT){
    if(!dir.exists(paste0(auxPath, "/TB_SIM_OUT/", country, sprintf("_cm_%d", mode_contact), '/Object_Folder/'))){
        recorrido <- IterMin:IterMax
    } else{
        out <- c()
        j = 1
        for (i in start_to_end){
            path_check <- paste0(auxPath, "/TB_SIM_OUT/", country, sprintf("_cm_%d", mode_contact), '/Object_Folder/Iter_', sprintf("%03d", i), '/Output_object_1.txt')
            if (!file.exists(path_check)){
                out[j] = i
                j = j + 1
            }
        }
        recorrido <- out
        print(recorrido)
    }
} else{
    recorrido <- IterMin:IterMax
}

mcoptions <- list(preschedule = FALSE) #Disable preschedule. This way, the load is balanced in time between cores.
foreach (i=recorrido, .options.multicore = mcoptions) %dopar% {
    out <- tryCatch(
    {
        print(sprintf("Iteration %d launched", i))
        if(FIT){
            create_recal_parameters(country, i, i, mode_contact)
            create_recal_contacts(country, i, i, region, mode_contact) 
        }
        TB_file = paste0("../Inputs_Iter/", country, "_cm_", sprintf("%d", mode_contact), "/Burden/TB_burden_", sprintf("%03d", i), '.txt')
        simTB_iter(country, i, mode_contact, fitting=FIT, running=RUN, running_vaccine=VAC, FuncFitness = fitness, TB_burden_file = TB_file)
    },
    error=function(cond) {
        print(cond)
        print(sprintf("Iteration %d failed, recalculating...", i))
        handler=0
        sentinel = 1
        while(handler==0){
            aux <- tryCatch(
            {
                print(sprintf("Iteration %d attempt %d", i, sentinel))
                if(FIT){
                    create_recal_parameters(country, i, i, mode_contact)
                    create_recal_contacts(country, i, i, region, mode_contact)
                }
                
                simTB_iter(country, i, mode_contact, fitting=FIT, running=RUN, running_vaccine=VAC, FuncFitness = fitness, TB_burden_file = TB_file)
                handler = 1
            },
            error=function(cond2) {
                print(cond2)
            })  
            sentinel = sentinel + 1
        }
    })
}

}
end_time <- Sys.time()
time <- end_time - start_time
print(time)


