# script used to start a single q process
# can be run in two modes: 
# 	non-interactive - process runs in the background
#	interactice - opens an interactive q terminal 
# utilizes the shflags library located on github: https://github.com/kward/shflags
# needs to source the config.profile to parse scripts and q commands

# source the config profile
echo "Sourcing config.profile"
source ../config/config.profile

# source shflags 
echo "Sourcing shflags"
. ../config/shflags-master/shflags

# define flags
DEFINE_boolean 'debug' false 'enable debug mode' 'd'
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

# use name and convert to config profile values
PROCESS=`echo $1 | tr [:lower:] [:upper:]`

case $PROCESS in 
	TP) COMM="${QEXEC} ${TP_SCRIPT} ${TP_COMM_PARAMS} -p ${TP_PORT}";;
	RDB_1) COMM="${QEXEC} ${RDB_1_SCRIPT} ${RDB_1_COMM_PARAMS} -p ${RDB_1_PORT}";;
	RDB_2) COMM="${QEXEC} ${RDB_2_SCRIPT} ${RDB_2_COMM_PARAMS} -p ${RDB_2_PORT}";;
	RTE) COMM="${QEXEC} ${RTE_SCRIPT} ${RTE_COMM_PARAMS} -p ${RTE_PORT}";;
	FEED) COMM="${QEXEC} ${FEED_SCRIPT} ${FEED_COMM_PARAMS} -p ${FEED_PORT}";;
	*) echo "Process: $PROCESS not found! Exiting..."; exit 0;;
esac

# if process already running, do nothing
if [ ! -z $(pgrep -f "${COMM}") ]; then echo "$PROCESS already running!";exit 0;fi

# logic to run process
if [ ${FLAGS_debug} -eq ${FLAGS_TRUE} ]
then
	echo "Entering interactive $PROCESS process"
	rlwrap ${COMM}
else 
	echo "Starting non-interactive $PROCESS process"
	${COMM} -q &
fi
