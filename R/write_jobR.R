write_jobR <-
  function(file = file.path(getwd(),"job.sh"),
           nodes = 1,ppn = 18,mem = 16,walltime = 24,
           prerun = "ml purge ; ml R-bundle-Bioconductor/3.15-foss-2021b-R-4.2.0",
           CD = "/data/gent/vo/000/gvo00074/felicien/R/",
           Rscript = '/data/gent/vo/000/gvo00074/felicien/R/read_and_plot_ED2_Q2R_tspft.r'){


    writeLines("#!/bin/bash -l",con = file)
    write(paste0("#PBS -l nodes=",nodes,":ppn=",ppn),file=file,append=TRUE)
    write(paste0("#PBS -l mem=",mem,"gb"),file=file,append=TRUE)
    write(paste0("#PBS -l walltime=",walltime,":00:00"),file=file,append=TRUE)
    write("",file=file,append=TRUE)
    write(prerun,file=file,append=TRUE)

    write("",file=file,append=TRUE)
    write(paste("cd",CD),file=file,append=TRUE)

    write(paste0("Rscript ",Rscript),file=file,append=TRUE)
  }
