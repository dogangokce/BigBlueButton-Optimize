RUN git clone https://github.com/dogangokce/BigBlueButton-Optimize.git
RUN cd BigBlueButton-Optimize/firma1
RUN cp apply-config-sample.sh apply-config.sh
RUN chmod 755 replace-config.sh
./replace-config.sh
RUN cp default.pdf /var/www/bigbluebutton-default/
RUN cp favicon.ico /var/www/bigbluebutton-default/
RUN cp default.pptx /var/www/bigbluebutton-default/
RUN cp index.html /var/www/bigbluebutton-default/
RUN cp tr_TR.json /usr/share/meteor/bundle/programs/server/assets/app/locales/
RUN cp logo.png /var/bigbluebutton/playback/presentation/2.0/
RUN sudo bbb-conf --restart
