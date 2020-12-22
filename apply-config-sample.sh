#!/bin/bash
PUBLIC_IP="80.253.245.226"
# Pull in the helper functions for configuring BigBlueButton
source /etc/bigbluebutton/bbb-conf/apply-lib.sh

enableUFWRules
enableMultipleKurentos
echo "  - Setting camera defaults"
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==low).bitrate' 50
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==medium).bitrate' 100
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==high).bitrate' 200
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==hd).bitrate' 300

yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==low).default' true
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==medium).default' false
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==high).default' false
yq w -i $HTML5_CONFIG 'public.kurento.cameraProfiles.(id==hd).default' false

echo "Running three parallel Kurento media server"
enableMultipleKurentos

echo "Make the HTML5 client default"
sed -i 's/attendeesJoinViaHTML5Client=.*/attendeesJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/moderatorsJoinViaHTML5Client=.*/moderatorsJoinViaHTML5Client=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Set Welcome message"
sed -i 's/defaultWelcomeMessage=.*/defaultWelcomeMessage=Hazar Koleji  <b>%%CONFNAME%%</b>! CANLI DERS/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=Daha fazla bilgi <a href="http://hazarkoleji.com" target="_blank"><u>Hazar Koleji</u></a>./g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
#sed -i 's/defaultWelcomeMessageFooter=.*/defaultWelcomeMessageFooter=To join this meeting by phone, dial:<br>  %%DIALNUM%%<br>Then enter %%CONFNUM%% as the conference PIN number./g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

#echo "Set dial in number"
#sed -i 's/defaultDialAccessNumber=.*/defaultDialAccessNumber=+12564725575/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Let Moderators unmute users"
sed -i 's/allowModsToUnmuteUsers=.*/allowModsToUnmuteUsers=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "See other viewers webcams"
sed -i 's/webcamsOnlyForModerator=.*/webcamsOnlyForModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Don't Mute the class on start"
sed -i 's/muteOnStart=.*/muteOnStart=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Saves meeting events even if the meeting is not recorded"
sed -i 's/keepEvents=.*/keepEvents=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Set maximum users per class to 100"
sed -i 's/defaultMaxUsers=.*/defaultMaxUsers=100/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable private chat"
sed -i 's/lockSettingsDisablePrivateChat=.*/lockSettingsDisablePrivateChat=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable public chat"
sed -i 's/lockSettingsDisablePublicChat=.*/lockSettingsDisablePublicChat=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Disable shared note"
sed -i 's/lockSettingsDisableNote=.*/lockSettingsDisableNote=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

# Enabeling this may create audio issue in 2.2.29
echo "Enable mic";
sed -i 's/lockSettingsDisableMic=.*/lockSettingsDisableMic=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "See other users in the Users list"
sed -i 's/lockSettingsHideUserList=.*/lockSettingsHideUserList=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Prevent viewers from sharing webcams"
sed -i 's/lockSettingsDisableCam=.*/lockSettingsDisableCam=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Prevent users from joining classes from multiple devices"
sed -i 's/allowDuplicateExtUserid=.*/allowDuplicateExtUserid=false/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Belirli bir süre sonra moderatör olmadığında canlı dersi sonlandırın. Öğrencilerin kafasını karıştırmasını engeller."
sed -i 's/endWhenNoModerator=.*/endWhenNoModerator=true/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "Maksimum toplantı süresini 120 dakikaya ayarlayın"
sed -i 's/defaultMeetingDuration=.*/defaultMeetingDuration=120/g' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties

echo "No listen only mode"
sed -i 's/listenOnlyMode:.*/listenOnlyMode: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Enable audio check otherwise may face audio issue"
sed -i 's/skipCheck:.*/skipCheck: false/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Client Title"
sed -i 's/clientTitle:.*/clientTitle: Hazar Koleji/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set App Title"
sed -i 's/appName:.*/appName: Hazar Koleji/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Copyright"
sed -i 's/copyright:.*/copyright: "©2020 DGNlabs by Doğan GÖGCE"/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Helplink"
sed -i 's/helpLink:.*/helpLink: http:\/\/hazarkoleji.com\/bigbluebutton-guide#using-bigbluebutton/g' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml

echo "Set Copyright in Playback"
sed -i "s/defaultCopyright = .*/defaultCopyright = \'<p>hazarkoleji.com<\/p>\';/g" /var/bigbluebutton/playback/presentation/2.0/playback.js

echo "Fix till 2.2.30 - https://github.com/bigbluebutton/bigbluebutton/issues/9667"
yq w -i /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml public.media.sipjsHackViaWs true
sed -i 's/https/http/g'  /etc/bigbluebutton/nginx/sip.nginx 
sed -i 's/7443/5066/g'  /etc/bigbluebutton/nginx/sip.nginx 
