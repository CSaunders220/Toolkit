#!/bin/bash

IOCFile=./IOC.txt
LOGFile=./access.log

grep -F -f "$IOCFile" "$LOGFile" | cut -d " " -f 1,4,7 | sed 's/[][]//g' > report.txt
