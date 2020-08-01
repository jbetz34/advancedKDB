/
Write a script that reads in a tickerplant log file which contains trade and
quote updates and creates a new tickerplant log file which only contains the
trade updates for ibm.n.
\

.replay.run:{[fp;np]
  np set ();.replay.h:hopen np;
  `upd set {[t;x] if[(`trade=t)&(any `IBM.N=x[1]);.replay.h enlist (`upd;`trade;.replay.findIBM x)];};
  -11!fp;
  hclose .replay.h;
 }

.replay.findIBM:{
  $[1=count x[1];x;x[;where x[1]=`IBM.N]]
 }
