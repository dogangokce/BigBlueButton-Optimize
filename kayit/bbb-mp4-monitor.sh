#!/bin/bash

top -p $(ps ax | grep bbb-mp4 | awk '{print $1}' | head -n 20 | paste -sd "," -) -d 2 -c
