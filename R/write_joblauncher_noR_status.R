write_joblauncher_noR_status <-
  function(file = file.path(getwd(),"job.sh"),
           nodes = 1,ppn = 18,mem = 16,walltime = 24,
           prerun = "ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited",
           CD = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run",
           ed_exec = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt",
           ED2IN = "ED2IN",
           firstjob = TRUE,
           CD.main = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run"){

    if (firstjob){
      writeLines("#!/bin/bash -l",con = file)
      write(paste0("#PBS -l nodes=",nodes,":ppn=",ppn),file=file,append=TRUE)
      write(paste0("#PBS -l mem=",mem,"gb"),file=file,append=TRUE)
      write(paste0("#PBS -l walltime=",walltime,":00:00"),file=file,append=TRUE)
      write(paste0("#PBS -o logfile.txt"),file=file,append=TRUE)
      write(paste0("#PBS -e errorfile.txt"),file=file,append=TRUE)
      write("",file=file,append=TRUE)
      write(prerun,file=file,append=TRUE)
      write("compt=0",file=file,append=TRUE)
    }

    write("",file=file,append=TRUE)
    write(paste("cd",CD),file=file,append=TRUE)
    write(paste("printf 'STARTED\\n' > ",file.path(CD,"status.txt")),file=file,append=TRUE)
    write(paste(ed_exec,"-f",ED2IN),file=file,append=TRUE)

    ed2in <- read_ed2in(file.path(CD,ED2IN))
    OPfiles <- ed2in$FFILOUT
    CMD <- paste0("rm $(find ",dirname(OPfiles)," -name '*' ! -name '",paste0(basename(OPfiles),"-Q*-","01","-*"),"')")
    write(CMD,file=file,append=TRUE)

    ifcond <- paste0("if [ $(grep -o '=== Time integration ends; Total elapsed time=' '",
                     file.path(CD.main,'logfile.txt'),
                     "' | wc -l) -gt $compt ]; then")

    write("STATUS=$?",file=file,append=TRUE)
    write(ifcond,file=file,append=TRUE)
    write("  STATUS=0",file=file,append=TRUE)
    write("else",file=file,append=TRUE)
    write("  STATUS=1",file=file,append=TRUE)
    write("fi",file=file,append=TRUE)

    write("",file=file,append=TRUE)

    write("if [ $STATUS -ne 0 ]; then",file=file,append=TRUE)
    error <- paste0("printf 'ERROR\\n' >> ",file.path(CD,"status.txt"))
    write(error,file=file,append=TRUE)
    write("else",file=file,append=TRUE)
    success <- paste0("printf 'SUCCESS\\n' >> ",file.path(CD,"status.txt"))
    write(success,file=file,append=TRUE)
    write("  compt=$((compt+1))",file=file,append=TRUE)
    write("fi",file=file,append=TRUE)

  }
