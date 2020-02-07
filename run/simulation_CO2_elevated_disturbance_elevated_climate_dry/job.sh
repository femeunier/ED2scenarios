#!/bin/bash -l
#PBS -l nodes=1:ppn=18
#PBS -l mem=16gb
#PBS -l walltime=24:00:00

ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited

cd /home/carya/R/ED2scenarios/run//simulation_CO2_elevated_disturbance_elevated_climate_dry

/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt -f ED2IN
