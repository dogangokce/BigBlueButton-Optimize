#!/bin/bash

#Read unprocessed recordings from the given file, remove recordings already processed, and start parallel for remaining unprocessed recordings

#file from where list of unprocessed recordings will be read
filename='bbb-unprocessed-recordings.txt'
n=0

#read unprocessed recordings from filename and, if those .mp4 don't exist in mp4 directory, write them in a temp file
while read recording; do
  FILE="mp4/$recording.mp4"
  [ ! -f "$FILE" ] && n=$((n+1)) && echo "$recording"
done < $filename >> "$filename.t"

#rename temp file to filename
mv "$filename.t" "$filename"

echo "$n Unprocessed recording"
echo "Removed existing recordings from $filename"

echo "Starting MP4 conversion using GNU Parallel"
/usr/bin/parallel -j 3 --joblog log/parallel_mp4.log -a "$filename" node bbb-mp4 &
