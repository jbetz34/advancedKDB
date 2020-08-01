/
  Main RTE/CEP Script

  Create a Complex Event Processer/Calculation Engine which will
  subscribe to trades and quote from tickerplant and then calculate
  metrics for the aggregation table and publish the data back
  to the Ticker Plant.
\

// rte process
// q tick/rte.q :5010 -p 5050
// OHLC schema
// ([] sym;volume;max;min;bestBid;bestAsk)
// initialize functs
// register function: if called from remote process -> subscribe to remote handle
//                  : if called from local process -> Subscribe to arguement handle
.u.reg:{(.rte.h:$[.z.w;.z.w;x])"(.u.sub[;`]each `trade`quote;`.u `i`L)"};
@[{.u.reg neg hopen x};`$":",.z.x 0;"Cannot connect to tickerplant"];
if[not system"t"; system"t 5000"];

// defining schemas
.debug.t:.debug.q:();
OHLC:([] time:0#0nn;sym:0#`;volume:0#0ni;maxPx:0#0n;minPx:0#0n;bestBid:0#0n;bestAsk:0#0n);
/.ohlc:.new:()!();
/@[`.ohlc;;:;()!()] each `size`max`min`bid`ask;
/@[`.new;;:;()!()] each `size`max`min`bid`ask;
.ohlc.size: ([sym:0#`] volume:0#0ni);
.ohlc.max: ([sym:0#`] maxPx:0#0n);
.ohlc.min: ([sym:0#`] minPx:0#0n);
.ohlc.bid: ([sym:0#`] bestBid:0#0n);
.ohlc.ask: ([sym:0#`] bestAsk:0#0n);
.tmp.t:([]sym:0#`;size:0#0ni;price:0#0n);
.tmp.q:([]sym:0#`;bid:0#0n;ask:0#0n);

\d .rte

// should clear this
trade:{[x]
  `.tmp.t upsert select sym, size, price from x;
 }

// should clear this
quote:{[x]
  `.tmp.q upsert select sym, bid, ask from x;
 }

// update new trades
// these get cleared
updNew:{
   `.new.size set select volume:sum size by sym from .tmp.t;
   `.new.max set  select maxPx:max price by sym from .tmp.t;
   `.new.min set  select minPx:min price by sym from .tmp.t;
   `.new.bid set  select bestBid:max bid by sym from .tmp.q where not null bid;
   `.new.ask set  select bestAsk:min ask by sym from .tmp.q where not null ask;
 }

// update ohlc columns
// these do not get cleared; unfortunately
updOhlc:{
  .ohlc.size:: sum (.ohlc.size;.new.size);
  .ohlc.max:: max (.ohlc.max;.new.max);
  .ohlc.min:: min (.ohlc.min;.new.min);
  .ohlc.bid:: max (.ohlc.bid;.new.bid);
  .ohlc.ask:: min (.ohlc.ask;.new.ask);
 }

// join cols and clear everything possible
updJoinAndClear:{
  // how do i do this better?
  @[;();:;()] each  `size`max`min`bid`ask;
  .tmp.t:0#.tmp.t;
  .tmp.q:0#.tmp.q;

  // temporarily store
  /k:distinct raze key each .ohlc[`size`max`min`bid`ask];
  0!(uj/) .ohlc[`size`max`min`bid`ask]
 }

// called by pub funct, returns entire ohlc table
upd:{
  updNew[];
  updOhlc[];
  updJoinAndClear[]
 }
\d .

upd:{[t;x] $[t=`quote;.debug.q,:x;.debug.t,:x];.rte[t]x}

// publishing functs
pub:{[]
  if[count .rte.upd[];.rte.h (`.u.upd;`OHLC;flip value each .rte.upd[])]} // {h each .rte.upd[];}
.z.ts:{pub[]}

.cfg.name:"rte";
.z.po:{0N!.z.w[".cfg.name"]," opened a connection on handle ",string .z.w}
