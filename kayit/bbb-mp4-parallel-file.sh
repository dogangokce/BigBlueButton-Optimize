#!/bin/bash

#Verilen dosyadaki işlenmemiş kayıtları okuyun, önceden işlenmiş kayıtları kaldırın ve kalan işlenmemiş kayıtlar için paralel olarak başlayın

#işlenmemiş kayıtların listesinin okunacağı dosya
filename='bbb-unprocessed-recordings.txt'
n=0

#işlenmemiş kayıtları dosya adından okuyun ve bu .mp4 dosyaları mp4 dizininde mevcut değilse, bunları bir geçici dosyaya yazın
while read recording; do
  FILE="mp4/$recording.mp4"
  [ ! -f "$FILE" ] && n=$((n+1)) && echo "$recording"
done < $filename >> "$filename.t"

#temp dosyasını dosya adına yeniden adlandır
mv "$filename.t" "$filename"

echo "$n Unprocessed recording"
echo "$filename dosyasındaki mevcut kayıtlar kaldırıldı"

echo "GNU Parallel kullanarak MP4 dönüşümünü başlatma"
/usr/bin/parallel -j 3 --joblog log/parallel_mp4.log -a "$filename" node bbb-mp4 &
