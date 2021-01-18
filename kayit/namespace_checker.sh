#!/bin/bash

VALUE=$(cat /boot/config-$(uname -r) | grep CONFIG_USER_NS)

if [[ -z "$VALUE" ]]
then
  echo 'Çekirdekte ad alanınız yok. SUID korumalı alanını etkinleştirmeniz veya çekirdeğinizi yükseltmeniz gerekecektir.'
  echo 'Bakın https://chromium.googlesource.com/chromium/src/+/master/docs/linux_suid_sandbox_development.md'
  exit 1
fi

USER_NS_AVAILABLE="${VALUE: -1}"

if [[ "$USER_NS_AVAILABLE" == "y" ]]
then
  exit 0
else
  echo 'Çekirdekte ad alanınız yok. SUID korumalı alanını etkinleştirmeniz veya çekirdeğinizi yükseltmeniz gerekecek.'
  echo 'Bakın https://chromium.googlesource.com/chromium/src/+/master/docs/linux_suid_sandbox_development.md'
  exit 1
fi
