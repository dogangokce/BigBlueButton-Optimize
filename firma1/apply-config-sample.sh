#!/bin/bash
# BigBlueButton'ı yapılandırmak için yardımcı işlevleri içeri alın
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

echo "Firewall Ayarlarını yaptırma"
enableUFWRules
echo "  - Kamera varsayılanlarını ayarlama"
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==low).bitrate' 50
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==medium).bitrate' 100
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==high).bitrate' 150
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==hd).bitrate' 200

yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==low).default' true
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==medium).default' false
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==high).default' false
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==hd).default' false

echo "Üç paralel Kurento medya sunucusunu çalıştırma"
enableMultipleKurentos

#Üç paralel Kurento medya sunucusunu devredışı bırakmak istenirse
#echo "Üç paralel Kurento medya sunucusunu çalıştırma"
#disableMultipleKurentos


echo "HTML5 istemcisini varsayılan yapın"
sed -i 's/attendeesJoinViaHTML5Client=.*/attendeesJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/moderatorsJoinViaHTML5Client=.*/moderatorsJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Hoş Geldiniz mesajını ayarlayın"
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=Merhaba, <b>\%\%CONFNAME\%\%<\/b>\ Canlı Dersine Hoşgeldiniz!/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=Daha fazla bilgi hazarkoleji.com /g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

#echo "Numarayı çevirmeyi ayarla"
#sed -i 's/defaultDialAccessNumber=.*/defaultDialAccessNumber=+12564725575/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Moderatörlerin kullanıcıların sesini açmasına izin ver"
sed -i 's/allowModsToUnmuteUsers=.*/allowModsToUnmuteUsers=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Diğer görüntüleyenlerin web kameralarını görün"
sed -i 's/webcamsOnlyForModerator=.*/webcamsOnlyForModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Başlangıçta sınıfı sessize alma"
sed -i 's/muteOnStart=.*/muteOnStart=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Toplantı kaydedilmese bile toplantı olaylarını kaydeder"
sed -i 's/keepEvents=.*/keepEvents=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Sınıf başına maksimum kullanıcıyı 100 olarak ayarlayın"
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=100/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Özel sohbeti devre dışı bırakın"
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Genel sohbeti devre dışı bırakın"
sed -i 's/lockSettingsDisablePublicChat=.*/lockSettingsDisablePublicChat=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Paylaşılan notu devre dışı bırak"
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

# Bunu etkinleştirmek 2.2.29'da ses sorunu yaratabilir.
echo "Mikrofonu etkinleştir";
sed -i 's/lockSettingsDisableMic=.*/lockSettingsDisableMic=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Kullanıcılar listesinde diğer kullanıcıları görün"
sed -i 's/lockSettingsHideUserList=.*/lockSettingsHideUserList=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Görüntüleyenlerin web kameralarını paylaşmasını engelleyin"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Kullanıcıların birden fazla cihazdan sınıflara katılmasını önleyin"
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Belirli bir süre sonra moderatör olmadığında canlı dersi sonlandırın. Öğrencilerin kafasını karıştırmasını engeller."
sed -i 's/endWhenNoModerator=.*/endWhenNoModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Maksimum toplantı süresini 120 dakikaya ayarlayın"
sed -i 's/defaultMeetingDuration=.*/defaultMeetingDuration=120/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Sadece dinleme modu yok"
sed -i 's/listenOnlyMode:.*/listenOnlyMode: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Ses kontrolünü etkinleştirin, aksi takdirde ses sorunuyla karşılaşabilir"
sed -i 's/skipCheck:.*/skipCheck: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "İstemci Başlığını Ayarla"
sed -i 's/clientTitle:.*/clientTitle: Hazar Koleji/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Uygulama Başlığını Ayarla"
sed -i 's/appName:.*/appName: Hazar Koleji/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Telif Hakkını Ayarla"
sed -i 's/copyright:.*/copyright: "©2020 DGNlabs by Doğan GÖGCE"/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Yardım Bağlantısını Ayarla"
sed -i 's/helpLink:.*/helpLink: http:\/\/hazarkoleji.com/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Oynatmada Telif Hakkını Ayarlama"
sed -i "s/defaultCopyright = .*/defaultCopyright = \'<p>hazarkoleji.com<\/p>\';/g" /var/bigbluebutton/playback/presentation/2.0/playback.js

