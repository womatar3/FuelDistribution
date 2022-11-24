Parameter DaysinMonth number of days in a month;
DaysinMonth('m1')=31;
DaysinMonth('m2')=28;
DaysinMonth('m3')=31;
DaysinMonth('m4')=30;
DaysinMonth('m5')=31;
DaysinMonth('m6')=30;
DaysinMonth('m7')=31;
DaysinMonth('m8')=31;
DaysinMonth('m9')=30;
DaysinMonth('m10')=31;
DaysinMonth('m11')=30;
DaysinMonth('m12')=31;

Parameter demval demand in D of fuel f in time t in thousand bpd;

$CALL GDXXRW.exe distdata.xlsx par=demval1 rng=demcen!F1:L189 Rdim=2 Cdim=1
Parameter demval1 demand in D of fuel f in time t in thousand barrels;
$GDXIN distdata.gdx
$LOAD demval1
$GDXIN
;



$CALL GDXXRW.exe distdata.xlsx par=MonthlyShare rng=demcen!p23:u35 Rdim=1 Cdim=1
Parameter MonthlyShare monthly share of consumption by fuel in t1;
$GDXIN distdata.gdx
$LOAD MonthlyShare
$GDXIN
;


$CALL GDXXRW.exe distdata.xlsx par=demgro rng=demcen!AI2:AX23 Rdim=1 Cdim=2
Parameter demgro demand growth in D of fuel f in time t relative to t1;
$GDXIN distdata.gdx
$LOAD demgro
$GDXIN
;

Parameter savedemval to save initial demval setting for regional distribution,diffdemval;

Loop(demscen$(demscen_run(demscen)),

if(ord(demscen)=1,
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)=demval1(D,'t1',f)*demgro(t,'low',f)*MonthlyShare(mo,f)/DaysinMonth(mo);
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')=0)=demval1(D,'t1',f)*demgro(t,'low',f)/DaysinYear;

elseif ord(demscen)=2,
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)=demval1(D,'t1',f)*demgro(t,'mid',f)*MonthlyShare(mo,f)/DaysinMonth(mo);
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')=0)=demval1(D,'t1',f)*demgro(t,'mid',f)/DaysinYear;

elseif ord(demscen)=3,
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)=demval1(D,'t1',f)*demgro(t,'high',f)*MonthlyShare(mo,f)/DaysinMonth(mo);
demval(D,f,mo,t)$(coefa(t,mo)<>0 and coefa(t,'m2')=0)=demval1(D,'t1',f)*demgro(t,'high',f)/DaysinYear;

   );

     );

savedemval(D,f,mo,t)=demval(D,f,mo,t);


Duse(D,f,mo)=no;
Duse(D,f,mo)$(demval(D,f,mo,'t1')>0)=yes;

Sets fkeros(f) kerosene only;
fkeros(f)=no;
fkeros('f3')=yes;








