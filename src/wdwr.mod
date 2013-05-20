#indeksy
set E;	#e
set M;  #m
set P;	#p
set C;  #c

#stale
param wd{m in M, e in E}; #wydajnosc
param pr {p in P}; # prawdopodobienstwo
param k {p in P, m in M}; #zl/godz., koszt 
param ek {m in M} = sum{p in P} pr[p]*k[p,m]; #zl/godz. 
param dr; #dni robocze
param min_prod {e in E}; # minimalna produkcja elementu
param max_o; # maksymalny czas wykorzystania dowolnej wszystkich maszyn
param pk {m in M} = max{p in P} k[p,m]; # pesymistyczny koszt
param eps;
param a {c in C};
param lambda;
param beta;

#zmienne
var o_prim {m in M, e in E} >=0; #godz.
var o_bis {m in M, e in E} >=0; #godz.
var u {m in M} binary; #okresla czy nadwyzka zostala przekroczona
var y {c in C} >= 0; #zbior kryterow

var v;
var z {c in C};

#ograniczenia
s.t. minimaprodukcjielementu{e in E}:
	sum{m in M} (o_prim[m,e] + o_bis[m,e])*wd[m,e]>=min_prod[e];

s.t. maxdzierzawaM{m in M}:
	sum{e in E} (o_prim[m,e] + o_bis[m,e])<=max_o;

s.t. nadwyzka {m in M}:
	sum {e in E} o_bis[m,e] <= max_o*u[m];

s.t. oblozenieprimogra {m in M}:
	sum {e in E} o_prim[m,e] <= 100;	

s.t. kosztresult:
	y[1] = (sum{m in M, e in E} 0.8*o_prim[m,e]*ek[m]) + (sum{m in M, e in E} o_bis[m,e]*ek[m]) + sum{m in M} u[m]*20*ek[m];

s.t. ryzykoresult:
	y[2] = (sum{m in M, e in E} (0.8*o_prim[m,e] + o_bis[m,e])*pk[m]) + sum{m in M} u[m]*20*pk[m] - y[1];

s.t. odniesienie1 {c in C}:
	v <= z[c];

s.t. odniesienie2 {c in C}:
	beta*lambda *(-y[c]+a[c]) >= z[c];

s.t. odniesienie3 {c in C}:
	lambda*(-y[c]+a[c]) >= z[c];
	
#funkcja celu
maximize cost: v + sum{c in C} eps*(-y[c]);
#minimize cost: y[2];