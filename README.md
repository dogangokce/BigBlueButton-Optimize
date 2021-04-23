# bbb-optimize
BigBlueButton sunucunuzu optimize etmek ve sorunsuz bir şekilde çalıştırmak için, kayıt işleme hızını artırma, dinamik video profili, sayfalandırma, ses kalitesini iyileştirme, 1007/1020 hatalarını düzeltme ve apply-config.sh kullanma gibi teknikleri burada bulabilirsiniz.

Bu değişiklikleri yaptıktan sonra BigBlueButton sunucunuzu yeniden başlatmayı unutmayın.
```sh
bbb-conf --restart
``` 

## Özelleştirmeleri yönetin

BigBlueButton sunucusunun tüm özelleştirmelerini apply-config.sh içinde tutun, böylece (1) tüm BBB sunucularınız aynı özelleştirmelere hatasız bir şekilde sahip olur ve (2) yükseltme sırasında bunları kaybetmezsiniz.

Xml dosyalarını güncellemek için XMLStarlet ve metin dosyalarını güncellemek için sed kullanıyoruz.

```sh
sudo apt-get update -y
sudo apt-get install -y xmlstarlet
git clone https://github.com/dogangokce/BigBlueButton-Optimize.git
Firma 1 kurulumu için
cd BigBlueButton-Optimize/firma1
Firma 2 kurulumu için
cd BigBlueButton-Optimize/firma2
cp apply-config-sample.sh apply-config.sh
chmod 755 replace-config.sh

# PUBLIC_IP'yi BBB sunucunuzun genel IP'sine ayarlamak için apply-config.sh dosyasını düzenleyin

# Değişiklikleri uygulayın ve BBB'yi yeniden başlatın File Zilla Uygulamasını aç dosyayı 755 izinlere getir
chmod +x ./replace-config.sh
chmod +x ./kur.sh
./replace-config.sh
./kur.sh

```
...
## NOT Problem Olursa Kullanın Gitup projenizden indirilen ve /root/BigBlueButton-Optimize diye oluşan klasörü sunucudan silmek içindir
```sh
rm -r /BigBlueButton-Optimize
```

 
'apply-config.sh' dosyasını uygun şekilde düzenleyin. Her bir özelleştirmeyle ilgili yorumlar, her birinin anlamını anlamanıza yardımcı olacak ve varsayılan değerleri değiştirebileceksiniz.
## Markanızla eşleştirin
```sh
cp default.pdf /var/www/bigbluebutton-default/
cp favicon.ico /var/www/bigbluebutton-default/
cp default.pptx /var/www/bigbluebutton-default/
cp index.html /var/www/bigbluebutton-default/
cp tr_TR.json /usr/share/meteor/bundle/programs/server/assets/app/locales/
cp logo.png /var/bigbluebutton/playback/presentation/2.0/
cp /sesler/conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/48000/
cp /sesler/conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/32000/
cp /sesler/conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/16000/
cp /sesler/conf-enter_conf_pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-entry_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-exit_sound.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-goodbye.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-has_joined.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-has_left.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-is-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-is-unlocked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-kicked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-listener_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-listeners_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-locked.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-members_in_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-number_of_listeners.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-one_other_member_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-one_other_person_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-other_persons_conference.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-unmuted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-welcome.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-you_are_already_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-you_are_now_bidirectionally_muted.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-alone.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-bad-pin.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-conference_is_full.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-conference_is_in_qna_mode.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-conference_will_start_shortly.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
cp /sesler/conf-enter_conf_number.wav /opt/freeswitch/share/freeswitch/sounds/en/us/callie/conference/8000/
bbb-conf --restart
```
Varsayılan BigBlueButton kurulumunu markanızla eşleşecek şekilde aşağıdaki şekillerde güncelleyebilirsiniz:
1. Sunum alanında görünecek varsayılan PDF
2. Site simgesi olarak görünecek logo (favicon biçimi)
3. "Hakkında" bölümünde görünen uygulama adı - sağ taraftaki menü
4. Genel sohbet alanında görünecek hoş geldiniz mesajı
5. Bir kullanıcı bir sınıftan çıkış yaptığında görünen index.html. Kendi sürümünüzü oluşturun ve `/ var / www / bigbluebutton-default / '' içine koyun.

Ek olarak, apply-config.sh içinde aşağıdaki öğeleri değiştirebilirsiniz:
1. clientTitle
2. appName
3. copyright
4. helpLink
## Kayıt işleme hızını değiştir
```sh
vi /usr/local/bigbluebutton/core/lib/recordandplayback/generators/video.rb
```
Kayıt işlem süresini 5-6 kat hızlandırmak için satır 58 ve satır 124'te aşağıdaki değişiklikleri yapın:
`-quality realtime -speed 5 -tile-columns 2 -threads 4`

[Referans](https://github.com/bigbluebutton/bigbluebutton/issues/8770)

Lütfen BigBlueButton'da canlı devam eden sınıfların performansını etkileyebilecek daha fazla CPU kullandığını unutmayın.

Bu nedenle, bu değişiklikle birlikte kayıtlar için dahili işleme programını değiştirmek daha iyidir. 

## Kayıtları oynatmak için MP4 formatını kullanın
Sunum oynatma formatı, oturum sırasında paylaşılan videoyu (web kamerası ve ekran paylaşımı) .webm (VP8) dosyaları olarak kodlar.

Biçimi iki nedenle MP4 olarak değiştirebilirsiniz: (1) kayıt işleme hızını artırın ve (2) iOS cihazlarda kayıtların oynatılmasını etkinleştirin.

`/usr/local/bigbluebutton/core/scripts/presentation.yml` düzenleyin ve mp4 için girişi kaldırın.
video_formats:
```sh 
#- webm
- mp4
```

## Dinamik Video Profili

aka otomatik bit hızı / kare hızı azaltma. Bir toplantıdaki kamera sayısına göre ölçeklenen kamera kare hızını ve bit hızını kontrol etmek için.
Birçok kameralı toplantılarda sunucu VE istemci CPU / bant genişliği kullanımını azaltmak için. Bu PR ile yanıt verme, CPU kullanımı ve bant genişliği kullanımında (daha iyisi için) önemli farklara yol açar.

`/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml` ayarlayın
```sh
cameraQualityThresholds:
      enabled: true
