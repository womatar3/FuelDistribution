******Oil refinery production:
*In thousand bpd:
RefCap(R,f,mo,t)=100*sharef;

*Import terminals:
RefCap(R,f,mo,t)$(ord(R)>10)=9e9;

Display RefCap;
Parameter RefGrowth(time) growth in real domestic refining growth output taken from KGEMM in July 2022
/
t1        1.00000
/
;

*Over time:
RefCap(R,f,mo,t)$(ord(R)<=9)=RefCap(R,f,mo,'t1')*RefGrowth('t1');

Display RefCap;

******Initial storage and pipeline capacities:
*In thousand barrels:

$CALL GDXXRW.exe distdata.xlsx par=c rng=PBScap!b1:G18 Rdim=1 Cdim=1
Parameter c(L,f) initial PBS storage capacities in thousand barrels;
$GDXIN distdata.gdx
$LOAD c
$GDXIN
;
iniexistcap(L,f)=c(L,f);


*In thousand bpd:
$CALL GDXXRW.exe distdata.xlsx par=pipe rng=PipeCap!a1:aM15 Rdim=2 Cdim=1
Parameter pipe(fgroups,R,L) initial PBS storage capacities in thousand barrels;
$GDXIN distdata.gdx
$LOAD pipe
$GDXIN
;
inipipeexistcap(fgroups,R,L)=pipe(fgroups,R,L);

*In thousand bpd:
$CALL GDXXRW.exe distdata.xlsx par=pipeLL rng=PipeCap!a18:aM59 Rdim=2 Cdim=1
Parameter pipeLL(fgroups,L,L2) initial PBS storage capacities in thousand barrels;
$GDXIN distdata.gdx
$LOAD pipeLL
$GDXIN
;
inipipeexistcapLL(fgroups,L,L2)=pipeLL(fgroups,L,L2);


$CALL GDXXRW.exe distdata.xlsx par=TruckCapLD rng=TruckCap!u2:AL39 Rdim=1 Cdim=1
Parameter TruckCapLD(L,fgroups) maximum trucking capacity of each fuel at each bulk plant in thousand bpd;
$GDXIN distdata.gdx
$LOAD TruckCapLD
$GDXIN
;

$CALL GDXXRW.exe distdata.xlsx par=TruckCapRL rng=TruckCap!a2:s39 Rdim=1 Cdim=1
Parameter TruckCapRL(L,fgroups) maximum trucking capacity of each fuel at each bulk plant in thousand bpd;
$GDXIN distdata.gdx
$LOAD TruckCapRL
$GDXIN
;

Parameter TruckLDmax,TruckRLmax,saveTruckLDmax maximum trucking capacity of each fuel group at each bulk plant in thousand bpd;
TruckLDmax(L,fgroups)=TruckCapLD(L,fgroups);
TruckRLmax(L,fgroups)=TruckCapRL(L,fgroups);
saveTruckLDmax(L,fgroups)=TruckLDmax(L,fgroups);

Display TruckLDmax,TruckRLmax;

*In thousand bpd:
$CALL GDXXRW.exe distdata.xlsx par=pipeLD rng=PipeCap!a59:c61 Rdim=1 Cdim=1
Parameter pipeLD(L,D) initial PBS storage capacities in thousand barrels;
$GDXIN distdata.gdx
$LOAD pipeLD
$GDXIN
;
inipipeexistcapLD(L,D)=pipeLD(L,D);






