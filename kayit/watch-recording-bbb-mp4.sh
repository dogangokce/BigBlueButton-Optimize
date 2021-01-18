#!/bin/bash

. ./.env

echo "recordingDir: $recordingDir"

echo "Yeni BBB Toplantılarını İzlemek"
echo `date`

DIRECTORY_TO_OBSERVE="$recordingDir"
#Kayit özelliğinin kurulu olduğu dizin
DIRECTORY_BBB_MP4="$BBBMP4Dir"
#toplantı kimliği kalıbı
MEETING_ID="^[0-9a-f]{40}-[[:digit:]]{13}$"

watch() {

  inotifywait -m -r -e create -e moved_to $DIRECTORY_TO_OBSERVE | while read path action file;do


    echo "$(file) dosyasındaki $(path) eylem $(action) içinde tespit edilen tarihi $(date) değiştir"
    convert_mp4 "${file}"

  done

}

# Düğüme giden mutlak yol - bulmak için "hangi düğüm" komutunu çalıştırın
convert_mp4() {

    if [[ $1 =~ $MEETING_ID ]]; 
    then    
      cd $DIRECTORY_BBB_MP4 && nohup /usr/bin/node bbb-mp4.js $1 > "log/$1.log" 2>&1 &
    else 
      echo "Toplantı değil: $1"
    fi

}

# Bu komut dosyası gözetmen tarafından çağrılır.
watch
