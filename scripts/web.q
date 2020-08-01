
//	This script can be loaded into any q database session
//	and will configure the necessary parameters to interact
//	with the web interface. At the moment only RDB_1 can 
//	interact with the web interface


\d .web

logQuery:{[x;y] `queryLog upsert (.z.P;x;y) }
queryLog:([] time:`timestamp$();query:`symbol$();params:());
query:{select from `.[`trade] where sym=`$x}

.z.ws:{x:-9!x;.web.logQuery(first key x;first value x);neg[.z.w] -8!raze (key x)@'(value x)}

\d .
