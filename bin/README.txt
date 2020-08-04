Executables:
run.sh  -  Main script for starting, stoping, testing q processes. Can be run with 0 or 1 argument:
	0 Argument Option:
		./run.sh will prompt the user to decide what to do: START, STOP or TEST. 
	1 Argument Option:
		./run.sh [OPTION] will skip the first step in the script and will follow steps for whichever optino is passed as an argument

	START - 
		Will prompt user to enter the name of the process to start. If all is selected, all processes will be started
	STOP  - 
		Will prompt user to enter the name of the process to kill. If all is selected, all processes will be killed. Kill -9 is used
	TEST  - 
		Will search for q processes as defined in the config file

startProcess.sh - Starter script for processes. -d flag will start interactive process
stopProcess.sh - Stop script fro processes. -m flag will allow a user to kill multiple processes at one time
findProcess.sh - Script to find running q processes.
archive.sh - will archive the files in the repository as defined in the config file
