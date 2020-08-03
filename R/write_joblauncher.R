write_joblauncher <-
  function(file = file.path(getwd(),"job.sh"),
           nodes = 1,ppn = 18,mem = 16,walltime = 24,
           prerun = "ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited",
           CD = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run",
           ed_exec = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt",
           ED2IN = "ED2IN",
           Rplot_function = '/data/gent/vo/000/gvo00074/felicien/R/read_and_plot_ED2_Q2R_tspft.r',
           clean = FALSE,
           firstjob = TRUE){

    if (firstjob){
      writeLines("#!/bin/bash -l",con = file)
      write(paste0("#PBS -l nodes=",nodes,":ppn=",ppn),file=file,append=TRUE)
      write(paste0("#PBS -l mem=",mem,"gb"),file=file,append=TRUE)
      write(paste0("#PBS -l walltime=",walltime,":00:00"),file=file,append=TRUE)
      write("",file=file,append=TRUE)
      write(prerun,file=file,append=TRUE)
    }

    write("",file=file,append=TRUE)
    write(paste("cd",CD),file=file,append=TRUE)
    write(paste(ed_exec,"-f",ED2IN),file=file,append=TRUE)

    write("",file=file,append=TRUE)
    write(paste0("echo \"source(\'",Rplot_function,"\')"),file=file,append=TRUE)
    write(paste0(Rfunction,"(\'",DN,"\',\'",analy,"\',\'",init,"\',\'",end,"\')"),file=file,append=TRUE)
    write("\" | R --vanilla",file=file,append=TRUE)

    if (clean){
      ed2in <- read_ed2in(file.path(CD,ED2IN))
      OPfiles <- ed2in$FFILOUT
      CMD <- paste0("rm $(find ",dirname(OPfiles)," -name '*' ! -name '",paste0(basename(OPfiles),"-Q*-","01","-*"),"')")
      write(CMD,file=file,append=TRUE)
    }
  }
