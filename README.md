# Elder_adol_vaccination

System requirements:

-GCC (checked with Apple clang version 12.0.5 (clang-1205.0.22.9))

-R (checked with R version 3.6.3 (2023-02-08))

-R packages: "ggplot2", "cowplot", "fanplot", "gridExtra", "minpack.lm", "nlsr", "iterators", "foreach", "doParallel", "dplyr".

Once R and gcc are available, no explicit installation, or special hardware is needed. When running the master scripts provided, C codes will be compiled as external libraries. If R packages are not installed, please install them manually.

Please note that: -Folder's names should be preserved. Otherwise errors will be raised as scripts need the correct paths for working properly.

Use guide:
The code is structured in one directory with a master script named launch.sh that executes all relevant codes and produces formally equivalent outcomes to those in the main text.

First, unzip the contents of the Outputs/ and Inputs_Iter/ folders, so the folder structure obtained is:
Codes/
Inputs_Iters/
Inputs/
Outputs/

Then, execute the master script launch.sh via bash.
The code then will compute the simulation of introducing the studied vaccine in adolescents and elders, under both contact matrix update schemes. This will take around 6-8h depending on the computer.
The output will be located inside the Codes/Plotting_codes/ folder, in which 2 plots that depict the impacts in both populations, formally equivallent to those in the paper, will be created.

