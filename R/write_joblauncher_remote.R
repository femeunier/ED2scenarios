write_joblauncher_remote <-
  function(file = file.path(getwd(),"job.sh"),dirED2IN = NULL,
           nodes = 1,ppn = 18,mem = 16,walltime = 24,
           prerun = "ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited",
           CD = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run",
           ed_exec = "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt",
           ED2IN = "ED2IN",
           Rplot_function = '/data/gent/vo/000/gvo00074/felicien/R/read_and_plot_ED2_Q2R_tspft.r',
           clean = FALSE,date.init = NULL,date.end = NULL,
           firstjob = TRUE){

    if (is.null(dirED2IN = NULL)){
      ed2in <- read_ed2in(file.path(dirname(file),ED2IN))
    } else {
      ed2in <- read_ed2in(file.path(dirED2IN,ED2IN))
    }

    DN <- dirname(ed2in$FFILOUT)
    analy <- basename(ed2in$FFILOUT)

    if (!is.null(date.init)){
      init <- date.init
    } else{
      init <- paste(ed2in$IYEARA,sprintf('%02d',ed2in$IMONTHA),sprintf('%02d',ed2in$IDATEA),sep='/')
    }

    if (!is.null(date.end)){
      end <- date.end
    } else{
      end <- paste(ed2in$IYEARZ,sprintf('%02d',ed2in$IMONTHZ),sprintf('%02d',ed2in$IDATEZ),sep='/')
    }

    Rfunction <- tools::file_path_sans_ext(basename(Rplot_function))

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