```

## Video Sayfalandırma

Tek seferde toplantı katılımcılarının görebileceği web kamerası sayısını kontrol edebilirsiniz.

 `/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml` ayarlayın
```sh
pagination:
  enabled: true
```

## Daha iyi ses kalitesi yayınlayın
`/usr/local/bigbluebutton/bbb-webrtc-sfu/config/default.yml` ve aşağıdaki değişiklikleri yapın
```sh
maxaveragebitrate: "256000"
maxplaybackrate: "48000"
```

`/opt/freeswitch/etc/freeswitch/autoload_configs/conference.conf.xml` ve aşağıdaki değişiklikleri yapın
```sh
<param name="interval" value="20"/>
<param name="channels" value="2"/>
<param name="energy-level" value="100"/>
```

`/opt/freeswitch/etc/freeswitch/dialplan/default/bbb_conference.xml` mevcut kodu kaldırarak aşağıdaki kodu kopyalayıp yapıştırın
```xml
<?xml version="1.0" encoding="UTF-8"?>
<include>
   <extension name="bbb_conferences_ws">
      <condition field="${bbb_authorized}" expression="true" break="on-false" />
      <condition field="${sip_via_protocol}" expression="^wss?$" />
      <condition field="destination_number" expression="^(\d{5,11})$">
         <action application="set" data="jitterbuffer_msec=60:120:20" />
         <action application="set" data="rtp_jitter_buffer_plc=true" />
         <action application="set" data="rtp_jitter_buffer_during_bridge=true" />
         <action application="set" data="suppress_cng=true" />
         <action application="answer" />
         <action application="conference" data="$1@cdquality" />
      </condition>
   </extension>
   <extension name="bbb_conferences">
      <condition field="${bbb_authorized}" expression="true" break="on-false" />
      <condition field="destination_number" expression="^(\d{5,11})$">
         <action application="set" data="jitterbuffer_msec=60:120:20" />
         <action application="set" data="rtp_jitter_buffer_plc=true" />
         <action application="set" data="rtp_jitter_buffer_during_bridge=true" />
         <action application="set" data="suppress_cng=true" />
         <action application="answer" />
         <action application="conference" data="$1@cdquality" />
      </condition>
   </extension>
