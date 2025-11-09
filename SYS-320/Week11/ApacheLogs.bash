#!/bin/bash

file="/var/log/apache2/access.log"

results=$(cat "$file" | cut -d' ' -f1,4,7 | tr -d "[" | grep "page2")

echo "$results"
