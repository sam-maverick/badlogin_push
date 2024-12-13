#!/bin/bash

source $HOME/software/code/credentials.txt

echo "" >> $HOME/software/logs/badlogin_pushorsms.log
echo "$(date) Sending alert" >> $HOME/software/logs/badlogin_pushorsms.log

# Uncomment the following line if you want to receive notifications via SMS
#curl --connect-timeout 7200 --retry 6 --retry-delay 60 --get "$SMSPROVIDERURL" --data-urlencode "username=$SMSPROVIDERUSERNAME" --data-urlencode "password=$SMSPROVIDERPASSWORD" --data-urlencode "from=$SMSPROVIDERFROM" --data-urlencode "to=$SMSPROVIDERTO" --data-urlencode "text=Failed login attempt on $SMSPROVIDERCOMPUTERNAME @ $(date)" >> $HOME/software/logs/badlogin_pushorsms.log 2>> $HOME/software/logs/badlogin_pushorsms.log

# Uncomment the following line if you want to receive notifications via push on your phone
curl --connect-timeout 7200 --retry 6 --retry-delay 60 -X "POST" "${PUSHPROVIDERURL}${PUSHPROVIDERAPIKEY}" \
-H 'Content-Type: application/json; charset=utf-8' \
-d "{ \
  \"title\": \"SECURITY EVENT\", \
  \"body\": \"Failed login attempt on ${PUSHPROVIDERCOMPUTERNAME} @ $(date)\", \
  \"timeSensitive\": \"true\" \
}" >> $HOME/software/logs/badlogin_pushorsms.log 2>> $HOME/software/logs/badlogin_pushorsms.log

