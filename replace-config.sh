#!/bin/bash

echo "BBB'deki varsayılan apply-conf.sh'yi özelleştirilmiş sürümünüzle değiştirme"
cp apply-config.sh /etc/bigbluebutton/bbb-conf/apply-config.sh

echo "bbb yeniden başlatılıyor"
bbb-conf --restart
