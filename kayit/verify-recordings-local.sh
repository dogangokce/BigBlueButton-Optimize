#!/bin/bash

. ./.env

MP4_DIR="$copyToPath"
RECORDING_DIR="$recordingDir"

#Kayıtların doğrulanacağı gün sayısı
NUM_DAYS=15

#MP4ün halihazırda işlenmiş ve yerel olarak şurada depolanması için bir dosya oluşturun ./mp4
processedfilename='local-processed-recordings.txt'
:> "$processedfilename"

#Toplam kayıtları saklamak için bir dosya oluşturun. /var/bigbluebutton/published/presentation/
unprocessedfilename='bbb-unprocessed-recordings.txt'
:> "$unprocessedfilename"

#İşlenmemiş kayıtları kaydetmek için bir tmp dosyası oluşturun
unprocessedfilename_temp='bbb-unprocessed-recordings-temp.txt'
:> "$unprocessedfilename_temp"


find "$RECORDING_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $unprocessedfilename
echo "Total recordings over 15 days: "
cat $unprocessedfilename | wc -l

find "$MP4_DIR" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > $processedfilename
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

#Delete processing files
rm "$processedfilename"
rm "$unprocessedfilename"
