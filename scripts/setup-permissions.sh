#!/bin/bash


find /config -type f -name "*.keystore" -print -exec chmod go-wrx {} \;
