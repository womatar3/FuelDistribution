Options LP=CPLEX, limrow=1e4, limcol=1e4, savepoint=2, reslim=9e9, solprint=on;

$ontext
A model for petroleum products distribution

Monetary units in thousand 2020$
Quantity of fuel transported in thousand bpd
Quantity of fuel stored in thousand barrels
Electricity in MWh
Distance in km

                              ***t1 is 20XX***
$offtext

Set
   R oil refineries or import terminals /R1*R13/
   L bulk plant locations /L1*L2/
   D demand centers /D1*D2/
   time time in years /t1*t2/
   t(time) time to run the model in years --------------------------------------> 2021 to 2040 /t1*t2/
   mo months /m1*m12/
   tmo(time,mo) joining months and years /(t1*t1).(m1*m12),(t2*t2).m1/
   f fuel /f1*f5/
   Lsto(L,f) plants with existing storage for a certain fuel
   Duse(D,f,mo) demand centers with positive demand for a fuel
   fJetFuel(f) jet fuel A-1 only
   fgasoline(f) gasolines grades only
   fdiesel(f) low-sulfur diesel only
   fgroups groups of fuel /group1*group41/
   inc latitude and longitude coordinate increments /c1*c2/
   m transport modes /ship,pipe,truck/
   mTruck trucking only
   mP Pipes only
   mSP ships and pipelines only
   mTP trucks and pipelines only
   demscen demand growth scenarios /low,mid,high/

   RLm(R,L,m) R on the east coast and L on the west coast pairs for maritime /(R11*R13).(L1).ship,(R7,R6).(L2).ship,
                                                                              (R1*R10).(L1*L2).(truck,pipe)/

   LDm(L,D,m) only pipeline and trucking options allowed between L and D /(L1*L2).(D1*D2).(truck,pipe)/

   ffgroups(f,fgroups) mapping f to fgroups /(f1*f5).(group1*group3)/
;
Alias (t,t2),(inc,inc2,inc3,inc4),(m,m2),(D,D2),(f,f2),(L,L2,L3),(fgroups,fgroups2);

fJetFuel(f)=no;
fJetFuel('f5')=yes;

fdiesel(f)=no;
fdiesel('f4')=yes;

fgasoline(f)=no;
fgasoline('f1')=yes;
fgasoline('f2')=yes;

mTruck(m)=no;
mTruck('truck')=yes;

mSP(m)=yes;
mSP('truck')=no;

mTP(m)=yes;
mTP('ship')=no;

mP(m)=no;
mP('pipe')=yes;

Sets LLm(L,L2,m) only pipeline and trucking options allowed between L and L2 /(L1*L2).(L1*L2).(truck,pipe)/


Sets inc_run inc scenarios to run
     demscen_run demand scenarios to run;

****Define demand growth scenarios to run:
demscen_run(demscen)=no;
demscen_run(demscen)$(ord(demscen)=2)=yes;
*****************************************

$Include macros.gms
$Include Locations_and_distances.gms

Scalar DaysinYear days in a year /365/
       UtilRate utilization rate for bulk plant /0.95/
       stomin minimum storage level from 0 to 1 /0.00/
*0.82% is equivalent to 3 survival days.
       sharef share of motor gasoline RON 91 supply in total gasoline supply /0.5/
       discrate real discount rate /0.1/;

Parameter iniexistcap existing capacities of station L for each fuel in time t in thousand barrels
          inipipeexistcap existing pipeline capacity from R to L in thousand bpd
          inipipeexistcapLL existing pipeline capacity from L to L2 in thousand bpd
          inipipeexistcapLD existing pipeline capacity from L to D in thousand bpd
          RefCap refining products' availability in thousand bpd
          Ryields refinery yields (dimensionless)
          capcst investment cost in petroleum bulk storage (PBS) tanks and terminals in $ per bbl
          omcst total operational cost of storage tanks and bulk terminals wrapped into a single value in $ per bbl
          LBcapcst investment cost in trucking loading bays in $ per bpd
          LBomcst annual fixed operational cost in trucking loading bays in $ per bpd
          pipecapcstRL,pipecapcstLD,pipecapcstLL investment cost in pipelines in $ per bpd
          pipeomcstRL,pipeomcstLD,pipeomcstLL total fixed operational cost of pipelines in $ per bpd
          fullcapcst,fullpipecapcstRL,fullpipecapcstLD,fullpipecapcstLL to save full capital costs
          PBSleadtime,pipeleadtime PBS and pipeline leadtimes in years
          distdiscfact discount factors, discoef discount coefficient
          transcstLD operational transportation costs between L and D in $ per bpd
          transcstRL operational transportation costs between R and L in $ per bpd
          transcstLL operational transportation costs between L and L2 in $ per bpd
          PBSaddition PBS already under construction in thousand barrels
          PBSretirement PBS already under decommissioning in thousand barrels
          pipeadditionRL pipelines already under construction in thousand bpd
          pipeadditionLL, piperetirementLL pipelinesn already under construction in thousand bpd
          LBaddition loading bay capacities under construction;

