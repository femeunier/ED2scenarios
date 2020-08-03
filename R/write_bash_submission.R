write_bash_submission <- function(file = file.path(getwd(),"all_jobs.sh"),
                                  list_files = list(),
                                  job_name = "job.sh"){

  writeLines("#!/bin/bash -l",con = file)

  tryCatch(map(1:length(list_files),function(i){
    write(paste("cd",list_files[[i]]),file=file,append=TRUE)
    write(paste("qsub",job_name),file=file,append=TRUE)
  }),error = function(e) e)

  return(TRUE)
}
