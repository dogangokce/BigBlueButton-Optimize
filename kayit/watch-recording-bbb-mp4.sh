#!/bin/bash

. ./.env

echo "recordingDir: $recordingDir"

echo "Watching New BBB Meetings"
echo `date`

DIRECTORY_TO_OBSERVE="$recordingDir"
#Directory where bbb-mp4 is installed
DIRECTORY_BBB_MP4="$BBBMP4Dir"
#pattern for meeting id
MEETING_ID="^[0-9a-f]{40}-[[:digit:]]{13}$"

watch() {

  inotifywait -m -r -e create -e moved_to $DIRECTORY_TO_OBSERVE | while read path action file;do


    echo "Change detected date $(date) in ${path} action ${action} in file ${file}"
    convert_mp4 "${file}"

  done

}

# Absolute path to node - execute command "which node" to find out
convert_mp4() {

    if [[ $1 =~ $MEETING_ID ]]; 
    then    
      cd $DIRECTORY_BBB_MP4 && nohup /usr/bin/node bbb-mp4.js $1 > "log/$1.log" 2>&1 &
    else 
      echo "Not a meeting: $1"
    fi

}

# This script is called by the supervisor.
watch