Parameter DM distance multiplier, coefa a control table for defining demand by months or years;
coefa(t,mo)$tmo(t,mo)=ord(t);
display coefa;

******* Defining capacities of oil refineries, distribution stations, and pipelines:
$Include Capacities.gms
PBSaddition(L,f,t)=0;
PBSretirement(L,f,t)=0;
pipeadditionRL(fgroups,R,L,t)=0;
pipeadditionLL(fgroups,L,L2,t)=0;
piperetirementLL(fgroups,L,L2,t)=0;
LBaddition(L,fgroups,t)=0;

Lsto(L,f)=no;
Lsto(L,f)$(iniexistcap(L,f)>00)=yes;

*******Products' demands in thousand bpd:
$Include Demand.gms

*******Defining and annualizing pipeline and bulk station investment costs:
$Include InvestmentCosts.gms
PBSleadtime=3;
pipeleadtime=2;

*****Transportation costs (operational):
$Include Transcstparam.gms
$Include Transcst.gms

$CALL GDXXRW.exe distdata.xlsx par=OPC rng=OilPriceChange!a1:b20 Rdim=1 Cdim=0
Parameter OPC(t) Oil Price Change relative to t1;
$GDXIN distdata.gdx
$LOAD OPC
$GDXIN
;

Parameter fcost price or cost of fuel in $ per barrel;
*Importing fuel price through terminals:
fcost(R,f,t)$(ord(R)>12)=86.5*OPC(t);


Parameter CO2cst social cost of carbon in $ per tCO2;
CO2cst(t)=000;
CO2cst(t)$(ord(t)<10)=19.875+(59.625-19.875)*(ord(t)-1)/(10-1);
CO2cst(t)$(ord(t)>=10)=59.625;

Variable
z total transportation and investment costs in thousand $;

Positive Variables
qRL(R,L,m,f,mo,t) quantities transported from R to L in thousand barrels per day
qLD(L,D,m,f,mo,t) quantities transported from L to D in thousand barrels per day
qLD2(L2,D,m,f,mo,t) quantities transported from L2 to D in thousand barrels per day
qLD3(L2,D,m,f,mo,t) quantities transported from L3 to D in thousand barrels per day
qLL(L,L2,m,f,mo,t) quantites transported from L to L2 in thousand barrels per day
qLL2(L,L2,m,f,mo,t) quantites transported from L to L2 in thousand barrels per day
qst(L,f,mo,t) quantities stored of f at L in thousand barrels per day
qstin(L,f,mo,t) quantities stored of f at L in thousand barrels per day
qstout(L,f,mo,t) quantities stored of f at L in thousand barrels per day
fvalue(L,f,t) fuel purchases in thousand$ (could be shadow price)
bldcap(L,f,t) built capacity in thousand barrels
existcap(L,f,t) existing capacity in thousand barrels
CO2socialcst(t) CO2 cost incurred through trucking transport in thousand$
LBexistcap(L,fgroups,t) existing loading capacity at BP in thousand bpd
LBbldcap(L,fgroups,t) built loading capacity at BP in thousand bpd
pipeexistcapRL(fgroups,R,L,t) existing pipeline capacity in thousand bpd
pipebldcapRL(fgroups,R,L,t) built pipeline capacity in thousand bpd
pipeexistcapLL(fgroups,L,L2,t) existing pipeline capacity in thousand bpd
pipebldcapLL(fgroups,L,L2,t) built pipeline capacity in thousand bpd
pipeexistcapLD(L,D,t) existing pipeline capacity in thousand bpd
pipebldcapLD(L,D,t) built pipeline capacity in thousand bpd;

