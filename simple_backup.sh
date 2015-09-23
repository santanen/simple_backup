#!/bin/bash
#
# simple_backup.sh
# main executable

# change to script directory
dir=`dirname $0`
cd $dir

# include common configuration file common.config
if [ -f common.config ]; then
  . common.config
else
  printf "Failed reading common configuration file common.config, exiting..."
  exit 1
fi

# include common functions
if [ -f functions.sh ]; then
  . functions.sh
else
  printf "Failed reading common function file functions.sh, exiting..."
  exit 1
fi

# see how we are called
if [ $# -gt 0 ]; then
  prefix=$1
else
  prefix=$ROLLING
fi

# loop through endpoint directories and run actions
for d in *.d; do
  # skip example directory www.example.com.d
  if [ $d == "www.example.com.d" ]; then
    continue
  fi
  #
  # read endpoints configuration; if read fails, continue to next...
  #
  printf "Reading endpoint configuration file for %s... " "$d"
  read_endpoint_config $d
  if [ $result -eq 1 ]; then
    printf "failed\n"
    continue
  else
    printf "success\n"
  fi
  # done reading endpoint configuration
  #
  # run remote script prior to backup operations
  if [ -f $d/endpoint_script.sh ]; then
    ssh $IDENTITY 'bash -s' < $d/endpoint_script.sh
  fi
  # check if ssh or local and create SOURCEBASE accordingly
  SOURCEBASE=$IDENTITY
  if [ $PROTOCOL == "ssh" ]; then
    SOURCEBASE=$SOURCEBASE:
  fi

  TARGET=$BASETARGET$SOURCEBASE/$prefix

  rotate_backups
  if [ $prefix == $ROLLING ]; then
    make_backup
  else
    take_snapshot
  fi
done
