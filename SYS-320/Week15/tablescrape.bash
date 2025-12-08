#!/bin/bash

URL="http://10.0.17.25/Assignment.html"

html=$(curl -s "$URL")

echo "Temperature, Pressure, Date-Time"
echo "========================================="
echo "$html" | grep -oP '<td>\K[^<]+' | paste - - | \
awk 'NR<=5{t[NR]=$1; d[NR]=$2} NR>5 && NR<=10{print t[NR-5], $1, d[NR-5]}' | \
column -t -s','
