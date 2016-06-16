#!/bin/bash

# Timestamp is used as suffix for backup files
TIMESTAMP=`date +%s`

# Path to where configuration files are cloned
CONFIGURATION_PATH="`dirname $0`"

echo "Setting up home dot files as symlinks..."
for FILE_PATH in `ls -1 $CONFIGURATION_PATH/home_dot_files_as_symlinks/_*`; do
  FILE_NAME=`basename $FILE_PATH`
  FILE_NAME_WITHOUT_=${FILE_NAME:1}
  FILE_AT_HOME=`realpath -s ~/.$FILE_NAME_WITHOUT_`
  FILE_AT_HOME_BACKUP="$FILE_AT_HOME.$TIMESTAMP"
  FILE_AT_CONFIGURATION_PATH=`realpath $FILE_PATH`
  if [ -e $FILE_AT_HOME ]; then
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

