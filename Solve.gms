$ontext
Options for invscen:

0: runs a case with no investments. This case is best suited for a short-run analysis of a particular year, as opposed to multi-period analysis.
1: runs a case or cases with investment allowed in a multi-period fashion. Scenarios are included in BPscenarios.gms that pertain to deactivation or activation of reserved lands or new prospective BP locations.

If option "1" is selected and the time period is set for a single year, the model will revert to a long-run simulation of a steady-state year in which investments may be made.
$offtext

Scalar invscen allow investment in L /1/;

Parameter zinc, zmin z for each increment and minimum objective value in thousand$,
          bldcapdisp,pipebldcapRLdisp,pipebldcapLDdisp,qRLdisp,qLDdisp,qLD2disp,qLD3disp,qLLdisp,demmdisp,Distancedisp,qRLsetdisp,LBblddisp,LBexistdisp,fvaluedisp,pipebldcapLLdisp,pipeexistcapLLdisp
          transcstRLdisp,transcstLDdisp,transcstLLdisp,omcstdisp,pipeomcstRLdisp,pipeomcstLDdisp,capcstdisp,pipecapcstRLdisp,pipecapcstLDdisp,pipecapcstLLdisp,pipeomcstLLdisp,
          existcapdisp,pipeexistcapRLdisp,pipeexistcapLDdisp,qstdisp,CO2socialcstdisp,DieselConsumpdisp indexed by inc to save results after each loop,count,count2;
*truckRLlimDVdisp,truckLDlimDVdisp

Parameter lat,long coordinate ranges for Saudi Arabia
          latrad,longrad geographical ranges in radians;

Sets RLpairs(R,L) pairs of refineries and on-site BPs;
RLpairs(R,L)=no;


inc_run(inc)=no;
inc_run(inc)$(ord(inc)=17)=yes;

count=0;
count2=0;

