# source config dir
source ../config/config.profile

# archive directories

archive(){

# 	Takes 5 arguments:
#	1- Directory 
#	2- Regex expression 
#	3- Ignore regex expression 
#	4- Number of days
#	5- Action

	echo "#### ~~~~ Archiving files ~~~~ ####"
	echo "directory:	$1"
	echo "regex:		$2"
	echo "ignore:		$3"
	echo "days:		$4"
	echo "cmd:		$5"
	echo "command: find ${1} -name ${2} ! -name ${3} -mtime +${4} -exec ${5} {} + -printf \"\\t\" -print"
	echo "files: "
	find ${1} -name ${2} ! -name ${3} -mtime +${4} -exec ${5} {} + -printf "\t" -print
}

# configuration parameters

files=(
#DIR		REGEX		IGNORE		DAYS		ACTION
"${TP_DIR}	tp_*		*.gz		2		gzip"
"${TP_DIR}	tp_*		\"\"		10		rm"
"${LOG_DIR}	*.log		*.gz		2		gzip"
"${LOG_DIR}	*.log*		\"\"		10		rm"
)

for i in ${!files[@]};do archive ${files[$i]};done
#archive ${files[0]}
