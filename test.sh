#!/bin/bash



flag=$(grep -h ^sssshile Records.file)
echo $flag

if [ $flag="" ] 
then
 echo "kong"
fi


exit 0
