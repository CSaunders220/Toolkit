#!/bin/bash

report=./report.txt
echo "<html><body>Access logs with IOC Indicators:<table><th>IP Address</th><th>Timestamp</th><th>Webpage</th>" > report.html

while IFS= read -r line
do
echo "<tr>" >> report.html
echo "<td>" >> report.html
echo "$line" | sed 's/ /<td>/g' >> report.html
echo "</tr>" >> report.html
done < "$report"
