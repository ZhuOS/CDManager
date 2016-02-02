#!/bin/bash
ff(){
	aa=ss
	
}
ff
echo "$aa"


flag=$(grep -h ^sssshile Records.file)
echo $flag

if [ $flag="" ] 
then
 echo "kong"
fi


exit 0
