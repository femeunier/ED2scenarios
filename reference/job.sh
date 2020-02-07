#!/bin/bash -l

# redirect output
exec 3>&1
exec &>> "/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out/logfile.txt"

TIMESTAMP=`date +%Y/%m/%d_%H:%M:%S`
echo "Logging on "$TIMESTAMP

# host specific setup

ml UDUNITS/2.2.26-intel-2018a R/3.4.4-intel-2018a-X11-20180131 HDF5/1.10.1-intel-2018a; ulimit -s unlimited

# create output folder
mkdir -p "/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out"
# no need to mkdir for scratch

# @REMOVE_HISTXML@ : tag to remove "history.xml" on remote for restarts, commented out on purpose


# flag needed for ubuntu
export GFORTRAN_UNBUFFERED_PRECONNECTED=yes

# see if application needs running
if [ ! -e "/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out/history.xml" ]; then
  cd "/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/run"
  
  "/user/scratchkyukon/gent/gvo000/gvo00074/felicien/ED2/ED/run/ed_2.1-opt" ""
  STATUS=$?
  if [ $STATUS == 0 ]; then
    if grep -Fq '=== Time integration ends; Total elapsed time=' "/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out/logfile.txt"; then
      STATUS=0
    else
      STATUS=1
    fi
  fi
  
  # copy scratch if needed
  # no need to copy from scratch
  # no need to clear scratch

  # check the status
  if [ $STATUS -ne 0 ]; then
  	echo -e "ERROR IN MODEL RUN\nLogfile is located at '/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out/logfile.txt'"
  	echo "************************************************* End Log $TIMESTAMP"
    echo ""
  	exit $STATUS
  fi

  # convert to MsTMIP
  echo "require (PEcAn.ED2)
model2netcdf.ED2('/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out', 9, -79, '2000/01/01', '2004/12/31', c('Liana_BCI','Early','Mid','Late'))
" | R --vanilla

  echo "source('/data/gent/vo/000/gvo00074/felicien/R/read_and_plot_ED2_Q2R.r')
read_and_plot_ED2_Q2R('/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out','analysis','2000/01/01', '2004/12/31')
" | R --vanilla

fi

# copy readme with specs to output

# run getdata to extract right variables

# host specific teardown


# all done
echo -e "MODEL FINISHED\nLogfile is located at '/data/gent/vo/000/gvo00074/pecan/output/other_runs/reference/out/logfile.txt'"
echo "************************************************* End Log $TIMESTAMP"
echo ""
