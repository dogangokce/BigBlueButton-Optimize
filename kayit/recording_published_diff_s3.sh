#!/bin/bash

. ./.env

NUM_DAYS=100

#BBB tarafından yayınlanan ancak S3'te olmayan kayıtların listesi
PUBLISHED_DIFF_S3_FILE="recordings_published_diff_S3.txt"
:> "$PUBLISHED_DIFF_S3_FILE"

#BBB tarafından yayınlanan kayıtların listesi
PUBLISHED_FILE='recordings_published_by_BBB.txt'
#Dosyanın var olduğundan ve boş olduğundan emin olun
:> "$PUBLISHED_FILE"

find /var/bigbluebutton/published/presentation/ -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > "$PUBLISHED_FILE"
TOTAL_PUBLISHED_RECRODINGS=$(cat "$PUBLISHED_FILE" | wc -l)
echo "Son $NUM_DAYS günde yayınlanan toplam kayıt: $TOTAL_PUBLISHED_RECRODINGS"


echo "Zaten dönüştürülmüş MP4 dosyalarının S3 ile senkronize olmasını sağlama"
aws s3 sync mp4/ "s3://$S3BucketName"  --acl public-read


#AWS S3'teki kayıtların listesi
S3_FILE='recordings_on_S3.txt'
#Dosyanın var olduğundan ve boş olduğundan emin olun
:> "$S3_FILE"
aws s3 ls "s3://$S3BucketName" | awk '{ print $4 }' | cut -f 1 -d '.' | egrep '[a-z0-9\-]{54}' > "$S3_FILE"

while read published_recording; do
  if grep -q "$published_recording" "$S3_FILE"; then
    #echo "Zaten S3te: $published_recording" 
    :    
  else
    #echo "S3te değil: $published_recording"   
    echo "$published_recording" >> "$PUBLISHED_DIFF_S3_FILE"
  fi
done < "$PUBLISHED_FILE"


PUBLISHED_DIFF_S3_COUNT=$(cat "$PUBLISHED_DIFF_S3_FILE" | wc -l)
echo "Son $NUM_DAYS günde yayınlanan kayıtlar S3te değil: $PUBLISHED_DIFF_S3_COUNT"

rm "$PUBLISHED_FILE" "$S3_FILE"

if [ "$PUBLISHED_DIFF_S3_COUNT" -eq 0 ]; then
  echo "All published recordings on S3"
  rm "$PUBLISHED_DIFF_S3_FILE"
  exit 1
else

  pgrep -f "/usr/bin/parallel" && echo "Paralel zaten çalışıyor. Çıkılıyor." && exit 1
   
  echo "Yayınlanan ancak S3 kayıtlarında değil MP4 dönüşümünü başlatma"
  parallel -j 2 --timeout 200% --joblog log/parallel_mp4.log -a "$PUBLISHED_DIFF_S3_FILE" node bbb-mp4 &
fi  
