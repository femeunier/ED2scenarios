rm(list = ls())

library(PEcAn.ED2)

ref_dir <- "/home/carya/R/ED2scenarios/reference"
rundir <- "/home/carya/R/ED2scenarios/run/"
outdir <- "/home/carya/R/ED2scenarios/out/"

ED2IN_ref <- file.path(ref_dir,"ED2IN")
ed2in <- read_ed2in(ED2IN_ref)

CO2 <- c(370,450)
names_CO2 <- c("ref","elevated")

disturbance <- c(-0.0125,-0.015)
names_disturbance <- c("ref","elevated")

yeara <- c(2003,2003)
yearz <- c(2016,2003)
names_climate <- c("ref","dry")

################################################################
# Nothing to change from here

if(!dir.exists(rundir)) dir.create(rundir)
if(!dir.exists(outdir)) dir.create(outdir)

for (iCO2 in seq(1,length(CO2))){
  for (idisturb in seq(1,length(disturbance))){
    for (iclim in seq(1,length(yeara))){

      name_scenar <- paste("simulation","CO2",names_CO2[iCO2],"disturbance",names_disturbance[idisturb],"climate",names_climate[iclim],sep = '_')

      run_scenar <- file.path(rundir,name_scenar)
      out_scenar <- file.path(outdir,name_scenar)

      if(!dir.exists(run_scenar)) dir.create(run_scenar)
      if(!dir.exists(out_scenar)) dir.create(out_scenar)
      if(!dir.exists(file.path(out_scenar,"analy"))) dir.create(file.path(out_scenar,"analy"))
      if(!dir.exists(file.path(out_scenar,"histo"))) dir.create(file.path(out_scenar,"histo"))

      #######################################################################################
      # Modify ED2IN
      # Change scenarios
      ed2in_scenar <- ed2in
      ed2in_scenar$INITIAL_CO2 = CO2[iCO2]

      ed2in_scenar$TREEFALL_DISTURBANCE_RATE = disturbance[idisturb]

      ed2in_scenar$METCYC1 = yeara[iclim]
      ed2in_scenar$METCYCF = yearz[iclim]

      # Change output location
      ed2in_scenar$FFILOUT = file.path(out_scenar,"analy","analysis")
      ed2in_scenar$SFILOUT = file.path(out_scenar,"histo","history")

      # Change config
      ed2in_scenar$IEDCNFGF = file.path(run_scenar,"config.xml")

      write_ed2in(ed2in_scenar,filename = file.path(run_scenar,"ED2IN"))

      #######################################################################################
      # Modify config

      system2("cp",c(file.path(ref_dir,"config.xml"),
                   file.path(run_scenar,"config.xml")))

      #######################################################################################
      # Modify job.sh

      write_job(file =  file.path(run_scenar,"job.sh"),
                nodes = 1,ppn = 18,mem = 16,walltime = 24,
                prerun = "ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited",
                CD = run_scenar,
                ed_exec = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt",
                ED2IN = "ED2IN")
    }
  }
}
