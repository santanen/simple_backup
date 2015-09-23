#!/bin/bash
#
# functions.sh
# functions used by simple_backup.sh
#
function read_endpoint_config() {
  if [ -f $1/endpoint.config ]; then
    . $1/endpoint.config
    result=0
  else
    result=1
  fi
}

function rotate_backups() {

  # step 1: delete the oldest snapshot, if it exists:
  if [ -d $TARGET.3 ] ; then
  $RM -rf $TARGET.3
  fi

  # step 2: shift the middle snapshots(s) back by one, if they exist
  if [ -d $TARGET.2 ] ; then
  $MV $TARGET.2 $TARGET.3
  fi
  if [ -d $TARGET.1 ] ; then
  $MV $TARGET.1 $TARGET.2
  fi

  # step 3: make a hard-link-only (except for dirs) copy of the latest snapshot,
  # if that exists
  if [ -d $TARGET.0 ] ; then
  $CP -al $TARGET.0 $TARGET.1
  fi
}

function make_backup() {
  # step 4: rsync from the system into the latest snapshot (notice that
  # rsync behaves like cp --remove-destination by default, so the destination
  # is unlinked first.  If it were not so, this would copy over the other
  # snapshot(s) too!
  for SOURCE in "${SOURCES[@]}"
  do
      #Create BASETARGET + SOURCE directory if not exists
      [[ -d $TARGET.0/$SOURCE ]] || $MKDIR -p $TARGET.0/$SOURCE
      echo $TARGET.0/$SOURCE
      echo $SOURCEBASE$SOURCE

      $RSYNC                                                     \
          -vam --delete --delete-excluded                         \
          --exclude-from="$EXCLUDES"                              \
          $SOURCEBASE$SOURCE $TARGET.0/$SOURCE
  done
  # step 5: update the mtime of hourly.0 to reflect the snapshot time
  $TOUCH $TARGET.0
}

function take_snapshot() {
  if [ -d $BASETARGET$SOURCEBASE/$ROLLING.0 ] ; then
    {
      $CP -al $BASETARGET$SOURCEBASE/$ROLLING.0 $TARGET.1
      $TOUCH $TARGET.1
    }
  fi
}
