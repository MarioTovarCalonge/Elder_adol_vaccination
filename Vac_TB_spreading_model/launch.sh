#!/bin/bash

SECONDS=0
# do everything

cd Codes/
#bash adol_launch.sh China 3
#bash adol_launch.sh China 1

#bash elder_launch.sh China 3
#bash elder_launch.sh China 1

cd Ploting_Codes/
bash launch_global.sh

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
