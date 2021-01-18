#!/bin/bash

. ./.env

NUM_DAYS=100

#List of recordings that are recorded by BBB but not on S3
RECORDED_DIFF_S3_FILE="recordings_recorded_diff_S3.txt"
:> "$RECORDED_DIFF_S3_FILE"


#List of raw recordings by BBB
RAW_RECORDING_FILE='raw_recordings_by_BBB.txt'
#Ensure that the file exists and is empty
:> "$RAW_RECORDING_FILE"

find /var/bigbluebutton/recording/raw/ -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep "^[0-9a-f]{40}-[[:digit:]]{13}$" > "$RAW_RECORDING_FILE"
RAW_RECRODING_COUNT=$(cat "$RAW_RECORDING_FILE" | wc -l)
echo "Raw recordings in the last $NUM_DAYS day: $RAW_RECRODING_COUNT"


#List of recorded recordings by BBB
RECORDED_RECORDING_FILE='recorded_recordings_by_BBB.txt'
#Ensure that the file exists and is empty
:> "$RECORDED_RECORDING_FILE"

while read raw_meeting; do

  #Get events.xml of raw recording
  events_xml="/var/bigbluebutton/recording/raw/$raw_meeting/events.xml"

  if [[ -f "$events_xml" ]]; 
  then
    #Read events.xml and look for RecordStatusEvent as true, which means the meeting was recorded
    result=`xmlstarlet sel -t -v '//recording/event[@eventname="RecordStatusEvent"]/status' "$events_xml"`
    
    if [ -n "$result" ]; 
    then
      echo "$raw_meeting" >> "$RECORDED_RECORDING_FILE"
    fi
  fi
done < "$RAW_RECORDING_FILE"


RECORDED_RECRODING_COUNT=$(cat "$RECORDED_RECORDING_FILE" | wc -l)
echo "Recorded recordings in the last $NUM_DAYS day: $RECORDED_RECRODING_COUNT"


echo "Ensuring already converted MP4 files are sync with S3"
aws s3 sync mp4/ "s3://$S3BucketName"  --acl public-read

#List of recordings that are on AWS S3
S3_FILE='recordings_on_S3.txt'
#Ensure that the file exists and is empty
:> "$S3_FILE"
aws s3 ls "s3://$S3BucketName" | awk '{ print $4 }' | cut -f 1 -d '.' | egrep '[a-z0-9\-]{54}' > "$S3_FILE"



while read recorded_recording; do
  if grep -q "$recorded_recording" "$S3_FILE"; then
    #echo "Already on S3: $recorded_recording"   
    :  
  else
    echo "Not on S3: $recorded_recording"   
    echo "$recorded_recording" >> "$RECORDED_DIFF_S3_FILE"
  fi
done < "$RECORDED_RECORDING_FILE"


RECORDED_DIFF_S3_COUNT=$(cat "$RECORDED_DIFF_S3_FILE" | wc -l)
echo "Recorded recordings but not on S3 the last $NUM_DAYS day: $RECORDED_DIFF_S3_COUNT"

rm "$S3_FILE" "$RAW_RECORDING_FILE" "$RECORDED_RECORDING_FILE"

if [ "$RECORDED_DIFF_S3_COUNT" -eq 0 ]; then
  echo "All recorded recordings on S3"
  rm "$RECORDED_DIFF_S3_FILE"
  exit 1
else
  echo "Rebuilding recording. Watch script will convert to MP4 and upload to S3"
  #parallel -j 2 --timeout 200% --joblog log/parallel_rebuild.log -a "$RECORDED_DIFF_S3_FILE" bbb-record --rebuild &
fi




