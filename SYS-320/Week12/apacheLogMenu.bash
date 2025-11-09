#! /bin/bash

logFile="./access.txt"
ioc="./ioc.txt"
userAgents="./userAgents.txt"

function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function histogram(){

	local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
	# This is for debugging, print here to see what it does to continue:
	# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
	echo "$visitsPerDay" | while read -r line;
	do
		local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
		local IP=$(echo "$line" | cut -d  " " -f 1)

		local newLine="$IP $withoutHours"
		echo "$IP $withoutHours" >> newtemp.txt
	done
	cat "newtemp.txt" | sort -n | uniq -c
}

function pageVisits(){
	local pages=$(cat "$logFile" | cut -d " " -f 7 | sort  | uniq -c | sort -n -r)
	echo "$pages"
}

function frequentVisits(){
	local visits=$(cat "$logFile" | awk '{print $1 "\t" $7}' | sort | uniq -c | awk '$1 > 10 {print $0}' | sort -n -r)
	echo "$visits"
}

function susVisits(){
	local susLogs=$(cat "$logFile" | egrep -i -f "$ioc" | cut -d " " -f 1 | sort | uniq -c | sort -n -r)
	local susAgents=$(cat "$logFile" | egrep -v -f "$userAgents" | cut -d " " -f 1 | sort | uniq -c | sort -n -r)
	echo "$susLogs"
	echo "$susAgents"
}

# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with this indicators of attack
# only display the unique count of IP addresses.
# Hint: there are examples in slides

# Keep in mind that I have selected long way of doing things to
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
	echo ""
	echo "PLease select an option:"
	echo "[1] Display all Logs"
	echo "[2] Display only IPS"
	echo "[3] Display only Pages Visited"
	echo "[4] Histogram"
	echo "[5] Display Frequent Visitors"
	echo "[6] Display Suspicious Visitors"
	echo "[7] Quit"

	read userInput
	echo ""

	if [[ "$userInput" == "7" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		echo "Displaying all logs:"
		displayAllLogs

	elif [[ "$userInput" == "2" ]]; then
		echo "Displaying only IPS:"
		displayOnlyIPs

	elif [[ "$userInput" == "3" ]]; then
		echo "Displaying pages visited:"
		pageVisits

	elif [[ "$userInput" == "4" ]]; then
		echo "Histogram:"
		histogram

	elif [[ "$userInput" == "5" ]]; then
		echo "Displaying Frequent Visitors:"
		frequentVisits

	elif [[ "$userInput" == "6" ]]; then
		echo "Displaying Suspicious Visitors:"
		susVisits

	else
		echo "Invalid input! Please enter a number within the acceptable range..."
        # Display frequent visitors
	# Display suspicious visitors
	# Display a message, if an invalid input is given
	fi
done

