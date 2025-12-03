#! /bin/bash

authfile="/var/log/auth.log"

function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,3,11)
 echo "$dateAndUser" 
}

function getFailedLogins(){
 failedlogline=$(cat "$authfile" | grep "authentication failure")
 faileddateAndUser=$(echo "$failedlogline" | cut -d' ' -f1,2,3,16)
 echo "$faileddateAndUser" 
}

# Sending logins as email - Do not forget to change email address
# to your own email address
echo "To: christopher.saunders@mymail.champlain.edu" > emailform.txt
echo "Subject: Logins" >> emailform.txt
echo "" >> emailform.txt
getLogins >> emailform.txt
cat emailform.txt | ssmtp christopher.saunders@mymail.champlain.edu

# Todo - 2
# Send failed logins as email to yourself.
# Similar to sending logins as email
echo "To: christopher.saunders@mymail.champlain.edu" > emailform.txt
echo "Subject: Failed Logins" >> emailform.txt
echo "" >> emailform.txt
getFailedLogins >> emailform.txt
cat emailform.txt | ssmtp christopher.saunders@mymail.champlain.edu
