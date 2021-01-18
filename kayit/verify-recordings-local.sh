#!/bin/bash

. ./.env

MP4_DIR="$copyToPath"
RECORDING_DIR="$recordingDir"

#Number of days to verify recordings for
NUM_DAYS=15

#Create a file to keep MP4 already processed and stored locally in ./mp4
processedfilename='local-processed-recordings.txt'
:> "$processedfilename"

#Create a file to keep total recordings available in /var/bigbluebutton/published/presentation/
unprocessedfilename='bbb-unprocessed-recordings.txt'
:> "$unprocessedfilename"

#Create a tmp file to record unprocessed recordings
unprocessedfilename_temp='bbb-unprocessed-recordings-temp.txt'
:> "$unprocessedfilename_temp"


find "$RECORDING_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $unprocessedfilename
echo "Total recordings over 15 days: "
cat $unprocessedfilename | wc -l

find "$MP4_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $processedfilename
echo "Already processed MP4: "
cat $processedfilename | wc -l


while read unprocessed_recording; do
  if grep -q "$unprocessed_recording" "$processedfilename"; then
    echo "Already recorded: $unprocessed_recording"     
  else
    echo "Not recorded: $unprocessed_recording"   
    echo "$unprocessed_recording" >> "$unprocessedfilename_temp"
  fi
done < $unprocessedfilename

mv "$unprocessedfilename_temp" "$unprocessedfilename"

echo "New recordings yet to be processed into MP4: "
cat $unprocessedfilename | wc -l

#Delete processing files
rm "$processedfilename"
rm "$unprocessedfilename"
