#!/bin/bash

# Timestamp is used as suffix for backup files
TIMESTAMP=`date +%s`

# Path to where configuration files are cloned
CONFIGURATION_PATH="`dirname $0`"

HOME_REALPATH=`realpath ~`

echo "Setting up home dot files as symlinks..."
for FILE in `find $CONFIGURATION_PATH/symlinks -type file`; do
  FILE_NAME=`basename $FILE`
  if [ "${FILE_NAME:0:1}" = "_" ]; then
    FILE_NAME_TO_USE=".${FILE_NAME:1}"
  else
    FILE_NAME_TO_USE="$FILE_NAME"
  fi
  CONFIGURATION_PATH_TO_FILES="$CONFIGURATION_PATH/symlinks"
  CONFIGURATION_PATH_LENGTH=${#CONFIGURATION_PATH_TO_FILES}
  FILE_PATH="`dirname $FILE`/"
  FILE_PATH=${FILE_PATH:$CONFIGURATION_PATH_LENGTH}
  if [ "${FILE_PATH:0:1}" = "_" ]; then
    FILE_PATH_TO_USE=".${FILE_PATH:1}"
  else
    FILE_PATH_TO_USE="$FILE_PATH"
  fi
  DIR_REPLACE_SOURCE="/_"
  DIR_REPLACE_TARGET="/."
  FILE_PATH_TO_USE="${FILE_PATH_TO_USE/$DIR_REPLACE_SOURCE/$DIR_REPLACE_TARGET}"
  FILE_AT_HOME_FILE="~""$FILE_PATH_TO_USE$FILE_NAME_TO_USE"
  FILE_AT_HOME=`realpath -s $HOME_REALPATH$FILE_PATH_TO_USE$FILE_NAME_TO_USE`
  FILE_AT_HOME_BACKUP="$FILE_AT_HOME.$TIMESTAMP"
  FILE_AT_CONFIGURATION_PATH=`realpath $FILE`
  if [ -e $FILE_AT_HOME ] || [ -h $FILE_AT_HOME ]; then
    if [ -h $FILE_AT_HOME ]; then
      if [ "$(readlink $FILE_AT_HOME)" = "$FILE_AT_CONFIGURATION_PATH" ]; then
        echo "* Skipping $FILE_AT_HOME, already set"
        continue
      fi
    fi
    mv $FILE_AT_HOME $FILE_AT_HOME_BACKUP
  fi
  ln -s $FILE_AT_CONFIGURATION_PATH $FILE_AT_HOME && echo "* Linking $FILE_AT_HOME -> $FILE_AT_CONFIGURATION_PATH"
done
echo "...done with settings up home dot files as symlinks"

