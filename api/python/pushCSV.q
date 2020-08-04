/embedPy code 
/needs to be loaded into a q process

\l p.q

p)import pandas as pd
p)df=pd.read_csv('../../csv/tradesNoHeader.csv',sep=',',header=None)
p)df=df.values
p)print("Finished reading in data")
pt:.p.pyget`df
qt:.p.py2q pt
qt:({`$first x}'[qt]),'({"f"$x}'[qt[;1]]),'(qt[;2])
h:hopen 5010
p)print("Publish to kdb tickerplant")
{h(".u.upd";`trade;x)}'[qt]
hclose h
