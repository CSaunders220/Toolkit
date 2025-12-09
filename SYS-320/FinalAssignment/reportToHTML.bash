#!/bin/bash

report=./report.txt
echo "<html>\n<body>\nAccess logs with IOC Indicators:\n<table>" > report.html

while IFS= read -r line
do
echo "<tr>" >> report.html
echo "$line" | sed 's/ /<td>/g' >> report.html
echo "</tr>" >> report.html
done < "$report"
