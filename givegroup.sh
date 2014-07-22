#!/bin/bash

#This script gives userwise classification of groups. 
#It shows each user and which all groups he/she belongs to.
#Use Tab as the delimiter while opening in Excel

ldapsearch -x | grep cn= | awk -F "=|," '{print $2}' > groups.txt
ldapsearch -x | grep mail: | awk '{print $2}' > mail.txt

if [ -s "result.csv" ]; then
        rm result.csv
        echo "Already existing output file deleted"
fi
echo "Creating new output file (result.csv)"


while read line1
do
	email=$line1
	echo "$email:" >> result.csv
	while read line2
	do
		searchresult=$(ldapsearch -x cn=$line2 | grep maildrop: | grep $email | awk '{print $2}')
		if [ -n "$searchresult" ]; then
			echo "	$line2" >> result.csv
		fi
	done < groups.txt
done < mail.txt

rm groups.txt
rm mail.txt

echo "New result.csv file created"
echo "Remember to use Tab as the delimiter when opening in Excel"
echo "Thank you!"

echo "The output file is mailed"

cp result.csv /tmp/
(uuencode /tmp/result.csv result.csv; echo "PFA the list of users with all the groups they belong to") | mailx -s "List of all users with the groups they belong to" -a "From:toadmin@abc.
com" "user@abc.com"
