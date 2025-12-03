#!/bin/bash

echo "File was accessed $(date)" >> /home/chris.saunders-loc/Toolkit/SYS-320/Week13/fileAccessLog.txt

echo "To: christopher.saunders@mymail.champlain.edu" > /home/chris.saunders-loc/Toolkit/SYS-320/Week13/accessemail.txt
echo "Subject: Access Log" >> /home/chris.saunders-loc/Toolkit/SYS-320/Week13/accessemail.txt
echo "" >> /home/chris.saunders-loc/Toolkit/SYS-320/Week13/accessemail.txt
cat /home/chris.saunders-loc/Toolkit/SYS-320/Week13/fileAccessLog.txt >> /home/chris.saunders-loc/Toolkit/SYS-320/Week13/accessemail.txt
cat /home/chris.saunders-loc/Toolkit/SYS-320/Week13/accessemail.txt | ssmtp christopher.saunders@mymail.champlain.edu
