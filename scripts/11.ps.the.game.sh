#!/bin/bash

echo -E ""
echo -E "Battlen.net Launcher processes =========="
ps aux | grep -Ei 'battlenet|battle|lutris' | grep -v grep | awk '{print $2, $11, $12, $13, $14, $15}'

echo -E ""

echo -E "Starcraft 2 game processes =============="
ps -eo pid,args | grep -i 'SC2Switcher_x64.exe' | grep -v grep | awk '{pid=$1; $1=""; print pid, $0}'

echo -E ""

