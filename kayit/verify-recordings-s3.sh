#!/bin/bash

#İşlenmemiş dosya adından hangi kayıtların halihazırda S3'e kaydedilmediğini doğrulayın

. ./.env

RECORDING_DIR="$recordingDir"

#İşlenmemiş dosya adından hangi kayıtların halihazırda S3'e kaydedilmediğini doğrulayın
NUM_DAYS=30

#Toplam kayıtları saklamak için bir dosya oluşturun. /var/bigbluebutton/published/presentation/
unprocessedfilename='bbb-unprocessed-recordings.txt'
:> "$unprocessedfilename"

#MP4'ün halihazırda işlenip AWS S3e yüklenmesini sağlamak için bir dosya oluşturun
processedfilename='s3-processed-recordings.txt'
:> "$processedfilename"

#İşlenmemiş kayıtları kaydetmek için bir tmp dosyası oluşturun
unprocessedfilename_temp='bbb-unprocessed-recordings-temp.txt'
:> "$unprocessedfilename_temp"

find "$RECORDING_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $unprocessedfilename
echo "Total recordings over $NUM_DAYS days: "
cat $unprocessedfilename | wc -l

echo "Zaten dönüştürülmüş MP4 dosyalarının S3 ile senkronize olmasını sağlama"
aws s3 sync mp4/ "s3://$S3BucketName"  --acl public-read

aws s3 ls "s3://$S3BucketName" | awk '{ print $4 }' | cut -f 1 -d '.' | egrep '[a-z0-9\-]{54}' > $processedfilename
echo "Zaten işlenmiş MP4: "
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

echo "Henüz MP4'e işlenecek yeni kayıtlar: "
cat $unprocessedfilename | wc -l

#İşleme dosyalarını sil
rm "$processedfilename"
rm "$unprocessedfilename"
