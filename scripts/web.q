
//	This script can be loaded into any q database session
//	and will configure the necessary parameters to interact
//	with the web interface. At the moment only RDB_1 can
//	interact with the web interface


\d .web

logQuery:{[x] `.web.queryLog upsert (.z.P;first key[x];value[x]) }
queryLog:([] time:`timestamp$();query:`symbol$();params:());
query:{update string time from select from `.[`trade] where sym=`$x}

.z.ws:{x:-9!x;.web.logQuery[x];neg[.z.w] -8!raze (key x)@'(value x)}

\d .
