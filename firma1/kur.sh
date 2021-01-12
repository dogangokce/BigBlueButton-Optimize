git clone https://github.com/dogangokce/BigBlueButton-Optimize.git
cd BigBlueButton-Optimize/firma1
cp apply-config-sample.sh apply-config.sh
chmod 755 replace-config.sh
./replace-config.sh
cp default.pdf /var/www/bigbluebutton-default/
cp favicon.ico /var/www/bigbluebutton-default/
cp default.pptx /var/www/bigbluebutton-default/
cp index.html /var/www/bigbluebutton-default/
cp tr_TR.json /usr/share/meteor/bundle/programs/server/assets/app/locales/
cp logo.png /var/bigbluebutton/playback/presentation/2.0/
bbb-conf --restart