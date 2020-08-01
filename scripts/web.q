/
	This script can be loaded into any q database session
  and will configure the necessary parameters to interact
	with the web interface. At the moment only RDB_1 can
	interact with the web interface

  .web.register:
    Input: null
    Output: (`status;.z.P)

    Description:
      Initialize function. Called by the connect button on the web interface.
      Will upsert client details to a subscriber table and call .web.updStatus on timer interval

  .web.query:
    Input: s "sym filter" <string>
    Output: (`table;*results*)

    Description:
      Function called by trade filter button on web interface.
      Will call .web.updStatus function, then return the trade table filtered where sym= sym fliter
      Returns a maximum of 100 records

  .web.updStatus:
    Input: h "handle" <int>
    Output: `.web.subscribers

    Description:
      Will attempt to connect to websocket by sending a status update (`status;.z.P)
      If successful, it will update the recent column in the .web.subscribers table for the handle

  .web.deregister:
    Input: h "handle" <int>
    Output: `.web.subscribers

    Description:
      Will update status as closed on .web.subscribers table.
      This will remove the handle from the timer function

  .web.logQuery:
    Input: x "" <dictionary>
    Output: `.web.queryLog

    Description:
      Will upsert query details to the .web.queryLog table.
      Details included: remote handle, query, query parameters
\


system"t 30000"

\d .web

logQuery:{[x] `.web.queryLog upsert (.z.P;.z.w;first key[x];value[x]) }
queryLog:([] time:`timestamp$();handle:`int$();query:`symbol$();params:());
query:{[s].web.updStatus[.z.w];(`table;min[100,count r]#r:update string time from select from `.[`trade] where sym=`$s)}

register:{[] `.web.subscribers upsert enlist `handle`status`opened!(.z.w;`opened;t:.z.P);(`status;t)}
deregister:{[h] `.web.subscribers upsert enlist `handle`status`closed!(h;`closed;.z.P)}
updStatus:{[h] neg[h] -8!(`status;t:.z.P);`.web.subscribers upsert enlist `handle`recent!(h;t)}
subscribers:([handle:`int$()] status:`symbol$();opened:`timestamp$();recent:`timestamp$();closed:`timestamp$());

.z.ws:{x:-9!x;.web.logQuery[x];neg[.z.w] -8!raze (key x)@'(value x)}
.z.pc:{if[x in key[.web.subscribers]`handle;.web.deregister x]}
.z.ts:{@[{.web.h:x;.web.updStatus x};;{.web.deregister .web.h}] each key[.web.subscribers]`handle}
\d .
