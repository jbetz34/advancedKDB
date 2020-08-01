StringtoDate:{[x]{$[10h~abs type x;x:"D"$x;-14h~ type x;x:x;`date$x]}'[x]}

/ functions
std1:value "k){@[x;&:10=@:'x;\"D\"$]}"
std2:{@[x;where 10=type'[x];$["D";]]}
std3:{$[;x] ![10 -14h;"D*"] type'[x]}

/ uses original "StringtoDate" function, and compares time and result to new func
/ if results match, new query performance is upserted to result table 
/ if results do not match null values are returned and match boolean set to 0b
compare:{[funcs;arg] 
	res:([] function:`symbol$();time:`long$();size:`long$();match:`boolean$());
	r:.[{x,.Q.ts . (value x;enlist y)};(`StringtoDate;arg);{'"Error executing StringtoDate -- ",x}];
	f[;2]:r[2]~/:(f:@'[{x,.Q.ts . (value .comp.f:x;enlist y)}[;arg];funcs;{(.comp.f;2#0N;0b)}])[;2];
	r[2]:1b;:`time xasc res upsert raze'[(enlist r),f]
 }
