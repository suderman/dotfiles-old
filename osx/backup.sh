#!/bin/bash

# Disc backup script
# Requires rsync 3
# http://nicolasgallagher.com/mac-osx-bootable-backup-drive-with-rsync/

# Ask for the administrator password upfront
sudo -v

SRC="/Volumes/HDD"
DST="/Volumes/AUX"
EXCLUDE="$HOME/.osx/backup-excludes.txt"
PROG=$0

if [ ! -r "$SRC" ]; then
  logger -t $PROG "Source $SRC not readable - Cannot start the sync process"
else

  if [ ! -w "$DST" ]; then
    logger -t $PROG "Destination $DST not writeable - Cannot start the sync process"
  else

    logger -t $PROG "Start rsync"

    # --acls                   update the destination ACLs to be the same as the source ACLs
    # --archive                turn on archive mode (recursive copy + retain attributes)
    # --delete                 delete any files that have been deleted locally
    # --delete-excluded        delete any files (on DST) that are part of the list of excluded files
    # --exclude-from           reference a list of files to exclude
    # --hard-links             preserve hard-links
    # --one-file-system        don't cross device boundaries (ignore mounted volumes)
    # --sparse                 handle spare files efficiently
    # --verbose                increase verbosity
    # --human-readable         produces numbers in a more human-readable format
    # --xattrs                 update the remote extended attributes to be the same as the local ones
    # --dry-run                perform a trial run that doesn't make any changes

    sudo rsync --acls \
               --archive \
               --delete \
               --delete-excluded \
               --exclude-from=$EXCLUDE \
               --hard-links \
               --one-file-system \
               --sparse \
               --verbose \
               --progress \
               --xattrs \
               --human-readable \
               --ignore-errors \
               "$SRC/" "$DST"

    logger -t $PROG "End rsync"

  fi
fi
