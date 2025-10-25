#!bin/bash

IP=$(ip addr show | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
echo "$IP" | grep -v "^127\." | grep -v "\.255$"
