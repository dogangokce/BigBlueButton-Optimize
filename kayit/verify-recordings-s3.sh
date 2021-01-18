#!/bin/bash

#Verify which of recordings from unprocessedfilename are not already recorded on S3

. ./.env

RECORDING_DIR="$recordingDir"

#Number of days to verify recordings for
NUM_DAYS=30

#Create a file to keep total recordings available in /var/bigbluebutton/published/presentation/
unprocessedfilename='bbb-unprocessed-recordings.txt'
:> "$unprocessedfilename"

#Create a file to keep MP4 already processed and uploaded on AWS S3
processedfilename='s3-processed-recordings.txt'
:> "$processedfilename"

#Create a tmp file to record unprocessed recordings
unprocessedfilename_temp='bbb-unprocessed-recordings-temp.txt'
:> "$unprocessedfilename_temp"

find "$RECORDING_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $unprocessedfilename
echo "Total recordings over $NUM_DAYS days: "
cat $unprocessedfilename | wc -l

echo "Ensuring already converted MP4 files are sync with S3"
aws s3 sync mp4/ "s3://$S3BucketName"  --acl public-read

aws s3 ls "s3://$S3BucketName" | awk '{ print $4 }' | cut -f 1 -d '.' | egrep '[a-z0-9\-]{54}' > $processedfilename
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
