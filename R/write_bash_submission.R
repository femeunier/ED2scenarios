write_bash_submission <- function(file = file.path(getwd(),"all_jobs.sh"),
                                  list_files = list(),
                                  job_name = "job.sh"){

  writeLines("#!/bin/bash -l",con = file)

  if (length(job_name) == 1) job_name <- rep(job_name,length(list_files))

  tryCatch(map(1:length(list_files),function(i){
    write(paste("cd",list_files[[i]]),file=file,append=TRUE)
    write(paste("qsub",job_name[i]),file=file,append=TRUE)
  }),error = function(e) e)

  return(TRUE)
}
