#!/bin/bash

#update
#insert/remove/alter
#find
#play

#task: 添加Tracks时，自动添加Records 

#*********************************************************

insertRecordLine(){
	cdName=$1
	cdType=$2
	cdComposer=$3

	if grep -w -h "$cdName" Records.file; then
		echo "The Record exists."
		return
	else
		set $(wc -l Records.file) #number of lines in records.file
		catalogNum=$1
		catalogNum=$(($catalogNum+1))
		echo "CD${catalogNum} $cdName $cdType $cdComposer" >> Records.file
		
		cat Records.file | sort > temp.file
		mv temp.file Records.file
		echo "Insert New CD $cdName Success."
		return
	fi
}
insertTrackLine(){
	cdName=$1
	trackName=$2

	recordLine=$(grep -h $cdName Records.file)

	if [ -z "$recordLine" ]  #if no found, add the CD to Records.file
	then
		insertRecordLine $cdName Type-xxx Composer-xxx
	fi
	recordLine=$(grep -h $cdName Records.file)
	set $recordLine
	catalogNum=$1 #目录编号CDXXX
	
	#判断是否存在该曲目
	if grep -h "$trackName$" Tracks.file > temp.file; then	#是否存在曲目名
		echo "	Track Name Exist."	
		if grep -h $catalogNum temp.file; then	#是否存在唱片目录编号
			echo "The Track Exist." 	#存在该曲目，退出.
			return 									
		fi
	fi
	rm -f temp.file
	
	echo "	test $catalogNum"
	grep  "^$catalogNum" Tracks.file > temp_insert_track.file
	set $(wc -l temp_insert_track.file)
	rm -f temp_insert_track.file
	
	trackNum=$1 #曲目编号
	trackNum=$(($trackNum+1))
	echo "$catalogNum $trackNum $trackName" >> Tracks.file
	cat Tracks.file | sort > temp.file
	mv temp.file Tracks.file
	
	return
}
insertRecords(){
	echo -e -n "CD-Name Type Composer\n:"
	read lineRecord	
	
	insertRecordLine $lineRecord #insert line to Record.file
	return 
}

insertTracks(){
	echo -e -n "CD-Name Track-Name\n:"
	read lineTrack

	insertTrackLine $lineTrack	#insert line to Tracks.file
	return	
}
#****************************************************
removeRecords(){
	echo -n "Remove CD-Name: "
	read cdName
	if grep -w $cdName Records.file > /dev/null; then
		cdLine=$(grep -h $cdName Records.file)
		set $cdLine

		grep -h -v -w "$cdName" Records.file > temp.file 
		mv temp.file Records.file 
		
		grep -h -v -w $1 Tracks.file > temp.file
		mv temp.file Tracks.file
		echo "Remove CD Success"
		return
	else
		echo "No Such CD"
		return
	fi
}

removeTracks(){
	echo -n "Remove Track: " 
	read trackName
	if grep -w $trackName Tracks.file > /dev/null; then
		grep -h -v -w $trackName Tracks.file > temp.file #need to be optimized
		mv temp.file Tracks.file
		echo "Remove Track Success"
		return
	else
		echo "No Such Track"
		return
	fi
}
#******************************************************
# test
alterRecords(){
	echo -n "Choose Catalog-Number: "
	read catalogNum
	grep -h "^$catalogNum" Records.file
	grep -v "^$catalogNum" Records.file > temp.file
	
	echo -n "new Records infomation: "
	read newCDInfo
	echo $newCDInfo >> temp.file
	
	cat temp.file | sort | uniq > Records.file
	rm -f temp.file
	
	return
}
# test
alterTracks(){
	echo -n "alterTracks"
	return
}
#*********************************************************
updateCD(){
while true
do
cat <<!UPDATE!
1.insert records
2.insert tracks
3.remove records
4.remove tracks
5.alter records
6.alter tracks
!UPDATE!
	echo -n ":"
	read updateChoice

	case "$updateChoice" in
	1 )	insertRecords
		break;;
	2 ) insertTracks
		break;;
	3 ) removeRecords
		break;;
	4 ) removeTracks
		break;;
	5 ) alterRecords
		break;;
	6 ) alterTracks
		break;;
	* ) echo "Enter the valid choice";;
	esac
done

return

}
#***********************************************************
findCD() { #同曲目名，不同CD  Bug
	echo -n "Track-Name: "
	read trackName
 	if grep -h [[:blank:]]$trackName$ Tracks.file 
	then
		:
	else
		echo "NO FOUND"
	fi		
	return
}
#************************************************************
# stop playing tracks
stop() {
	playEn=false
	echo "stop $*"
	return
}

# play tracks
playCD() {
	playEn=true
	while true
	do
		echo -n "Track-Name: "
		read trackName 					#当输入空格等控制符号时出现Bug
		trackLine=$(grep -h "$trackName$" Tracks.file)
		if [ -z "$trackLine" ]; then
			echo "No Such Track."	
			continue
		else	
			break
		fi
	done
	echo "ctl+c to stop"
	trap 'stop $trackLine' INT
	
	
	while $playEn
	do
		set $(date)
		echo "|| $trackLine ($5)"
		sleep 1
	done

	return
}

# main function

# variable 
playEn=true

echo "Welcome to CDManager helper! Please choose which help you want to get."
# main loop
while true; do

cat <<!MENU!
1.update
2.find
3.play
4.exit
!MENU!
	echo -n ":"
	read menuChoice

	case "$menuChoice" in
		1 ) updateCD;;
		2 ) findCD;;
		3 ) playCD;;
		4 ) break;;
		* ) echo "wrong input";;

	esac
done
exit 0













































