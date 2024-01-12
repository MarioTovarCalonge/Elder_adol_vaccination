#!/bin/bash

SECONDS=0
# do everything

Rscript 1_adol_Impact_w_errorbars.R
Rscript 2_elder_Impact_w_errorbars.R
Rscript 3_combine_impact_files.R
Rscript 4_HcompW10.R
Rscript 5_HcompW20.R

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

