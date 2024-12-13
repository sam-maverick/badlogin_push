#!/bin/bash

#skip failed sudo events
if [[ $1 == *"pam_unix(sudo:auth): authentication failure"* && $1 == *"ruser=yourusername"* && $1 == *"user=yourusername"* ]] ; then
  echo "Authentication failure skipped: $1"
  exit 0
fi

if [[ $1 == *"Invalid verification code"* || $1 == *"authentication failure"* ]] ; then
  echo "$(date) Authentication failure detected: $1" >> $HOME/software/logs/badlogin_pushorsms.log
  echo "Authentication failure detected: $1"
  $HOME/software/code/badlogin_alert.sh &

fi

