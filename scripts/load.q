/
.tbl.gettables:
    Takes table name(s) and will pull that table(s) from schema file, backtick will load all tables
    If `SCHEMAS env variable is not defined, it will use default location `:../scripts/tick/tables.q
    Saves table schema under .tbl namespace, returns loaded table namespace

  arguments:
    t: table name(s) (symbol) - not case sensitive

loadCSV:
    Takes filepath and table name and will load that table into memory.
    Matches table name against those defined in .tbl namespace to determine schema.
    If the first 4 characters of the file are "time", then it loads with headers,
    otherwise it just upserts to corresponding table in .tbl namespace.

  arguments:
    fp: filepath (symbol path)
    t:  table name (symbol)

pushCSV:
    Takes filepath and table name and will push table to tickerplant.
    Uses loadCSV to bring table into memory, csv does not need a header
    If `TP_PORT env variable is not defined, it will use default port "5010"

  arguments:
    fp: filepath (symbol path)
    t: table name (symbol)
\

// loads table from schema
.tbl.gettables:{[t]
  wc:{y where signum sum lower[y] like/: string[x],\:"*"}[count[t]#lower t];
  tbl:l where raze not "/" = 1#'l:read0 $[null first getenv `SCHEMAS;`:../scripts/tick/tables.q;hsym `$getenv `SCHEMAS];
  value each T:".tbl.",/: wc[tbl];
  `${(x?":")#x}'[T]
 }

// loads csv into memory
loadCSV:{[fp;t]
  if[not t in key .tbl;.tbl.gettables[`]];
  c:"time"~4#first system"head -1 ",1_ string fp; // curious about performance vs. 1#read0 fp
  upd:$[c;{x upsert y};{x upsert flip y}];
  delim:$[c;enlist ",";","];
  upd[.tbl[t]] (upper (0!meta .tbl[t])`t;delim) 0: fp
 }

// pushes csv into tp
pushCSV:{[fp;t]
  (hopen `$"::",$[null first p:getenv `TP_PORT;"5010";p])(`.u.upd;t;flip value each loadCSV[fp;t]);
 }
