#source config.profile 
echo "Sourcing config.profile [../config/config.profile]"
source ../config/config.profile

#source shflags
echo "Sourcing shflags [../config/shflags-master/shflags]"
source ../config/shflags-master/shflags

# define flags
DEFINE_boolean 'force' false 'force process termination' 'f'
DEFINE_boolean 'multi' false 'terminate list of processes' 'm'
FLAGS_HELP="USAGE: $0 [flag] process"

# parse command line
FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

# early exit, display usage
if [ $# -eq 0 ];
then
        echo "ERROR: No arguement provided"
        flags_help
        exit 1
fi

# echo enabled flags
if [[ FLAGS_force -eq FLAGS_true ]];then echo "Force flag enabled, using \"kill -9\"";FORCE="-9";fi

terminate(){
	echo -ne "Terminating PID(s)... "
	x=0; while [[ $x -lt 5 ]];
 	do 
		kill ${FORCE} ${@}
		if [[ -z `ps -hp $@ | awk '{print $1}'` ]];then echo "done";success;fi
		x=$(( $x + 1 ))
		sleep 2
	done
	echo "failed";failure `ps -hp $@ | awk '{print $1}'`
}

success(){
	echo "${PROCESS} terminated"
	exit 0
}

failure(){
	echo "Failed to terminate PID(s): $@"
	exit 0
}

findPID(){
	case $1 in
        	TP) COMM="${QEXEC} ${TP_SCRIPT} ${TP_COMM_PARAMS} -p ${TP_PORT}";;
	        RDB_1) COMM="${QEXEC} ${RDB_1_SCRIPT} ${RDB_1_COMM_PARAMS} -p ${RDB_1_PORT}";;
	        RDB_2) COMM="${QEXEC} ${RDB_2_SCRIPT} ${RDB_2_COMM_PARAMS} -p ${RDB_2_PORT}";;
	        RTE) COMM="${QEXEC} ${RTE_SCRIPT} ${RTE_COMM_PARAMS} -p ${RTE_PORT}";;
	        FEED) COMM="${QEXEC} ${FEED_SCRIPT} ${FEED_COMM_PARAMS} -p ${FEED_PORT}";;
	esac
	if [[ -z $COMM ]];then  echo "";else echo `pgrep -f "${COMM}"`;fi
}

PROCESS=`echo $@ | tr [:lower:] [:upper:]`
PID="";for i in $PROCESS;
do
	echo -ne "Finding pid for ${i}... "
	x=$(findPID $i)
	if [[ -z $x ]];then echo "already stopped";else echo "found [${x}]";PID="$PID $x";fi	
done 

if [[ ! -z $PID ]];then terminate $PID;else echo "No processes to terminate!";fi
