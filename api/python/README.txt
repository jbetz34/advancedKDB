To interface python with kdb+, start a q session with pushCSV.q
q pushCSV.q -p 1234

The script will load in p.q, read ../../csv/tradesNoHeader.csv and push it to the tickerplant (5010)
Note: You MUST have embedpy installed for this script to be successful. It is not included in this repository
