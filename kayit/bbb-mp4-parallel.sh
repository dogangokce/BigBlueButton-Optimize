#!/bin/bash

. ./.env

echo "copyToPath: $copyToPath"

NUM_DAYS=7

#File where unprocessed recordings will be added. We will convert these recordings into MP4.
UNPROCESSED_FILENAME='unprocessed-recordings-local.txt'
#Ensure that the file exists and is empty
:> "$UNPROCESSED_FILENAME"

function_sync_existing_recordings() {
  PROCESSED_FILENAME='processed-recordings-local.txt'

  echo "Get list of MP4 recordings in $copyToPath"
  find "$copyToPath" -printf "%f\n" | cut -f 1 -d '.' | egrep '[a-z0-9]*-[0-9]*' > "$PROCESSED_FILENAME"

  	
  while read unprocessed_recording; do
    if grep -q "$unprocessed_recording" "$PROCESSED_FILENAME"; then
      #echo "Already recorded: $unprocessed_recording"  
      true   
    else
      #echo "Not recorded: $unprocessed_recording"   
      echo "$unprocessed_recording" >> "$UNPROCESSED_FILENAME.t"
    fi
  done < $UNPROCESSED_FILENAME

 
  #echo "Updating unprocessed file with recordings not processed yet";
  mv "$UNPROCESSED_FILENAME.t" "$UNPROCESSED_FILENAME"

  #echo "Updated unprocessed recordings ready to be processed.";
  rm "$PROCESSED_FILENAME"
}


find "$recordingDir" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > "$UNPROCESSED_FILENAME"

TOTAL_RECRODINGS=$(cat "$UNPROCESSED_FILENAME" | wc -l)
echo "Total recordings the last $NUM_DAYS day: $TOTAL_RECRODINGS"

function_sync_existing_recordings

TOTAL_UNPROCESSED_RECRODINGS=$(cat "$UNPROCESSED_FILENAME" | wc -l)
echo "Unprocessed recordings the last $NUM_DAYS day: $TOTAL_UNPROCESSED_RECRODINGS"

if [ $TOTAL_UNPROCESSED_RECRODINGS -eq 0 ]; 
then
  echo "All recordings completed"
  exit 1
else

  pgrep -f "/usr/bin/parallel" && echo "Parallel already running. Exiting." && exit 1

  echo "Starting MP4 conversion using GNU Parallel"
  parallel -j 2 --timeout 200% --joblog log/parallel_mp4.log -a "$UNPROCESSED_FILENAME" node bbb-mp4 &
fi

