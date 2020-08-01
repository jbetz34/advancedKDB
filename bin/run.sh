#! /bin/bash

# sourcing config profile
source ../config/config.profile

# functions
showOptions(){

	echo "Options:"
	echo "- TP"
	echo "- RDB_1"
	echo "- RDB_2"
	echo "- RTE"
	echo "- FEED"
	echo ""
	echo "- ALL"
	read -p "Selection: " PROCESS
}

opener(){

	echo "Welcome to Advanced KDB"
	echo "Please select startup mode: "
	echo ""
	echo "- START"
	echo "- STOP"
	echo "- TEST"
	echo ""
	read -p "Selection: " MODE
}

all(){
	for proc in $PROC_LIST;do ./${1} $proc;done
}

# variables
PROC_LIST="TP RDB_1 RDB_2 RTE FEED"

# main function
clear
if [ $# = "0" ];then opener;else MODE=$1;fi
echo $MODE
clear 

#sub functions
if [[ $MODE = "START" ]]
then 
	echo "MODE: START"
	showOptions
	if [ $PROCESS = "ALL" ]; then all startProcess.sh; else ./startProcess.sh $PROCESS; fi

elif [[ $MODE = "STOP" ]]
then
	echo "MODE: STOP"
	showOptions
	if [ $PROCESS = "ALL" ]; then all stopProcess.sh; else ./stopProcess.sh $PROCESS; fi

elif [[ $MODE = "TEST" ]]
then
	echo "MODE: TEST"
	./findProcess.sh
else
	echo "Sorry, that was not one of the options. Please try again."
fi
