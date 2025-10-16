#!/bin/bash

source wine.conf

sudo zypper install wine-staging wine-staging-wow64

sudo zypper install wine-gecko wine-mono
sudo zypper install libvulkan1

sudo zypper install gamemode