Equations
obj objective function: to minimize transport costs in thousand $
fvaluebal(L,f,t) fuel purchasing balance in thousand$
PBScapbal(L,f,t) capacity balance through time for each fuel at station L
RLDinterbal(L,f,mo,t) interface balance between refineries and demand centers in thousand bpd
LLDinterbal(L2,f,mo,t) interface balance between bulk plants and demand centers in thousand bpd
LLDinterbal2(L3,f,mo,t) interface balance between bulk plants and demand centers in thousand bpd
pipecapbalRL(fgroups,R,L,t) pipeline capacity balance in bpd at R to L
pipecaplimRL(R,L,mo,t) pipeline capacity limit in bpd from R to L
pipecaplimRL2(f,R,L,mo,t) pipeline capacity limit in bpd from R to L
pipecapbalLD(L,D,t) pipeline capacity balance in bpd at L to D
pipecaplimLD(L,D,mo,t) pipeline capacity limit in bpd from L to D
pipecapbalLL(fgroups,L,L2,t) pipeline capacity balance in bpd at L to L2
pipecaplimLL(L,L2,mo,t) pipeline capacity limit in bpd from L to L2
pipecaplimLL2(f,L,L2,mo,t) pipeline capacity limit in bpd from L to L2
Rcapbal(R,f,mo,t) refining capacity limit at R by fuel in thousand bpd
LBcapbal(L,fgroups,t) trucking loading capacity balance in thousand bpd
LDtruckcaplim(L,f,mo,t) trucking capacity limit between L and D in thousand bpd
RLtruckcaplim(L,f,mo,t) trucking capacity limit between R and L in thousand bpd
LDtruckcaplim2(L,mo,t) trucking capacity limit between L and D in thousand bpd
RLtruckcaplim2(L,mo,t) trucking capacity limit between R and L in thousand bpd
stobal(L,f,mo,t) storage balance at L
stomincon(L,f,mo,t) minimum storage constraint
stolim(L,f,mo,t) observe supply limit at station L (capacity limit)
CO2cstbal(t) CO2 (as an externality) cost accounting in thousand$
LBlim(L) limit to combined LB investment over the time horizon
dem(D,f,mo,t) satisfy demand in market D;

*************************************
existcap.fx(L,f,'t1')=iniexistcap(L,f);
pipeexistcapRL.fx(fgroups,R,L,'t1')=inipipeexistcap(fgroups,R,L);
pipeexistcapLL.fx(fgroups,L,L2,'t1')=inipipeexistcapLL(fgroups,L,L2);
pipeexistcapLD.fx(L,D,'t1')=inipipeexistcapLD(L,D);
LBexistcap.fx(L,fgroups,'t1')=TruckLDmax(L,fgroups);
*************************************


obj.. z=e=
*Social CO2 costs
            sum(t,CO2socialcst(t)*distdiscfact(t))
