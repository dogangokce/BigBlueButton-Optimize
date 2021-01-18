#!/bin/bash

. ./.env

NUM_DAYS=100

#List of recordings that are published by BBB but not on S3
PUBLISHED_DIFF_S3_FILE="recordings_published_diff_S3.txt"
:> "$PUBLISHED_DIFF_S3_FILE"

#List of recordings that are published by BBB
PUBLISHED_FILE='recordings_published_by_BBB.txt'
#Ensure that the file exists and is empty
:> "$PUBLISHED_FILE"

find /var/bigbluebutton/published/presentation/ -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > "$PUBLISHED_FILE"
TOTAL_PUBLISHED_RECRODINGS=$(cat "$PUBLISHED_FILE" | wc -l)
echo "Total published recordings the last $NUM_DAYS day: $TOTAL_PUBLISHED_RECRODINGS"


echo "Ensuring already converted MP4 files are sync with S3"
aws s3 sync mp4/ "s3://$S3BucketName"  --acl public-read


#List of recordings that are on AWS S3
S3_FILE='recordings_on_S3.txt'
#Ensure that the file exists and is empty
:> "$S3_FILE"
aws s3 ls "s3://$S3BucketName" | awk '{ print $4 }' | cut -f 1 -d '.' | egrep '[a-z0-9\-]{54}' > "$S3_FILE"

while read published_recording; do
  if grep -q "$published_recording" "$S3_FILE"; then
    #echo "Already on S3: $published_recording" 
    :    
  else
    #echo "Not on S3: $published_recording"   
    echo "$published_recording" >> "$PUBLISHED_DIFF_S3_FILE"
  fi
done < "$PUBLISHED_FILE"


PUBLISHED_DIFF_S3_COUNT=$(cat "$PUBLISHED_DIFF_S3_FILE" | wc -l)
echo "Published recordings but not on S3 the last $NUM_DAYS day: $PUBLISHED_DIFF_S3_COUNT"

rm "$PUBLISHED_FILE" "$S3_FILE"

if [ "$PUBLISHED_DIFF_S3_COUNT" -eq 0 ]; then
  echo "All published recordings on S3"
  rm "$PUBLISHED_DIFF_S3_FILE"
  exit 1
else

  pgrep -f "/usr/bin/parallel" && echo "Parallel already running. Exiting." && exit 1
   
  echo "Starting MP4 conversion of published but not on S3 recordings"
  parallel -j 2 --timeout 200% --joblog log/parallel_mp4.log -a "$PUBLISHED_DIFF_S3_FILE" node bbb-mp4 &
fi  
