#! /bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){

echo -n "Please Input an Instructor Full Name: "
read instName

echo ""
echo "Courses of $instName :"
cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
sed 's/;/ | /g'
echo ""

}

function courseCountofInsts(){

echo ""
echo "Course-Instructor Distribution"
cat "$courseFile" | cut -d';' -f7 | \
grep -v "/" | grep -v "\.\.\." | \
sort -n | uniq -c | sort -n -r 
echo ""

}

function coursesByLocation(){

echo -n "Please input a class location code: "
read locName

echo ""
echo "Courses in $locName :"
cat "$courseFile" | grep "$locName" | \
cut -d';' -f1,2,5,6,7 | sed 's/;/ | /g'

}

function coursesByAvailability(){

echo -n "Please input a class code: "
read className

echo ""
echo "Courses in the $className section:"
cat "$courseFile" | \
sed 's/;/ | /g' | grep "$className"

}

while :
do
	echo ""
	echo "Please select and option:"
	echo "[1] Display courses of an instructor"
	echo "[2] Display course count of instructors"
	echo "[3] Display courses by location"
	echo "[4] Display courses by availability"
	echo "[5] Exit"

	read userInput
	echo ""

	if [[ "$userInput" == "5" ]]; then
		echo "Goodbye"
		break

	elif [[ "$userInput" == "1" ]]; then
		displayCoursesofInst

	elif [[ "$userInput" == "2" ]]; then
		courseCountofInsts

        elif [[ "$userInput" == "3" ]]; then
                 coursesByLocation

        elif [[ "$userInput" == "4" ]]; then
                 coursesByAvailability

	else
		echo "Invalid Input!!! Try Again"
	fi
done
