#!/bin/bash

find mp4/ -name "*.mp4" -exec sh -c "echo '{}\t\c' >> mp4_errors.log; ffmpeg -v error -i '{}' -map 0:1 -f null - 2>> mp4_errors.log;echo ''>>mp4_errors.log" \;
