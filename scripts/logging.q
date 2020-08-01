/
script can be loaded into any process and will log details
  *- details of connections opened
  *- details of connections closed
  *- all logging statements should include username of calling process where applicable and memory usage details from .Q.w[]
  *- functions should be available so that can write internal logging statements to write to standard out and error
\
\d .log
// setup log
dir:@[getenv;`LOGDIR;{`:.}];
l:hsym[`$getenv[`LOG_DIR],"/",.cfg.name,"_",except[string[.z.Z];":."],".out.log"];
L:hopen l;
s:" ### ";
str:{(,/)((string[.z.Z];string[y];x;z),\:s),.[M;value .Q.w[]],"\n"};

M:{[u;h;p;w;mm;mp;s;sw]
  "used: ",string[u],", heap: ",string[h],", peak: ",string[p],", wmax: ",string[w],
  ", mmap: ",string[mm],", mphy: ",string[mp],", syms: ",string[s],", symsw: ",string[sw]
 }

/ these functions can be used to write internal logging statements
out:{[tag;msg] L str["INFO";tag;msg];}
err:{[tag;msg] L str["ERROR";tag;msg];}

enable:{[x]
  $[`all=lower x;.log[;`] each `po`pc;.log[x;`]]
 }

po:{.z.po:{out[`PortOpen;(.z.w".cfg.name")," opened a connection on handle ",string .z.w];}}
pc:{.z.pc:{out[`PortClose;(.z.w".cfg.name")," closed the connection on handle ",string .z.w];}}
pg:{.z.pg:{out[`PortGet;(.z.w".cfg.name")," making a synchronous call"];value x}}
ps:{.z.ps:{out[`PortSet;(.z.w".cfg.name")," making an asynchronous call"];value x;}}

// the below functions allow a user to log stdout and err to specified fp
stdout:{[fp]
  0N!"Redirecting stdout to ",1_ string fp;
  system"1 ",1_ string fp;
 }

stderr:{[fp]
  0N!"Redirecting stderr to ",1_ string fp;
  system"2 ",1_ string fp;
 }

\d .

.log.out[.z.h;"Starting logging sequence"];
.log.out[.z.h;"Process name ",.cfg.name];
.log.out[.z.h;"Port number ",.cfg.name];
