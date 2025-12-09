#!/bin/bash

URL=10.0.17.25/IOC.html


curl -s "$URL" | grep -oP '(?<=<td>)[^<]+(?=</td>)' | sed -n '1~2p' > IOC.txt
cat IOC.txt
echo "Web table saved to IOC.txt"
