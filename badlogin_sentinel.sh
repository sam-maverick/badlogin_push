#!/bin/bash

echo "$(date) Bad login sentinel init......................." >> $HOME/software/logs/badlogin_pushorsms.log

echo "$(whoami)" >> $HOME/software/logs/badlogin_pushorsms.log
echo "$(/usr/bin/python3 --version)" >> $HOME/software/logs/badlogin_pushorsms.log

/usr/bin/python3 -u $HOME/software/code/badlogin_sentinel2.py  >> $HOME/software/logs/badlogin_pushorsms.log 2>> $HOME/software/logs/badlogin_pushorsms.log

echo "Exiting..." >> $HOME/software/logs/badlogin_pushorsms.log