</include>
```
`/opt/freeswitch/etc/freeswitch/autoload_configs/opus.conf.xml` mevcut kodu kaldırarak aşağıdaki kodu kopyalayıp yapıştırın

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration name="opus.conf">
   <settings>
      <param name="use-vbr" value="1" />
      <param name="use-dtx" value="0" />
      <param name="complexity" value="10" />
      <param name="packet-loss-percent" value="15" />
      <param name="keep-fec-enabled" value="1" />
      <param name="use-jb-lookahead" value="1" />
      <param name="advertise-useinbandfec" value="1" />
      <param name="adjust-bitrate" value="1" />
      <param name="maxaveragebitrate" value="256000" />
      <param name="maxplaybackrate" value="48000" />
      <param name="sprop-maxcapturerate" value="48000" />
      <param name="sprop-stereo" value="1" />
      <param name="negotiate-bitrate" value="1" />
   </settings>
</configuration>
```

[Referans](https://groups.google.com/g/bigbluebutton-setup/c/3Y7VBllwpX0/m/41X9j8bvCAAJ)

## Üç paralel Kurento medya sunucusu çalıştırın

BigBluebutton 2.2.24'te (ve 2.2.x'in sonraki sürümlerinde) mevcuttur

Her tür medya akışına ayrılmış üç paralel Kurento medya sunucusu (KMS) çalıştırmak, medya akışlarını başlatma / durdurma yükü üç ayrı KMS işlemine yayılırken medya işlemenin kararlılığını artırır. Ayrıca, bir KMS'nin çökmesi (ve otomatik yeniden başlatma) nedeniyle ortam işlemenin güvenilirliğini artırır, ikisini etkilemez.

Deneyimlerimize göre, CPU kullanımının 3 KMS sunucusuna yayıldığını ve bunun daha iyi bir kullanıcı deneyimi sağladığını gördük. Bu nedenle, kesinlikle tavsiye ediyoruz.

3 KMS'yi etkinleştirmek için gereken değişiklik, bu projeye dahil edilen apply-config-sample.sh dosyamızın bir parçasıdır.

## Kaydı Optimize Edin

### Birden çok kaydı işleyin

Bu PK'da açıklanan değişiklikleri yapın: [Add option to rap-process-worker to accept a filtering pattern](https://github.com/bigbluebutton/bigbluebutton/pull/8394)

```sh
Düzenle /usr/lib/systemd/system/bbb-rap-process-worker.service and set the command to: ExecStart=/usr/local/bigbluebutton/core/scripts/rap-process-worker.rb -p "[0-4]$"
Koplaya /usr/lib/systemd/system/bbb-rap-process-worker.service to /usr/lib/systemd/system/bbb-rap-process-worker-2.service
Düzenle /usr/lib/systemd/system/bbb-rap-process-worker-2.service and set the command to ExecStart=/usr/local/bigbluebutton/core/scripts/rap-process-worker.rb -p "[5-9]$"
Düzenle /usr/lib/systemd/system/bbb-record-core.target and add bbb-rap-process-worker-2.service to the list of services in Wants
Düzenle /usr/bin/bbb-record, search for bbb-rap-process-worker.service and add bbb-rap-process-worker-2.service next to it to monitor
```

