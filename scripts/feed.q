/
  Main Feedhandler Script

  Create a mock feedhandler that will supply trades and quotes
  to the tickerplant system.
\

// generates dummy data for tick.q
// q tick/feed.q :PORT [MSG] [RATE]
// q tick/feed.q :5010 10 1000


\d .f
// parse commandline params
l:hsym `$getenv[`LOG_DIR],"/missingMsg_",string[.z.D];l set ();L:hopen l;
.u.reg:{.f.h:neg hopen `$":",.z.x 0};
@[.u.reg;();{"Cannot connect to tickerplant";.f.h:.f.L}];
if[null first msg:"I"$.z.x 1; msg:1];

// initialize configurable variables
symList:`IBM.N`GE`BMW`UL`FB`GW;

gen.trade:{ (`upd;`trade;(msg#.z.N; msg?symList; 10+((msg?50)*(msg?(1;-1)))%10; msg?10i))};
gen.quote:{[side]
  res:$[`b=side;
    (msg#.z.N; msg?symList; 10+((msg?50)*(msg?(1;-1)))%10; msg#0n; msg?10i;msg#0ni);
    (msg#.z.N; msg?symList; msg#0n; 10+((msg?50)*(msg?(1;-1)))%10; msg#0ni; msg?10i)
  ];
  (`upd;`quote;res)
 }

// system startup
$[null first .z.x 2; system"t 1000"; system"t ",.z.x 2];
.z.ts:{h .[gen;raze 1?cross[`quote`trade;`b`s]]}

// open and close handling
.z.po:{0N!"Connection Opened"}

.cfg.name:"feed";
