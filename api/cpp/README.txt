Executables:
	pushCSV - 
		Will transform csv and push record by record into q process. Should be pointed at the tickerplant process, as it will call the .u.upd function. Symbol columns should be defined with a backtick in the csv. Float columns should all contain a decimal point or a trailing "f" to esatblish that it is a float value. 
		Connection Prompts:
		- Hostname : name of host to connect (e.g. "localhost")
		- Port : port number to connect (e.g. "5010")
		- Username : name of connecting user (e.g. "Admin")
		- Password : password associated with user (e.g. "password")
		- Timeout (hidden) : milliseconds before throwing timeout (e.g. "3000")

		Input File Prompts:
		- Filepath : location of csv file, absolute or relative (e.g. "trades.csv")
		- Table : table name to push csv records (e.g. "trade")

	writeCSV- 
		Will prompt a user to input values for each cell of a csv file. Dynamically increase csv size and sources the time column from the system time at row creation. It should be notes that this executable will only write a csv in the trade schema ([]time;sym;price;size). Users should use a backtick when defining symbol values. 
		Prompts:
		- Time (hidden) : timespan formatted at time of creation (e.g. "0D09:03:23.000000")
		- Sym : ticker symbol (e.g. `AAPL)
		- Price : security price (e.g. 45.6)
		- Size : volumn of security (e.g. 300)

		To create more rows, respond "yes" when prompted. 

Links:
	c32.o - c.o file for l32 systems : https://github.com/KxSystems/kdb/blob/master/l32/c.o
	c64.o - c.o file for l64 systems : https://github.com/KxSystems/kdb/blob/master/l64/c.o
	e32.o - e.o file for l32 systems : https://github.com/KxSystems/kdb/blob/master/l32/e.o
	e64.o - e.o file for l64 systems : https://github.com/KxSystems/kdb/blob/master/l64/e.o

Headers: 
	k.h - (links/k.h) - q/k header file : https://github.com/KxSystems/kdb/blob/master/c/c/k.h

Sources:
	readCSV.cpp -
		source code for pushCSV
		compile cmd: g++ -DKXVER=3 -o pushCSV readCSV.cpp e64.o -lpthread -ldl

	writeCSV.cpp - 
		source code for writeCSV
		compile cmd: g++ -o writeCSV writeCSV.cpp
