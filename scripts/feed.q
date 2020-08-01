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
// builds missingMsg log (records all messages that tp missed)
L:hsym `$getenv[`LOG_DIR],"/missingMsg_",string[.z.D];L set ();l:hopen L;
// register function: if called from remote process -> store remote handle
//                  : if called from local process -> store arguement
.u.reg:{.f.h:$[.z.w;.z.w;x]};
// try to connect to the tickerplant port as defined in the commandline
// if cannot connect, store the missingMsg file handle as the target handle
@[{.u.reg neg hopen x};`$":",.z.x 0;{"Cannot connect to tickerplant";.f.h:.f.l}];
// if the message quantity (MSG) is not defined, then set as 1 msg per rate
if[null first msg:"I"$.z.x 1; msg:1];

// initialize configurable variables
symList:`IBM.N`GE`BMW`UL`FB`GW;

// functions to define each message type
// msg variable defines how many messages are created
gen.trade:{ (`upd;`trade;(msg#.z.N; msg?symList; 10+((msg?50)*(msg?(1;-1)))%10; msg?10i))};
gen.quote:{[side]
  res:$[`b=side;
    (msg#.z.N; msg?symList; 10+((msg?50)*(msg?(1;-1)))%10; msg#0n; msg?10i;msg#0ni);
    (msg#.z.N; msg?symList; msg#0n; 10+((msg?50)*(msg?(1;-1)))%10; msg#0ni; msg?10i)
  ];
  (`upd;`quote;res)
 }

// system startup
// if the message rate (RATE) is not defined, set it as 1 second
$[null first .z.x 2; system"t 1000"; system"t ",.z.x 2];
// will randomly select a message type and side, and push to target handle
.z.ts:{h .[gen;raze 1?cross[`quote`trade;`b`s]]}

// open and close handling
.z.po:{}
// if the target handle disconnects, send messages back to missingMsg log
.z.pc:{if[x=abs .f.h;.f.h:.f.l]}

.cfg.name:"feed";
