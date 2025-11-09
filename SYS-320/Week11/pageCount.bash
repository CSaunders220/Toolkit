#!/bin/bash

file="/var/log/apache2/access.log"

function pageCounts() {
  awk '{print $7}' "$file" | sort | uniq -c | sort -nr
}

function curlCounts() {
  cat "$file" | cut -d' ' -f1,12 |tr -d "[" | grep "curl" | sort | uniq -c | sort -nr
}

pageCounts
echo "---------------------------------------------------------------"
curlCounts
