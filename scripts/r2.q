/
  RDB 2 script

  Create 2 RDB which subscribe as follows:
      - Subscribes only to Trade and Quote tables
      - Subscribes to aggregation table

  q tick/r2.q [host]:port[:usr:pwd] [host]:port[:usr:pwd] [HDB]
  $1 - tickerplant connection details
  $2 - historical db connection details
  HDB - hdb directory
\

system"cd ",$[all null `$.z.x[2],"";"./hdb";.z.x[2]]
if[not "w"=first string .z.o;system "sleep 1"];

upd:{$[x in tables[]; x insert y;()];};

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ end of day: save, clear, hdb reload
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ init schema and sync up from log file;cd to hdb(so client save can run)
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;};

/ connect to ticker plant for (schema;(logcount;log))
.u.reg:{.u.rep .(hopen `$":",.u.x 0)"(.u.sub[;`]'[`trade`quote];`.u `i`L)"};
@[.u.reg;();"Cannot connect to tickerplant"];

// custom code
\d .eod
compression:(17;2;6);
csave:{[d;p;t;ex;f;x;y;z] (` sv (d;`$string p;t;`);c!count[c:except[cols t;ex]]#enlist (x;y;z)) set f xcols @[f xasc .Q.en[`:.;value t];f;`p#];@[`.;t;0#]}
end:{t:tables`.;t@:where `g=attr each t@\:`sym;.[csave[`:.;x;;`sym`time;`sym;]'[t];compression];@[hopen;`$":",.u.x 1;0]" system\"l .\""}
\d .

.cfg.name:"rdb_2";
.z.po:{0N!.z.w[".cfg.name"]," opened a connection on handle ",string .z.w}
