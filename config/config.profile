### ~~~ LIST OF CONFIGURATION PARAMS ~~~ ###

export MAIN_DIR="/home/james/advancedKDB"
export SCRIPTS_DIR="${MAIN_DIR}/scripts"
export LOG_DIR="${MAIN_DIR}/logdir"
export TP_DIR="${MAIN_DIR}/tplog"
export BIN_DIR="${MAIN_DIR}/bin"
export HDB_DIR="${MAIN_DIR}/hdb"
export CONFIG_DIR="${MAIN_DIR}/config"
export SCHEMAS="${SCRIPTS_DIR}/tick/tables.q"

### ~~~ KDB ENV PARAMS ~~~ ### 

export QHOME="/home/james/q"
export QLIC="${QHOME}"
export QEXEC="${QHOME}/l32/q"

### ~~~ PROCESS PARAMS ~~~ ###

export TP_SCRIPT="${SCRIPTS_DIR}/tick2.q"
export TP_COMM_PARAMS="tables ${SCRIPTS_DIR}"
export TP_PORT="5010"
export RDB_1_SCRIPT="${SCRIPTS_DIR}/r1.q"
export RDB_1_COMM_PARAMS=":${TP_PORT} :5012 ${HDB_DIR}"
export RDB_1_PORT="5030"
export RDB_2_SCRIPT="${SCRIPTS_DIR}/r2.q"
export RDB_2_COMM_PARAMS=":${TP_PORT} :5012 ${HDB_DIR}"
export RDB_2_PORT="5031"
export RTE_SCRIPT="${SCRIPTS_DIR}/rte2.q"
export RTE_COMM_PARAMS=":${TP_PORT}"
export RTE_PORT="5050"
export FEED_SCRIPT="${SCRIPTS_DIR}/feed.q"
export FEED_COMM_PARAMS=":${TP_PORT} 10 1000"
export FEED_PORT="5090"

###