Ayrıca, uygulamasının güncellenmiş sürümünü `rap-process-worker.rb` için  [buraya](https://github.com/daronco/bigbluebutton/blob/9e5c386e6f89303c3f15f4552a8302d2e278d057/record-and-playback/core/scripts/rap-process-worker.rb) aşağıdaki konuma `/usr/local/bigbluebutton/core/scripts`

Doğru dosya iznini sağlayın `chmod +x rap-process-worker.rb`

Yukarıdaki değişiklikleri yaptıktan sonra kayıt işlemini yeniden başlatın:
```sh
systemctl daemon-reload 	
systemctl stop bbb-rap-process-worker.service bbb-record-core.timer 	
systemctl start bbb-record-core.timer
```

Yukarıdaki değişikliklerin uygulandığını doğrulamak için aşağıdakileri uygulayın:
```sh
ps aux | grep rap-process-worker
```

Aşağıdaki iki işlemi görmelisiniz:
```sh
/usr/bin/ruby /usr/local/bigbluebutton/core/scripts/rap-process-worker.rb -p [5-9]$
/usr/bin/ruby /usr/local/bigbluebutton/core/scripts/rap-process-worker.rb -p [0-4]$
```
Yukarıdaki iki işlemin çalıştığını görmüyorsanız, büyük olasılıkla işlenecek herhangi bir kaydınız yoktur. API-MATE kullanarak bir test sınıfı kaydetmek ve test sınıfının bitiminden sonra yukarıdaki iki işlemin çalışmaya başlayıp başlamadığını kontrol etmek isteyebilirsiniz.

### Yayınlanmış kayıtları bir scalelite'den diğerine aktarın

Mevcut, önceden yayınlanmış kayıtları bir Scalelite sunucusundan başka bir Scalelite sunucusuna taşımak için aşağıdaki adımları izleyin:
* formda bir yol ile eski klasörden bir tar dosyası oluşturun `presentation/<recording-id>/...`
* Bu tar dosyasını panoya kopyalayın: `/mnt/scalelite-recordings/var/bigbluebutton/spool/` Yeni scalelite sunucusunda
* Kısa bir süre sonra (birkaç dakika) kayıt otomatik olarak yayınlanan klasöre aktarılır. `scalelite-recording-importer` Docker servisi

### Sorun giderme

Belirli bir kaydın işlenmesini araştırmak için günlük dosyalarına bakabilirsiniz.

`/var/log/bigbluebutton/bbb-rap-worker` günlüğü, kayıt işleminin hangi bölümünün başarısız olduğunu bulmak için kullanılabilen genel bir günlük dosyasıdır. Ayrıca, moderatör kayıt düğmesine basmadığı için bir kayıt işlemi atlanırsa bir mesaj kaydeder.
Belirli bir kayıtla ilgili bir hatayı araştırmak için aşağıdaki günlük dosyalarını kontrol edin:
```sh
/var/log/bigbluebutton/archive-<recordingid>.log
/var/log/bigbluebutton/<workflow>/process-<recordingid>.log
/var/log/bigbluebutton/<workflow>/publish-<recordingid>.log
```

#### Boş Disk Alanını Kontrol Edin
Kayıtla ilgili yaygın bir sorun, sunucunuzun boş disk alanının tükenmesidir. Disk alanı kullanımını şu şekilde kontrol edebilirsiniz:

```sh
apt install ncdu
cd /var/bigbluebutton/published/presentation/
# On Scalelite server, check /mnt/scalelite-recordings/var/bigbluebutton/published/presentation for recordings
ncdu
``` 

Günlük dosyalarının kullandığı disk alanını da kontrol etmelisiniz. `/var/log/bigbluebutton` ve `/opt/freeswitch/log`. 

## 1007 ve 1020 hatalarını düzeltin

Kullanıcılarınızın bir güvenlik duvarı arkasında olmaları durumunda bildirebilecekleri 1007/1020 hatalarını çözmek için aşağıdaki adımları izleyin.

#### 1. Güncelle `external.xml` ve `vars.xml`
`/opt/freeswitch/etc/freeswitch/sip_profiles/external.xml` ve değiştir
```xml
<param name="ext-rtp-ip" value="$${local_ip_v4}"/>
<param name="ext-sip-ip" value="$${local_ip_v4}"/>
```
To 
```xml
<param name="ext-rtp-ip" value="$${external_rtp_ip}"/>
<param name="ext-sip-ip" value="$${external_sip_ip}"/>
```

`/opt/freeswitch/etc/freeswitch/vars.xml`, ve değiştir
```xml
<X-PRE-PROCESS cmd="set" data="external_rtp_ip=stun:stun.freeswitch.org"/>
<X-PRE-PROCESS cmd="set" data="external_sip_ip=stun:stun.freeswitch.org"/>
```
To 
```xml
<X-PRE-PROCESS cmd="set" data="external_rtp_ip=EXTERNAL_IP_ADDRESS"/>
<X-PRE-PROCESS cmd="set" data="external_sip_ip=EXTERNAL_IP_ADDRESS"/>
```

#### 2. Turn sunucusunun erişilebilir olduğunu doğrulayın
Turn sunucusuna BBB sunucunuzdan erişilebildiğini doğrulayın. 0x0001c kodunu alırsanız, STUN çalışmıyor demektir. BBB sunucunuzda oturum açın ve aşağıdaki komutu yürütün: 

```sh
sudo apt install stun-client
stun <your-turn-server>
```
İşte bir Stun sunucusunun, Google'ın genel Stun sunucusuna (stun.l.google.com:19302) BBB sunucunuzdan erişilip erişilemediğini test etmenin başka bir yolu.

Localport, BBB sunucunuzdaki herhangi bir kullanılabilir UDP bağlantı noktası olabilir.

```sh
sudo apt-get install -y stuntman-client 

stunclient --mode full --localport 30000 <your-turn-server> <your-turn-server-port>

```
Çıktınız aşağıdaki gibi olmalıdır:

```sh
Binding test: success
Local address: <your-turn-server-ip>:30000
Mapped address: <your-turn-server-ip>:30000
Behavior test: success
Nat behavior: Direct Mapping
Filtering test: success
Nat filtering: Endpoint Independent Filtering
```

Talimatı izleyerek BigBlueButton'ı coturn sunucusunu kullanacak şekilde yapılandırın [burada](https://docs.bigbluebutton.org/2.2/setup-turn-server.html#configure-bigbluebutton-to-use-the-coturn-server)

#### 3. Turn (Coturn) sunucusunu kurun:

Turn sunucusunu kurmak ve yapılandırmak için [Buradaki](https://docs.bigbluebutton.org/2.2/setup-turn-server.html) talimatları izleyin. `/etc/turnserver.conf` denildği gibi.

```sh
listening-port=80 # Bazı kullanıcılar, güvenlik duvarları nedeniyle 80 ve 443 dışındaki herhangi bir bağlantı noktasına bağlanamayabilir.
tls-listening-port=443
alt-listening-port=3478
alt-tls-listening-port=5349
realm=FQDN of Turn server
listening-ip=0.0.0.0
external-ip=Public-IP-of-Turn-server
# `/etc/turnserver.conf`. düzenleyerek syslog'a giriş yapın. Referans - https://github.com/bigbluebutton/bbb-install/issues/163
sistem günlüğü
```


Coturn sunucusu için 80 ve 443 portlarını kullanıyoruz. Coturn sunucusu varsayılan olarak kök yetkilendirmelerle çalışmadığından, hizmetlerini ayrıcalıklı bağlantı noktalarına (bağlantı noktası aralığı <1024) bağlamamalıdır. Bu nedenle, dosyayı düzenleyin `/lib/systemd/system/coturn.service` yürüterek `systemctl edit --full coturn` ve aşağıdakileri `[Service]`Bölümüne ekleyn

```sh
AmbientCapabilities=CAP_NET_BIND_SERVICE
# After saving, execute `systemctl daemon-reload`
# In case file /lib/systemd/system/coturn.service doesn’t exist, follow the tip here: https://stackoverflow.com/questions/47189606/configuration-coturn-on-ubuntu-not-working
```

Sertifikaların sahipliğini değiştir

```sh
# Turn.higheredlab.com'u coturn sunucunuzun FQDN'sine değiştirin
chown -hR turnserver:turnserver /etc/letsencrypt/archive/turn.higheredlab.com/
chown -hR turnserver:turnserver /etc/letsencrypt/live/turn.higheredlab.com/
```

Turn sunucunuzdaki `ufw` güvenlik duvarının şu bağlantı noktalarına izin verdiğinden emin olun: 80, 443, 3478, 5439 ve 49152: 65535 / udp

Yeniden başlatma sırasında coturn'u otomatik olarak yeniden başlatmak için: `systemctl enable coturn`

Coturn sunucusunu başlatmak için: `systemctl start coturn`

Coturn sunucusunun durumunu kontrol etmek için: `systemctl start coturn`

Günlükleri gerçek zamanlı olarak görüntülemek için: `journalctl -u coturn -f` 

Firefox tarayıcısında TURN'u kullanmaya zorlayabilirsiniz. Bir Firefox sekmesi açın ve "about: config" yazın. 'media.peerconnection.ice.relay_only' araması yapın. Doğru olarak ayarlayın. Bu noktada Firefox yalnızca TURN geçişini kullanır. Şimdi, Turn server'ı çalışırken görmek için bu Firefox tarayıcısı için bir BigBlueButton oturumuna katılın.

Test etmek için Chrome'u kullanma: Yazma `chrome://webrtc-internals` bir Chrome tarayıcısında. Referans: `https://testrtc.com/find-webrtc-active-connection/`

Test amacıyla, coturn sunucusunu aşağıdaki şekilde manuel olarak başlatabilirsiniz: `turnserver -c /etc/turnserver.conf`

#### 4. WebRtcEndpoint.conf.ini'de harici IP ayarlayın
 `/etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini` düzenle

Aşağıdaki satırın açıklamasını kaldırarak ortam sunucusunun harici veya genel IP adresinden bahsedin. Bunu yapmak, medya sunucusu için STUN / TURN'u yapılandırmaya gerek kalmaması avantajına sahiptir.
```sh
externalIPv4=Public-IP-of-BBB-Server
```

STUN / TURN, yalnızca medya sunucusu bir NAT arkasında oturduğunda ve kendi harici IP adresini bulması gerektiğinde gereklidir. Bununla birlikte, yukarıda belirtildiği gibi statik bir harici IP adresi ayarlarsanız, STUN / TURN otomatik keşfine gerek yoktur. Bu nedenle, aşağıdakileri yorumlayın: turn.higheredlab.com'u (IP adresi) kullanarak
```sh
#stunServerAddress=95.217.128.91
#stunServerPort=3478
```

#### 5. Medya görüşme zaman aşımlarınızı doğrulayın.
Önerilen ayara ayarlayın `baseTimeout` to `60000` in `/usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml`


#### 6. Verify Turn is working
Bakın `https://webrtc.github.io/samples/src/content/peerconnection/trickle-ice/` Turn sunucunuzun çalışıp çalışmadığını kontrol edin ve aşağıdaki ayrıntıları girin. Turn server URL'sini Turn server URL'niz olarak değiştirin.
```sh
STUN or TURN URI: turn:turn.higheredlab.com:443?transport=tcp
TURN username:
TURN password: xxxx
```

Kullanıcı adı ve şifre oluşturmak için aşağıdaki kodu uygulayın. Dönüş sunucusundaki "/ etc / turnserver.conf" dosyasındaki "f23xxxea3841c9b91e9accccddde850c61" 'yi "static-auth-secret" ile değiştirin.

```sh
secret=f23xxxea3841c9b91e9accccddde850c61 && \
time=$(date +%s) && \
expiry=8400 && \
username=$(( $time + $expiry )) &&\
echo username:$username && \
echo password : $(echo -n $username | openssl dgst -binary -sha1 -hmac $secret | openssl base64)
```
Ardından 'Add Server' ve ardından 'Gather candidates' butonuna tıklayın. Her şeyi doğru yaptıysanız, nihai sonuç olarak 'Done' yi görmelisiniz. Herhangi bir yanıt alamazsanız veya herhangi bir hata mesajı görürseniz, lütfen yukarıdaki adımları özenle uygulayıp uygulamadığınızı iki kez kontrol edin.

## Greenlight'ın favicon'unu değiştir
```sh
cd greenlight
mkdir cpp
#copy your favicon to greenlight/cpp
vi docker-compose.yml
#add the following line to volumes block and restart greenlight
- ${PWD}/cpp/favicon.ico:/usr/src/app/app/assets/images/favicon.ico
docker-compose down
docker-compose up -d
```

Greenlight'ı BigBlueButton (bbb-install.sh ile -g bayrağıyla) birlikte kurduysanız, favicon'u değiştirmek için yukarıdaki adımları izleyin. Docker-compose.yml içindeki birimleri engellemek için yukarıdaki satırı eklerken boşluk ve sözdizimine dikkat edin

## Kayıtların logosunu ve telif hakkını değiştirin
```sh
# copy your logo.png to /var/bigbluebutton/playback/presentation/2.0
# edit defaultCopyright in /var/bigbluebutton/playback/presentation/2.0/playback.js
```
Kayıt oynatma sırasında logonuzu görmek ister misiniz? Logonuzu yukarıda belirtildiği gibi oynatma dizinine kopyalamanız yeterlidir.

"BigBlueButton ile Kaydedildi" telif hakkı mesajını kaldırmak istiyor musunuz? DefaultCopyright değişkenini playback.js'de düzenleyin.
## GDPR

### Kayıt özelliği olmasın istiyorsanız
```sh
# edit /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
disableRecordingDefault=true
breakoutRoomsRecord=false
```
BigBlueButton'da kayıtlara izin veren bir oda oluşturulduğunda (yani kayıt düğmesi görünür) BigBlueButton tüm oturumu kaydedecektir. Bu, gerçekte basılan kayıt düğmesinden bağımsızdır. Daha basit bir çözüm, kayıtları tamamen durdurmaktır.
 
### Loglar
* [Log rotation](https://docs.bigbluebutton.org/admin/privacy.html#general-log-rotation)
* [BigBlueButton logging](https://docs.bigbluebutton.org/admin/privacy.html#bigbluebutton-logging)
* [Nginx log](https://docs.bigbluebutton.org/admin/privacy.html#nginx)
* [Freeswitch log](https://docs.bigbluebutton.org/admin/privacy.html#freeswitch)
* [Coturn log](https://docs.bigbluebutton.org/admin/privacy.html#coturn)
* [Scalelite log](https://docs.bigbluebutton.org/admin/privacy.html#scalelite-api-container-logs)

### Syslog girişi tutulmasın
```ssh
# Edit /usr/lib/systemd/system/bbb-htlm5.service
StandardOutput=null
# Restart
systemctl daemon-reload
```

## Deneysel

Halen aşağıda belirtilen optimizasyonları test ediyoruz. Lütfen üretim ortamınızda dağıtımdan önce bunların doğru çalıştığından emin olun.

### Kayıtlar için işleme aralığını değiştirin

Normalde BigBlueButton sunucusu, oturum bittikten hemen sonra bir oturumda kaydedilen verileri işlemeye başlar. Ancak, sınıfların başlamasından önce kayıt sürecini durdurarak ve sınıflar bittikten sonra yeniden başlatarak işlemin zamanlamasını değiştirebilirsiniz.

```sh
crontab -e

# Aşağıdaki girişleri ekleyin
# Hafta içi günlerde saat 7'de kaydı durdur
0 7 * * 1-5 systemctl stop bbb-rap-process-worker.service bbb-record-core.timer
# Hafta içi saat 18: 00'de kayda başlayın; bbb-record-core, işleme için gerekli tüm çalışanları otomatik olarak başlatır
0 18 * * 1-5 systemctl start bbb-record-core.timer
```

Yukarıda doğru cron işi planlaması için BBB sunucunuzun saat dilimini kullanıcılarınızınkine değiştirmelisiniz.

```sh
# Mevcut saat dilimi
timedatectl

# List of available timezone
timedatectl list-timezones

# Asya / Kalküta'yı kendi saat diliminizle değiştirerek yeni saat dilimi ayarlayın
timedatectl set-timezone Europe/Istanbul
```

### BBB sunucusunu yeniden başlatın

BBB sunucusunu her gece yeniden başlatmak, herhangi bir zombi süreci veya bellek sızıntısı ile ilgilenir.

Böylece, gece yarısı sunucuyu yeniden başlatmak için bir cron işi ayarlayabilirsiniz. Yeniden başlatıldıktan sonra BBB otomatik olarak başlar. `bbb-conf --check` ve `bbb-conf --status`komutlarını çalıştırdığınızda doğru sonuçları alırsınız.

Ancak, bir toplantı oluşturmaya ve katılmaya çalışın ve bu işe yaramaz. BBB'yi "bbb-conf --restart" ile manuel olarak başlatmanız gerekir ve ardından her şey beklendiği gibi çalışır.  



## BigBlueButton hakkında daha fazla bilgi

BBB'nin özelliklerini daha da genişletmek için aşağıdaki uygulamalara göz atın.

### [bbb-twilio](https://github.com/dogangokce/bbb-twilio)

Twilio'yu BigBlueButton'a entegre edin, böylece kullanıcılar bir arama numarasıyla bir toplantıya katılabilir. Hemen hemen tüm ülkeler için yerel numaralar alabilirsiniz.

### [bbb-mp4](https://github.com/dogangokce/bbb-mp4)

Bu uygulama ile bir BigBlueButton kaydını MP4 videoya dönüştürebilir ve S3'e yükleyebilirsiniz. Birden çok MP4 videosunu paralel olarak dönüştürebilir veya dönüştürme işlemini otomatikleştirebilirsiniz.

### [bbb-streaming](https://github.com/manishkatyan/bbb-streaming)

BigBlueButton sınıflarınızı Youtube veya Facebook'ta binlerce kullanıcınıza canlı yayınlayın.

### [BigBlueButton'da Google'da En Çok Aranan 100 Soru](https://dgnlabs.com/bigbluebutton-guide/)

Fiyatlandırma, Zoom ile karşılaştırma, Moodle entegrasyonları, ölçeklendirme ve düzinelerce sorun giderme dahil BigBlueButton hakkında bilmeniz gereken her şey.