*Pipeline capital and fixed O&M costs
           +sum((L,t),     sum((fgroups,R), (pipecapcstRL(R,L,t)*pipebldcapRL(fgroups,R,L,t))$(ord(t)>pipeleadtime)+pipeomcstRL(R,L,t)*(pipeexistcapRL(fgroups,R,L,t)+pipebldcapRL(fgroups,R,L,t)$(ord(t)>pipeleadtime)) )
                          +sum(D, (pipecapcstLD(L,D,t)*pipebldcapLD(L,D,t))$(ord(t)>pipeleadtime)+pipeomcstLD(L,D,t)*(pipeexistcapLD(L,D,t)+pipebldcapLD(L,D,t)$(ord(t)>pipeleadtime)) )
                          +sum((fgroups,L2)$(ord(L)<>ord(L2)), (pipecapcstLL(L,L2,t)*pipebldcapLL(fgroups,L,L2,t))$(ord(t)>pipeleadtime)+pipeomcstLL(L,L2,t)*(pipeexistcapLL(fgroups,L,L2,t)+pipebldcapLL(fgroups,L,L2,t)$(ord(t)>pipeleadtime)) )

                     +sum(fgroups,
*Loading bay capital and fixed O&M costs
                          LBcapcst(t)*LBbldcap(L,fgroups,t)$(ord(t)>pipeleadtime)
                         +LBomcst(t)*(LBexistcap(L,fgroups,t)+LBbldcap(L,fgroups,t)$(ord(t)>pipeleadtime))
                          )

                     +sum(f,
*PBP capital and fixed O&M costs
                          capcst(L,f,t)*bldcap(L,f,t)$(ord(t)>PBSleadtime)
                         +omcst(L,f,t)*(existcap(L,f,t)+bldcap(L,f,t)$(ord(t)>PBSleadtime))
*Fuel value
                         +fvalue(L,f,t)
*Transportation variable O&M costs
                         +sum((D,m,mo)$(Duse(D,f,mo) and ( (LDm(L,D,m) and mSP(m)) or (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)), transcstLD(f,m,L,D,t)*(qLD(L,D,m,f,mo,t)+qLD2(L,D,m,f,mo,t)+qLD3(L,D,m,f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                         +sum((R,m,mo)$((RLm(R,L,m) and mSP(m)) or (RLm(R,L,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) and tmo(t,mo)), transcstRL(f,m,R,L,t)*qRL(R,L,m,f,mo,t)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                         +sum((L2,m,mo)$(( (LLm(L,L2,m) and mP(m)) or (LLm(L,L2,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L2,fgroups) and tmo(t,mo))>0 and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) ) and ord(L)<>ord(L2)), transcstLL(f,m,L,L2,t)*(qLL(L,L2,m,f,mo,t)+qLL2(L,L2,m,f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
*Cost of road accidents
                         +sum((R,m,mo)$( (RLm(R,L,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) and tmo(t,mo)), TruckAccCostsRL(f,R,L)*qRL(R,L,m,f,mo,t)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                         +sum((L2,m,mo)$( (LLm(L,L2,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0 and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L2,fgroups))>0) and ord(L)<>ord(L2)  and tmo(t,mo)), TruckAccCostsLL(f,L,L2)*(qLL(L,L2,m,f,mo,t)+qLL2(L,L2,m,f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                         +sum((D,m,mo)$(Duse(D,f,mo) and ( (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)), TruckAccCostsLD(f,L,D)*(qLD(L,D,m,f,mo,t)+qLD2(L,D,m,f,mo,t)+qLD3(L,D,m,f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )

                         )*distdiscfact(t)
               );


*These three equations balance pipeline capacity over time:
pipecapbalRL(fgroups,R,L,t)$(ord(t)<card(t)).. pipeexistcapRL(fgroups,R,L,t)
                                              +pipebldcapRL(fgroups,R,L,t)$(ord(t)>pipeleadtime)
                                              +pipeadditionRL(fgroups,R,L,t)
                                              -pipeexistcapRL(fgroups,R,L,t+1)=e=0;

pipecapbalLD(L,D,t)$(ord(t)<card(t)).. pipeexistcapLD(L,D,t)
                                      +pipebldcapLD(L,D,t)$(ord(t)>pipeleadtime)
                                      -pipeexistcapLD(L,D,t+1)=e=0;

pipecapbalLL(fgroups,L,L2,t)$(ord(t)<card(t) and ord(L)<>ord(L2)).. pipeexistcapLL(fgroups,L,L2,t)
                                                                   +pipebldcapLL(fgroups,L,L2,t)$(ord(t)>pipeleadtime)
                                                                   +pipeadditionLL(fgroups,L,L2,t)
                                                                   -piperetirementLL(fgroups,L,L2,t)
                                                                   -pipeexistcapLL(fgroups,L,L2,t+1)=e=0;


*This equation balances loading bay capacity over time:
LBcapbal(L,fgroups,t)$(ord(t)<card(t)).. LBexistcap(L,fgroups,t)
                                        +LBaddition(L,fgroups,t)
                                        +LBbldcap(L,fgroups,t)$(ord(t)>pipeleadtime)
                                        -LBexistcap(L,fgroups,t+1)=e=0;



*These five constraints ensure pipeline transport does not exceed capacity:
pipecaplimRL(R,L,mo,t)$tmo(t,mo).. sum(fgroups,pipeexistcapRL(fgroups,R,L,t))
                                  +sum(fgroups,pipebldcapRL(fgroups,R,L,t))$(ord(t)>2)
                                  +sum(fgroups,pipeadditionRL(fgroups,R,L,t))=g=sum(f$(RLm(R,L,'pipe') and tmo(t,mo)),qRL(R,L,'pipe',f,mo,t));

pipecaplimRL2(f,R,L,mo,t)$tmo(t,mo).. sum(fgroups$ffgroups(f,fgroups),pipeexistcapRL(fgroups,R,L,t))
                                     +sum(fgroups$ffgroups(f,fgroups),pipebldcapRL(fgroups,R,L,t))$(ord(t)>2)
                                     +sum(fgroups$ffgroups(f,fgroups),pipeadditionRL(fgroups,R,L,t))=g=qRL(R,L,'pipe',f,mo,t)$(RLm(R,L,'pipe') and tmo(t,mo));


pipecaplimLD(L,D,mo,t)$tmo(t,mo).. pipeexistcapLD(L,D,t)
                     +pipebldcapLD(L,D,t)$(ord(t)>pipeleadtime)=g=sum(f$(Duse(D,f,mo) and LDm(L,D,'pipe') and tmo(t,mo)),qLD(L,D,'pipe',f,mo,t))
                                                                 +sum(f$(Duse(D,f,mo) and LDm(L,D,'pipe') and tmo(t,mo)),qLD2(L,D,'pipe',f,mo,t))
                                                                 +sum(f$(Duse(D,f,mo) and LDm(L,D,'pipe') and tmo(t,mo)),qLD3(L,D,'pipe',f,mo,t));

pipecaplimLL(L,L2,mo,t)$(ord(L)<>ord(L2) and tmo(t,mo)).. sum(fgroups,pipeexistcapLL(fgroups,L,L2,t))
                                                         +sum(fgroups,pipebldcapLL(fgroups,L,L2,t))$(ord(t)>pipeleadtime)
                                                         +sum(fgroups,pipeadditionLL(fgroups,L,L2,t))
                                                         -sum(fgroups,piperetirementLL(fgroups,L,L2,t))=g=sum(f$(ord(L)<>ord(L2) and tmo(t,mo)),(qLL(L,L2,'pipe',f,mo,t)+qLL2(L,L2,'pipe',f,mo,t)));

pipecaplimLL2(f,L,L2,mo,t)$(ord(L)<>ord(L2) and tmo(t,mo)).. sum(fgroups$ffgroups(f,fgroups),pipeexistcapLL(fgroups,L,L2,t))
                                                            +sum(fgroups$ffgroups(f,fgroups),pipebldcapLL(fgroups,L,L2,t))$(ord(t)>pipeleadtime)
                                                            +sum(fgroups$ffgroups(f,fgroups),pipeadditionLL(fgroups,L,L2,t))
                                                            -sum(fgroups$ffgroups(f,fgroups),piperetirementLL(fgroups,L,L2,t))=g=(qLL(L,L2,'pipe',f,mo,t)+qLL2(L,L2,'pipe',f,mo,t))$(ord(L)<>ord(L2) and tmo(t,mo));



*These four constraints ensure trucking transport does not exceed loading and unloading capacity:
RLtruckcaplim(L,f,mo,t)$(tmo(t,mo)).. sum((fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups))=g=sum((R)$(RLm(R,L,'truck') and tmo(t,mo)),qRL(R,L,'truck',f,mo,t))
                                                                                              +sum((L2)$(LLm(L2,L,'truck') and tmo(t,mo)),(qLL(L2,L,'truck',f,mo,t)+qLL2(L2,L,'truck',f,mo,t)));


RLtruckcaplim2(L,mo,t)$(tmo(t,mo)).. sum(fgroups,TruckRLmax(L,fgroups))=g=sum((R,f)$(RLm(R,L,'truck') and tmo(t,mo)),qRL(R,L,'truck',f,mo,t))
                                                                         +sum((L2,f)$(LLm(L2,L,'truck') and tmo(t,mo)),(qLL(L2,L,'truck',f,mo,t)+qLL2(L2,L,'truck',f,mo,t)));



LDtruckcaplim(L,f,mo,t)$(tmo(t,mo))..
                                            sum((fgroups)$ffgroups(f,fgroups),LBexistcap(L,fgroups,t))
                                           +sum((fgroups)$ffgroups(f,fgroups),LBaddition(L,fgroups,t))
                                           +sum((fgroups)$ffgroups(f,fgroups),LBbldcap(L,fgroups,t))$(ord(t)>pipeleadtime)=g=sum((D)$(Duse(D,f,mo) and LDm(L,D,'truck') and tmo(t,mo)),(qLD(L,D,'truck',f,mo,t)+qLD2(L,D,'truck',f,mo,t)+qLD3(L,D,'truck',f,mo,t)))
                                                                                                                            +sum((L2)$(LLm(L,L2,'truck') and tmo(t,mo)),(qLL(L,L2,'truck',f,mo,t)+qLL2(L,L2,'truck',f,mo,t)));



LDtruckcaplim2(L,mo,t)$(tmo(t,mo))..
                                            sum(fgroups,LBexistcap(L,fgroups,t)
                                                       +LBaddition(L,fgroups,t)
                                                       +LBbldcap(L,fgroups,t)$(ord(t)>pipeleadtime))=g=sum((D,f)$(Duse(D,f,mo) and LDm(L,D,'truck') and tmo(t,mo)),(qLD(L,D,'truck',f,mo,t)+qLD2(L,D,'truck',f,mo,t)+qLD3(L,D,'truck',f,mo,t)))
                                                                                                      +sum((L2,f)$(LLm(L,L2,'truck') and tmo(t,mo)),(qLL(L,L2,'truck',f,mo,t)+qLL2(L,L2,'truck',f,mo,t)));


*This equation balances pipeline capacity through time:
PBScapbal(L,f,t)$(ord(t)<card(t)).. existcap(L,f,t)
                                   +bldcap(L,f,t)$(ord(t)>PBSleadtime)
                                   +PBSaddition(L,f,t)
                                   -existcap(L,f,t+1)=e=0;

*This constraint ensures domestic refined products transport is limited by its supply:
Rcapbal(R,f,mo,t)$tmo(t,mo).. (RefCap(R,f,mo,t))$tmo(t,mo)=g=sum((m,L)$( ( (RLm(R,L,m) and mSP(m)) or (RLm(R,L,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) ) and tmo(t,mo)),qRL(R,L,m,f,mo,t));

*These three constraints balance supply and demand:
*Mass conservation for L where rho=constant:
RLDinterbal(L,f,mo,t)$tmo(t,mo).. sum((R,m)$(((RLm(R,L,m) and mSP(m)) or (RLm(R,L,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0)) and tmo(t,mo)),qRL(R,L,m,f,mo,t))
                                 -sum((D,m)$( Duse(D,f,mo) and ( (LDm(L,D,m) and mP(m)) or (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)),qLD(L,D,m,f,mo,t))
                                 -sum((L2,m)$(( (LLm(L,L2,m) and mP(m)) or (LLm(L,L2,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L2,fgroups))>0 and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and ord(L)<>ord(L2) and tmo(t,mo)),qLL(L,L2,m,f,mo,t))=e=(qstin(L,f,mo,t)-qstout(L,f,mo,t))$tmo(t,mo);

LLDinterbal(L2,f,mo,t)$tmo(t,mo).. sum((L,m)$(( (LLm(L,L2,m) and mP(m)) or (LLm(L,L2,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L2,fgroups))>0 and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and ord(L)<>ord(L2) and tmo(t,mo)),qLL(L,L2,m,f,mo,t))
                                  -sum((L3,m)$(( (LLm(L2,L3,m) and mP(m)) or (LLm(L2,L3,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L3,fgroups))>0 and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L2,fgroups))>0) ) and ord(L2)<>ord(L3) and tmo(t,mo)),qLL2(L2,L3,m,f,mo,t))
                                  -sum((D,m)$(Duse(D,f,mo) and ( (LDm(L2,D,m) and mP(m)) or (LDm(L2,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L2,fgroups))>0) ) and tmo(t,mo)),qLD2(L2,D,m,f,mo,t))=e=(qstin(L2,f,mo,t)-qstout(L2,f,mo,t))$tmo(t,mo);

LLDinterbal2(L3,f,mo,t)$tmo(t,mo).. sum((L2,m)$(( (LLm(L2,L3,m) and mP(m)) or (LLm(L2,L3,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L3,fgroups))>0 and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L2,fgroups))>0) ) and ord(L2)<>ord(L3) and tmo(t,mo)),qLL2(L2,L3,m,f,mo,t))
                                   -sum((D,m)$(Duse(D,f,mo) and ( (LDm(L3,D,m) and mP(m)) or (LDm(L3,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L3,fgroups))>0) )  and tmo(t,mo)),qLD3(L3,D,m,f,mo,t))=e=(qstin(L3,f,mo,t)-qstout(L3,f,mo,t))$tmo(t,mo);


stobal(L,f,mo,t)$tmo(t,mo).. qstin(L,f,mo,t)$tmo(t,mo)-qstout(L,f,mo,t)$tmo(t,mo)
                            +qst(L,f,mo-1,t)$(coefa(t,'m12')<>0 and ord(mo)>1 and tmo(t,mo))
                            +qst(L,f,mo,t-1)$(coefa(t-1,'m12')=0 and ord(mo)=1 and tmo(t,mo))
                            +qst(L,f,'m12',t-1)$(coefa(t-1,'m12')<>0 and ord(mo)=1 and tmo(t,mo))=e=qst(L,f,mo,t)$tmo(t,mo);


*Storage capacity at L:
stolim(L,f,mo,t)$tmo(t,mo).. (existcap(L,f,t)+bldcap(L,f,t)$(ord(t)>PBSleadtime)+PBSaddition(L,f,t)-PBSretirement(L,f,t))*UtilRate=g=(qst(L,f,mo,t)*(DaysinYear$(coefa(t,mo)<>0 and coefa(t,'m2')=0)+DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)))$tmo(t,mo);

stomincon(L,f,mo,t)$(tmo(t,mo) and ord(t)>=3 and Lsto(L,f))..
                                                          qst(L,f,mo,t)$tmo(t,mo)=g=stomin*(sum((D,m)$(Duse(D,f,mo) and LDm(L,D,m) and tmo(t,mo)),qLD(L,D,m,f,mo,t))
                                                                                           +sum((D,m)$(Duse(D,f,mo) and LDm(L,D,m) and tmo(t,mo)),qLD2(L,D,m,f,mo,t))
                                                                                           +sum((D,m)$(Duse(D,f,mo) and LDm(L,D,m) and tmo(t,mo)),qLD3(L,D,m,f,mo,t)));

*Demand constraint:
dem(D,f,mo,t)$tmo(t,mo).. sum((L,m)$(Duse(D,f,mo) and ( (LDm(L,D,m) and mSP(m)) or (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)),qLD(L,D,m,f,mo,t))
                         +sum((L,m)$(Duse(D,f,mo) and ( (LDm(L,D,m) and mSP(m)) or (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)),qLD2(L,D,m,f,mo,t))
                         +sum((L,m)$(Duse(D,f,mo) and ( (LDm(L,D,m) and mSP(m)) or (LDm(L,D,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0) ) and tmo(t,mo)),qLD3(L,D,m,f,mo,t))=g=demval(D,f,mo,t);

*This equation sums the fuels' value:
fvaluebal(L,f,t).. sum((R,m,mo)$((RLm(R,L,m) and mSP(m)) or (RLm(R,L,m) and mTruck(m) and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) and tmo(t,mo)),fcost(R,f,t)*qRL(R,L,m,f,mo,t)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))*DaysinYear)=e=fvalue(L,f,t);

*CO2 emissions costs by trucks and ships:
CO2cstbal(t).. CO2cst(t)*( sum((R,L,f,mo)$((RLm(R,L,'truck') and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0) and tmo(t,mo)),qRL(R,L,'truck',f,mo,t)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))*TruckspecDieselRL(R,L))
                          +sum((L,D,f,mo)$(Duse(D,f,mo) and LDm(L,D,'truck') and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0 and tmo(t,mo)),(qLD(L,D,'truck',f,mo,t)+qLD2(L,D,'truck',f,mo,t)+qLD3(L,D,'truck',f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))*TruckspecDieselLD(L,D))
                          +sum((L2,L,f,mo)$((LLm(L,L2,'truck') and sum(fgroups$ffgroups(f,fgroups),TruckRLmax(L2,fgroups))>0) and sum(fgroups$ffgroups(f,fgroups),TruckLDmax(L,fgroups))>0 and tmo(t,mo)),(qLL(L,L2,'truck',f,mo,t)+qLL2(L,L2,'truck',f,mo,t))*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))*TruckspecDieselLL(L,L2))  )*DieseltCO2perL=e=CO2socialcst(t);

*LB build lim (41.1 MBD is currently an upper bound):
LBlim(L).. sum((fgroups,t),LBbldcap(L,fgroups,t))=l=41.1;

Model Dist /all/;

$Include Solve.gms

******Display parameters:
$Include Display.gms



