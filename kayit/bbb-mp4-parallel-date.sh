#!/bin/bash
n=0

#Give date range of recordings for which you want to create MP4 files. 
#To create MP4 files of 29 Sep, from_date should be 29 Sep and to_date should be 30 Sep i.e. 1 day additional
echo "Converting recordings from $from_date to $to_date"
from_date='29 Sep 2020'
to_date='30 Sep 2020'

#Path of recordings is /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/ if you execute this script on  Scalelite
#Path of recordings is /var/bigbluebutton/published/presentation if you execute this script on BBB
recordings_directory='/mnt/scalelite-recordings/var/bigbluebutton/published/presentation/'
echo "Converting recordings from $recordings_directory"

#File where unprocessed recordings will be added. We will convert these recordings into MP4.
filename='bbb-unprocessed-recordings.txt'
#Ensure that the file exists and is empty
:> "$filename"

for i in $(find "$recordings_directory" -maxdepth 1 -newerct "$from_date" ! -newerct "$to_date" -printf "%f\n"); do
    recording="mp4/$i.mp4"
    [ ! -f "$recording" ] && n=$((n+1)) && echo "#$n $recording not found" && echo "$i" >> "$filename"
done

echo "Executing 2 MP4 conversion jobs in parallel";
parallel -j 2 --joblog log/parallel_mp4.log --resume-failed -a "$filename" node bbb-mp4 &
