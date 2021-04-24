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

echo "Özel sohbeti devre dışı bırakın"
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Paylaşılan notu devre dışı bırak"
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Belirli bir süre sonra moderatör olmadığında canlı dersi sonlandırın. Öğrencilerin kafasını karıştırmasını engeller."
sed -i 's/endWhenNoModerator=.*/endWhenNoModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "İstemci Başlığını Ayarla"
sed -i 's/clientTitle:.*/clientTitle: idrak Academy/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Uygulama Başlığını Ayarla"
sed -i 's/appName:.*/appName: idrak Academy/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Telif Hakkını Ayarla"
sed -i 's/copyright:.*/copyright: "©2020 DGNlabs by Doğan GÖGCE"/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Yardım Bağlantısını Ayarla"
sed -i 's/helpLink:.*/helpLink: http:\/\/idrakacademy.com/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Oynatmada Telif Hakkını Ayarlama"
sed -i "s/defaultCopyright = .*/defaultCopyright = \'<p>idrakacademy.com<\/p>\';/g" /var/bigbluebutton/playback/presentation/2.0/playback.js
echo "Toplantı kaydedilmese bile toplantı olaylarını kaydeder"
sed -i 's/keepEvents=.*/keepEvents=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Diğer görüntüleyenlerin web kameralarını görün"
sed -i 's/webcamsOnlyForModerator=.*/webcamsOnlyForModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Moderatörlerin kullanıcıların sesini açmasına izin ver"
sed -i 's/allowModsToUnmuteUsers=.*/allowModsToUnmuteUsers=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Hoş Geldiniz mesajını ayarlayın"
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=Merhaba, <b>\%\%CONFNAME\%\%<\/b>\ Canlı Dersine Hoşgeldiniz!/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=Daha fazla bilgi idrakacademy.com /g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "HTML5 istemcisini varsayılan yapın"
sed -i 's/attendeesJoinViaHTML5Client=.*/attendeesJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/moderatorsJoinViaHTML5Client=.*/moderatorsJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo "Sadece Dinle Modu"
sed -i 's/listenOnlyMode:.*/listenOnlyMode: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Yalnızca Dinlemeye zorla"
sed -i 's/forceListenOnly:.*/forceListenOnly: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Ses kontrolünü atlamayı devreye al"
sed -i 's/skipCheck:.*/skipCheck: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Ağ Bilgilerini etkinleştirin"
sed -i 's/enableNetworkInformation:.*/enableNetworkInformation: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Ağ İzlemeyi etkinleştirin"
sed -i 's/enableNetworkMonitoring:.*/enableNetworkMonitoring: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Otomatik Web kamerasını paylaş"
sed -i 's/autoShareWebcam:.*/autoShareWebcam: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo "Video Önizlemesini Atla"
sed -i 's/skipVideoPreview:.*/skipVideoPreview: true/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
cp default.pdf /var/www/bigbluebutton-default/
cp favicon.ico /var/www/bigbluebutton-default/
cp default.pptx /var/www/bigbluebutton-default/
cp index.html /var/www/bigbluebutton-default/
cp tr_TR.json /usr/share/meteor/bundle/programs/server/assets/app/locales/
cp logo.png /var/bigbluebutton/playback/presentation/2.0/
cp conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
bbb-conf --restart