If(invscen=1,
                 Loop((inc,demscen)$(inc_run(inc) and demscen_run(demscen)),


*execute_loadpoint 'Dist_p1.gdx';

if(ord(inc)>1,Options limrow=1e4, limcol=1e4, solprint=on);
$offinclude
$offlisting

if(card(t)=1,
PBSleadtime=0;
pipeleadtime=0;
   );

$INCLUDE BPscenarios.gms

*For  proposed bulk plants:
                 geolocrad(L,'lat')$(ord(L)=35 or ord(L)=36)=lat(L,inc)*pi/180;
                 geolocrad(L,'long')$(ord(L)=35 or ord(L)=36)=long(L,inc)*pi/180;

                 distanceLD(m,L,D)$(ord(L)=35 or ord(L)=36)=2*arcsin(sqrt((sin(ABS(geolocrad(L,'lat')-geolocrad(D,'lat'))/2))**2 + cos(geolocrad(L,'lat'))*cos(geolocrad(D,'lat'))*(sin(ABS(geolocrad(L,'long')-geolocrad(D,'long'))/2))**2));
                 distanceLD(m,L,D)$(ord(L)=35 or ord(L)=36)=distanceLD(m,L,D)*6371;
                 distanceLD(m,L,D)$(distanceLD(m,L,D)=0)=1;

                 distanceRL(m,R,L)$(ord(L)=35 or ord(L)=36)=2*arcsin(sqrt((sin(ABS(geolocrad(R,'lat')-geolocrad(L,'lat'))/2))**2 + cos(geolocrad(R,'lat'))*cos(geolocrad(L,'lat'))*(sin(ABS(geolocrad(R,'long')-geolocrad(L,'long'))/2))**2));
                 distanceRL(m,R,L)$(ord(L)=35 or ord(L)=36)=distanceRL(m,R,L)*6371;
                 distanceRL(m,R,L)$(distanceRL(m,R,L)=0)=1;

                 distanceLL(L,L2)$((ord(L)=35 or ord(L)=36) and (ord(L2)=35 or ord(L2)=36) and ord(L)<>ord(L2))=2*arcsin(sqrt((sin(ABS(geolocrad(L,'lat')-geolocrad(L2,'lat'))/2))**2 + cos(geolocrad(L,'lat'))*cos(geolocrad(L2,'lat'))*(sin(ABS(geolocrad(L,'long')-geolocrad(L2,'long'))/2))**2));
                 distanceLL(L,L2)$((ord(L)=35 or ord(L)=36) and (ord(L2)=35 or ord(L2)=36) and ord(L)<>ord(L2))=distanceLL(L,L2)*6371;

                 Distancedisp(m,L,D,inc)=distanceLD(m,L,D);


$Include Transcst.gms
$Include InvestmentCosts.gms


                 Solve Dist using LP minimizing z;

                 zinc(inc)=z.l;
                 bldcapdisp(L,f,t,inc)=bldcap.l(L,f,t);
                 existcapdisp(L,f,t,inc)=existcap.l(L,f,t);
                 pipebldcapRLdisp(fgroups,R,L,t,inc)=pipebldcapRL.l(fgroups,R,L,t);
                 pipeexistcapRLdisp(fgroups,R,L,t,inc)=pipeexistcapRL.l(fgroups,R,L,t);
                 pipebldcapLDdisp(L,D,t,inc)=pipebldcapLD.l(L,D,t);
                 pipeexistcapLDdisp(L,D,t,inc)=pipeexistcapLD.l(L,D,t);
                 pipebldcapLLdisp(fgroups,L,L2,t,inc)=pipebldcapLL.l(fgroups,L,L2,t);
                 pipeexistcapLLdisp(fgroups,L,L2,t,inc)=pipeexistcapLL.l(fgroups,L,L2,t);
                 LBblddisp(L,fgroups,t,inc)=LBbldcap.l(L,fgroups,t);
                 LBexistdisp(L,fgroups,t,inc)=LBexistcap.l(L,fgroups,t);
                 qRLdisp(m,R,L,mo,t,f,inc)=1e-10+qRL.l(R,L,m,f,mo,t);
                 qLDdisp(m,L,D,mo,t,f,inc)=1e-10+qLD.l(L,D,m,f,mo,t)+qLD2.l(L,D,m,f,mo,t)+qLD3.l(L,D,m,f,mo,t);
                 qLD2disp(m,L,D,mo,t,f,inc)=1e-10+qLD2.l(L,D,m,f,mo,t);
                 qLD3disp(m,L,D,mo,t,f,inc)=1e-10+qLD3.l(L,D,m,f,mo,t);
                 qLLdisp(m,L,L2,mo,t,f,inc)=1e-10+qLL.l(L,L2,m,f,mo,t)+qLL2.l(L,L2,m,f,mo,t);
                 qstdisp(L,f,mo,t,inc)=1e-10+qst.l(L,f,mo,t);
                 demmdisp(D,f,mo,t,inc)=dem.m(D,f,mo,t);
                 fvaluedisp(L,f,t,inc)=fvalue.l(L,f,t);
                 transcstRLdisp(f,m,R,L,t,inc)=transcstRL(f,m,R,L,t);
                 transcstLDdisp(f,m,L,D,t,inc)=transcstLD(f,m,L,D,t);
                 transcstLLdisp(f,m,L,L2,t,inc)=transcstLL(f,m,L,L2,t);
                 omcstdisp(L,f,t,inc)=omcst(L,f,t);
                 capcstdisp(L,f,t,inc)=capcst(L,f,t);
                 pipeomcstRLdisp(R,L,t,inc)=pipeomcstRL(R,L,t);
                 pipecapcstRLdisp(R,L,t,inc)=pipecapcstRL(R,L,t);
                 pipeomcstLDdisp(L,D,t,inc)=pipeomcstLD(L,D,t);
                 pipecapcstLDdisp(L,D,t,inc)=pipecapcstLD(L,D,t);
                 pipeomcstLLdisp(L,L2,t,inc)=pipeomcstLL(L,L2,t);
                 pipecapcstLLdisp(L,L2,t,inc)=pipecapcstLL(L,L2,t);
                 CO2socialcstdisp(t,inc)=CO2socialcst.l(t);


DieselConsumpdisp(t,inc)=sum((R,L,f,mo),qRLdisp('truck',R,L,mo,t,f,inc)*TruckspecDieselRL(R,L))+sum((L,D,f,mo),qLDdisp('truck',L,D,mo,t,f,inc)*TruckspecDieselLD(L,D))+sum((L,L2,f,mo),qLLdisp('truck',L,L2,mo,t,f,inc)*TruckspecDieselLL(L,L2));


*display geolocrad,distanceLD,distanceRL;

*loop close
                     );

else

inc_run(inc)=no;
inc_run(inc)$(ord(inc)=17)=yes;

                 Loop((inc)$(inc_run(inc)),



if(card(t)=1, distdiscfact(t)=1;) ;

                 bldcap.fx(L,f,t)=0;
                 pipebldcapRL.fx(fgroups,R,L,t)=0;
                 pipebldcapLD.fx(L,D,t)=0;
                 pipebldcapLL.fx(fgroups,L,L2,t)=0;


display qRL.up;

display inipipeexistcap,pipeexistcapRL.l,pipeexistcapLL.l;


                 Solve Dist using LP minimizing z;

                 bldcapdisp(L,f,t,inc)=bldcap.l(L,f,t);
                 existcapdisp(L,f,t,inc)=existcap.l(L,f,t);
                 pipebldcapRLdisp(fgroups,R,L,t,inc)=pipebldcapRL.l(fgroups,R,L,t);
                 pipeexistcapRLdisp(fgroups,R,L,t,inc)=pipeexistcapRL.l(fgroups,R,L,t);
                 pipebldcapLDdisp(L,D,t,inc)=pipebldcapLD.l(L,D,t);
                 pipeexistcapLDdisp(L,D,t,inc)=pipeexistcapLD.l(L,D,t);
                 pipebldcapLLdisp(fgroups,L,L2,t,inc)=pipebldcapLL.l(fgroups,L,L2,t);
                 pipeexistcapLLdisp(fgroups,L,L2,t,inc)=pipeexistcapLL.l(fgroups,L,L2,t);
                 LBblddisp(L,fgroups,t,inc)=LBbldcap.l(L,fgroups,t);
                 LBexistdisp(L,fgroups,t,inc)=LBexistcap.l(L,fgroups,t);
                 qRLdisp(m,R,L,mo,t,f,inc)=1e-10+qRL.l(R,L,m,f,mo,t);
                 qLDdisp(m,L,D,mo,t,f,inc)=1e-10+qLD.l(L,D,m,f,mo,t)+qLD2.l(L,D,m,f,mo,t)+qLD3.l(L,D,m,f,mo,t);
                 qLD2disp(m,L,D,mo,t,f,inc)=1e-10+qLD2.l(L,D,m,f,mo,t);
                 qLD3disp(m,L,D,mo,t,f,inc)=1e-10+qLD3.l(L,D,m,f,mo,t);
                 qLLdisp(m,L,L2,mo,t,f,inc)=1e-10+qLL.l(L,L2,m,f,mo,t)+qLL2.l(L,L2,m,f,mo,t);
                 qstdisp(L,f,mo,t,inc)=1e-10+qst.l(L,f,mo,t);
                 demmdisp(D,f,mo,t,inc)=dem.m(D,f,mo,t);
                 fvaluedisp(L,f,t,inc)=fvalue.l(L,f,t);
                 transcstRLdisp(f,m,R,L,t,inc)=transcstRL(f,m,R,L,t);
                 transcstLDdisp(f,m,L,D,t,inc)=transcstLD(f,m,L,D,t);
                 transcstLLdisp(f,m,L,L2,t,inc)=transcstLL(f,m,L,L2,t);
                 omcstdisp(L,f,t,inc)=omcst(L,f,t);
                 capcstdisp(L,f,t,inc)=capcst(L,f,t);
                 pipeomcstRLdisp(R,L,t,inc)=pipeomcstRL(R,L,t);
                 pipecapcstRLdisp(R,L,t,inc)=pipecapcstRL(R,L,t);
                 pipeomcstLDdisp(L,D,t,inc)=pipeomcstLD(L,D,t);
                 pipecapcstLDdisp(L,D,t,inc)=pipecapcstLD(L,D,t);
                 pipeomcstLLdisp(L,L2,t,inc)=pipeomcstLL(L,L2,t);
                 pipecapcstLLdisp(L,L2,t,inc)=pipecapcstLL(L,L2,t);
                 CO2socialcstdisp(t,inc)=CO2socialcst.l(t);


DieselConsumpdisp(t,inc)=sum((R,L,f,mo),qRLdisp('truck',R,L,mo,t,f,inc)*TruckspecDieselRL(R,L))+sum((L,D,f,mo),qLDdisp('truck',L,D,mo,t,f,inc)*TruckspecDieselLD(L,D))+sum((L,L2,f,mo),qLLdisp('truck',L,L2,mo,t,f,inc)*TruckspecDieselLL(L,L2));

                 zinc(inc)=z.l;
*Loop close
);


*If close
   );


zmin=smin((inc)$(zinc(inc)>0),zinc(inc));

display count;

