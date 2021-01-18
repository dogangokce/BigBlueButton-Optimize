#!/bin/bash
n=0

#MP4 dosyaları oluşturmak istediğiniz kayıtların tarih aralığını belirtin.
#29 Eylül MP4 dosyaları oluşturmak için, başlangıç_tarihi 29 Eylül ve to_date 30 Eylül, yani 1 gün ek olmalıdır
echo "Kayıtları $from_date den $to_date e dönüştürme"
from_date='29 Sep 2020'
to_date='30 Sep 2020'

#Kayıtların yolu /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/ bu komut dosyasını Scalelite üzerinde çalıştırırsanız
#Kayıtların yolu  /var/bigbluebutton/published/presentation bu komut dosyasını BBB üzerinde çalıştırırsanız
recordings_directory='/mnt/scalelite-recordings/var/bigbluebutton/published/presentation/'
echo "$recordings_directory den kayıtları dönüştürme"

#İşlenmemiş kayıtların ekleneceği dosya. Bu kayıtları MP4'e dönüştüreceğiz.
filename='bbb-unprocessed-recordings.txt'
#Dosyanın var olduğundan ve boş olduğundan emin olun
:> "$filename"

for i in $(find "$recordings_directory" -maxdepth 1 -newerct "$from_date" ! -newerct "$to_date" -printf "%f\n"); do
    recording="mp4/$i.mp4"
    [ ! -f "$recording" ] && n=$((n+1)) && echo "#$n $recording not found" && echo "$i" >> "$filename"
done

echo "Paralel olarak 2 MP4 dönüştürme işinin yürütülmesi";
parallel -j 2 --joblog log/parallel_mp4.log --resume-failed -a "$filename" node bbb-mp4 &
