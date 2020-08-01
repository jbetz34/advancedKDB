#source config.profile 
source ../config/config.profile

PROCESSES="TP RDB_1 RTE FEED RDB_2"

convert(){
case $1 in
	TP) COMM="${QEXEC} ${TP_SCRIPT} ${TP_COMM_PARAMS} -p ${TP_PORT}";;
	RDB_1) COMM="${QEXEC} ${RDB_1_SCRIPT} ${RDB_1_COMM_PARAMS} -p ${RDB_1_PORT}";;
	RDB_2) COMM="${QEXEC} ${RDB_2_SCRIPT} ${RDB_2_COMM_PARAMS} -p ${RDB_2_PORT}";;
	RTE) COMM="${QEXEC} ${RTE_SCRIPT} ${RTE_COMM_PARAMS} -p ${RTE_PORT}";;
	FEED) COMM="${QEXEC} ${FEED_SCRIPT} ${FEED_COMM_PARAMS} -p ${FEED_PORT}";;
esac
}


echo "Searching for running processes.."
echo "Available processes: "
for i in $PROCESSES;
do
	convert $i
	PID=`pgrep -f "$COMM"`
	if [ ! -z $PID ]; then echo $i;fi
done
