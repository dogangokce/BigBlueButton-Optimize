#!/bin/bash

. ./.env

echo "copyToPath: $copyToPath"

NUM_DAYS=7

#İşlenmemiş kayıtların ekleneceği dosya. Bu kayıtları MP4'e dönüştüreceğiz.
UNPROCESSED_FILENAME='unprocessed-recordings-local.txt'
#Dosyanın var olduğundan ve boş olduğundan emin olun
:> "$UNPROCESSED_FILENAME"

function_sync_existing_recordings() {
  PROCESSED_FILENAME='processed-recordings-local.txt'

  echo "MP4 kayıtlarının listesini $copyToPath olarak alın"
  find "$copyToPath" -printf "%f\n" | cut -f 1 -d '.' | egrep '[a-z0-9]*-[0-9]*' > "$PROCESSED_FILENAME"

  	
  while read unprocessed_recording; do
    if grep -q "$unprocessed_recording" "$PROCESSED_FILENAME"; then
      #echo "Zaten kaydedildi: $unprocessed_recording"  
      true   
    else
      #echo "Kaydedilmedi: $unprocessed_recording"   
      echo "$unprocessed_recording" >> "$UNPROCESSED_FILENAME.t"
    fi
  done < $UNPROCESSED_FILENAME

 
  #echo "Henüz işlenmemiş kayıtlarla işlenmemiş dosyayı güncelleme";
  mv "$UNPROCESSED_FILENAME.t" "$UNPROCESSED_FILENAME"

  #echo "İşlenmeye hazır, işlenmemiş kayıtlar güncellendi.";
  rm "$PROCESSED_FILENAME"
}


find "$recordingDir" -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > "$UNPROCESSED_FILENAME"

TOTAL_RECRODINGS=$(cat "$UNPROCESSED_FILENAME" | wc -l)
echo "Son $NUM_DAYS güne ait toplam kayıt: $TOTAL_RECRODINGS"

function_sync_existing_recordings

TOTAL_UNPROCESSED_RECRODINGS=$(cat "$UNPROCESSED_FILENAME" | wc -l)
echo "Unprocessed recordings the last $NUM_DAYS day: $TOTAL_UNPROCESSED_RECRODINGS"

if [ $TOTAL_UNPROCESSED_RECRODINGS -eq 0 ]; 
then
  echo "Tüm kayıtlar tamamlandı"
  exit 1
else

  pgrep -f "/usr/bin/parallel" && echo "Parallel already running. Exiting." && exit 1

  echo "GNU Parallel kullanarak MP4 dönüşümünü başlatma"
  parallel -j 2 --timeout 200% --joblog log/parallel_mp4.log -a "$UNPROCESSED_FILENAME" node bbb-mp4 &
fi

