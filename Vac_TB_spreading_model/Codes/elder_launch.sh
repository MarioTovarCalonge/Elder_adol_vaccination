#!/bin/bash

country=$1
cmode=$2
 #Profile: Efficacy-Coverage-Target_pop
 #Coverage 0.30 or 0.70
 #Efficacy 0.40, 0.60 or 0.80
 #Target_pop S L LR SLR

SECONDS=0
# do everything

#wanings=( 10 20 )
wanings=( 5 )
coverages=( 0.30 0.70 )
effs=( 0.40 0.60 0.80 )
Targets=( S L LR SLR )
#vaccines=( fast slow reinf relapse all )
vaccines=( all )
for vac in "${vaccines[@]}"
do
    for W in "${wanings[@]}"
    do
        for T in "${Targets[@]}"
        do
            echo $T
            Rscript elder_create_profile.R 0.80 0.70 $T $W $vac
            Rscript master.R $country $cmode 
        done
    done
done

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
