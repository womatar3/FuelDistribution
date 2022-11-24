Parameters OptPBScap PBS capacity in thousand barrels, OptPipecapRL,OptPipecapLD Pipeline capacity in thousand bpd;
OptPBScap(L,f)=1e-10+sum(inc$(zinc(inc)=zmin),  existcapdisp(L,f,'t1',inc)+sum(t,bldcapdisp(L,f,t,inc))  );
OptPipecapRL(R,L,t)=1e-10+sum((inc,fgroups)$(zinc(inc)=zmin),  pipeexistcapRLdisp(fgroups,R,L,t,inc)  );
OptPipecapLD(L,D,t)=1e-10+sum(inc$(zinc(inc)=zmin),  pipeexistcapLDdisp(L,D,t,inc)  );

Parameters QstALL stored quantities for all bulk plants in thousand bpd;
QstALL(f,t,inc)=sum((L,mo),qstdisp(L,f,mo,t,inc)/12);

Parameters PBSInvCost,PipeInvCostRL,PipeInvCostLD,PipeInvCostLL investments in PBS and pipelines in million$,
           TransCostbyModeRL, TransCostbyModeLD in million$,ITCostperq average cost in $ per bpd, ModeShareRL,ModeShareLD,ModeShareRLtot,ModeShareLDtot,ModeShareRLLLtot,ModeShareLL in %
           ShareOfFuelTruckingRL,ShareOfFuelTruckingLD % share of each fuel in trucking transport by PBP,
           TruckingLimFracRL,TruckingLimFracLD,TruckingLimFracRLmonthly,TruckingLimFracLDmonthly,TruckingLimFracRLavg,TruckingLimFracLDavg,TruckingLimFracRLmonthlyTOT,TruckingLimFracLDmonthlyTOT
           TruckingLimFracRLmonthlymax,TruckingLimFracRLmonthlymin,TruckingLimFracLDmonthlymax,TruckingLimFracLDmonthlymin fractions of trucking offloading and loading capacities utilized;
PBSInvCost(L,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum(f,fullcapcst(L,f,t)*bldcapdisp(L,f,t,inc)) )/1e3;
PipeInvCostRL(R,L,t)=1e-10+sum((fgroups,inc)$(zinc(inc)=zmin), fullpipecapcstRL(R,L,t)*pipebldcapRLdisp(fgroups,R,L,t,inc) )/1e3;
PipeInvCostLD(L,D,t)=1e-10+sum((inc)$(zinc(inc)=zmin), fullpipecapcstLD(L,D,t)*pipebldcapLDdisp(L,D,t,inc) )/1e3;
PipeInvCostLL(L,L2,t)=1e-10+sum((fgroups,inc)$(zinc(inc)=zmin), fullpipecapcstLL(L,L2,t)*pipebldcapLLdisp(fgroups,L,L2,t,inc) )/1e3;
TransCostbyModeRL(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((R,L,f,mo),transcstRL(f,m,R,L,t)*qRLdisp(m,R,L,mo,t,f,inc)*(DaysinMonth(mo)/365$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))) )/1e3;
TransCostbyModeLD(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((L,D,f,mo),transcstLD(f,m,L,D,t)*qLDdisp(m,L,D,mo,t,f,inc)*(DaysinMonth(mo)/365$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))) )/1e3;
ModeShareRL(m,R,L,t)=1e-10+sum((inc)$(zinc(inc)=zmin and sum((f,m2,mo),qRLdisp(m2,R,L,t,f,mo,inc))>0), sum((f,mo),qRLdisp(m,R,L,mo,t,f,inc)-1e-10)/sum((f,m2,mo),qRLdisp(m2,R,L,mo,t,f,inc))*100 );
ModeShareLD(m,L,D,t)=1e-10+sum((inc)$(zinc(inc)=zmin and sum((f,m2,mo),qLDdisp(m2,L,D,t,f,mo,inc))>0), sum((f,mo),qLDdisp(m,L,D,mo,t,f,inc)-1e-10)/sum((f,m2,mo),qLDdisp(m2,L,D,mo,t,f,inc))*100 );
ModeShareLL(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((f,mo,L,L2),qLLdisp(m,L,L2,mo,t,f,inc)-1e-10)/sum((f,m2,mo,L,L2),qLLdisp(m2,L,L2,mo,t,f,inc))*100 );
ModeShareRLtot(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((R,L,f,mo),qRLdisp(m,R,L,mo,t,f,inc)-1e-10)/sum((R,L,f,m2,mo),qRLdisp(m2,R,L,mo,t,f,inc))*100 );
ModeShareRLLLtot(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), ( sum((R,L,f,mo),qRLdisp(m,R,L,mo,t,f,inc)-1e-10)+sum((L,L2,f,mo),qLLdisp(m,L,L2,mo,t,f,inc)) )/sum((L,f), sum((R,m2,mo),qRLdisp(m2,R,L,mo,t,f,inc))+sum((L2,m2,mo),qLLdisp(m2,L,L2,mo,t,f,inc)) )*100 );
ModeShareLDtot(m,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((L,D,f,mo),qLDdisp(m,L,D,mo,t,f,inc)-1e-10)/sum((L,D,f,m2,mo),qLDdisp(m2,L,D,mo,t,f,inc))*100 );
ITCostperq(t)=sum((inc)$(zinc(inc)=zmin), (sum((L,R),PipeInvCostRL(R,L,t))+sum((L,D),PipeInvCostLD(L,D,t))+sum(L,PBSInvCost(L,t))+sum(m,TransCostbymodeLD(m,t))+sum(m,TransCostbymodeRL(m,t)))/sum((L,D,f,m,mo),qLDdisp(m,L,D,mo,t,f,inc)) )*1e3;
ShareOfFuelTruckingRL(L,f,t)=1e-10+sum((inc)$(zinc(inc)=zmin and sum((R,mo),qRLdisp('truck',R,L,mo,t,f,inc)>0)), sum((R,mo),qRLdisp('truck',R,L,mo,t,f,inc))/sum((R,f2,mo),qRLdisp('truck',R,L,mo,t,f2,inc))*100 );
ShareOfFuelTruckingLD(L,f,t)=1e-10+sum((inc)$(zinc(inc)=zmin and sum((D,mo),qLDdisp('truck',L,D,mo,t,f,inc)>0)), sum((D,mo),qLDdisp('truck',L,D,mo,t,f,inc))/sum((D,f2,mo),qLDdisp('truck',L,D,mo,t,f2,inc))*100 );
TruckingLimFracRL(f,L,t)$(sum((fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0)=1e-10+(sum((R,mo),sum(inc$(zinc(inc)=zmin),qRLdisp('truck',R,L,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))-1e-10))+sum((L2,mo), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L2,L,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)))-1e-10 ))/sum((fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups));
TruckingLimFracLD(f,L,t)=1e-10+(sum((D,mo),sum(inc$(zinc(inc)=zmin),qLDdisp('truck',L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))-1e-10))+sum((L2,mo), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L,L2,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)))-1e-10 ))/sum((fgroups)$ffgroups(f,fgroups),saveTruckLDmax(L,fgroups));
TruckingLimFracRLmonthly(f,L,mo,t)$(sum((fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0)=1e-10+(sum((R),sum(inc$(zinc(inc)=zmin),qRLdisp('truck',R,L,mo,t,f,inc)-1e-10))+sum((L2), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L2,L,mo,t,f,inc)-1e-10 )) )/sum((fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups));
TruckingLimFracLDmonthly(f,L,mo,t)=1e-10+(sum((D),sum(inc$(zinc(inc)=zmin),qLDdisp('truck',L,D,mo,t,f,inc)-1e-10))+sum((L2), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L,L2,mo,t,f,inc)-1e-10 )) )/sum((inc,fgroups)$(zinc(inc)=zmin and ffgroups(f,fgroups)),LBexistdisp(L,fgroups,t,inc)+LBblddisp(L,fgroups,t,inc));

TruckingLimFracRLmonthlyTOT(L,mo,t)$(sum((f,fgroups)$ffgroups(f,fgroups),TruckRLmax(L,fgroups))>0)=1e-10+(sum((f,R),sum(inc$(zinc(inc)=zmin),qRLdisp('truck',R,L,mo,t,f,inc)-1e-10))+sum((f,L2), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L2,L,mo,t,f,inc)-1e-10 )) )/sum((fgroups),TruckRLmax(L,fgroups));
TruckingLimFracLDmonthlyTOT(L,mo,t)=1e-10+(sum((f,D),sum(inc$(zinc(inc)=zmin),qLDdisp('truck',L,D,mo,t,f,inc)+qLDdisp('pipe',L,D,mo,t,f,inc)-1e-10))+sum((f,L2), sum(inc$(zinc(inc)=zmin),qLLdisp('truck',L,L2,mo,t,f,inc)-1e-10 )) )/sum((inc,fgroups)$(zinc(inc)=zmin),LBexistdisp(L,fgroups,t,inc)+LBblddisp(L,fgroups,t,inc));

TruckingLimFracRLmonthlymax(L,t)=smax(mo,TruckingLimFracRLmonthlyTOT(L,mo,t));
TruckingLimFracRLmonthlymin(L,t)=smin(mo,TruckingLimFracRLmonthlyTOT(L,mo,t));
TruckingLimFracLDmonthlymax(L,t)=smax(mo,TruckingLimFracLDmonthlyTOT(L,mo,t));
TruckingLimFracLDmonthlymin(L,t)=smin(mo,TruckingLimFracLDmonthlyTOT(L,mo,t));

TruckingLimFracRLavg(t)=sum((L,mo),TruckingLimFracRLmonthlyTOT(L,mo,t))/12/8;
TruckingLimFracLDavg(t)=sum((L,mo),TruckingLimFracLDmonthlyTOT(L,mo,t))/12/21;


Parameters MC, MCyr fuel marginal costs in $ per barrel per year, MCmeanD, MCmean weighted average fuel MC in $ per barrel per year
           MCmaxmin,MCmaxminMeanD maximum MC minus minimum MC for each fuel in $ per bpd;
MC(D,f,mo,t)=1e-10+sum((inc)$(zinc(inc)=zmin), demmdisp(D,f,mo,t,inc)/(DaysinMonth(mo)$(coefa(t,'m2')<>0)+365$(coefa(t,'m2')=0)));
MCyr(D,f,t)=1e-10+smax(mo, sum((inc)$(zinc(inc)=zmin), demmdisp(D,f,mo,t,inc)/(DaysinMonth(mo)$(coefa(t,'m2')<>0)+365$(coefa(t,'m2')=0))) );
MCmeanD(D,f,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((m,mo),MC(D,f,mo,t)*sum((L),qLDdisp(m,L,D,mo,t,f,inc)))/sum((L,m,mo),qLDdisp(m,L,D,mo,t,f,inc)) );
MCmean(f,t)=1e-10+sum((inc)$(zinc(inc)=zmin), sum((D,m,mo),MC(D,f,mo,t)*sum((L),qLDdisp(m,L,D,mo,t,f,inc)))/sum((L,D2,m,mo),qLDdisp(m,L,D2,mo,t,f,inc)) );
MCmaxminMeanD(f,t)=smax((D)$(MCmeanD(D,f,t)>1e-5),MCmeanD(D,f,t))-smin((D)$(MCmeanD(D,f,t)>1e-5),MCmeanD(D,f,t));
MCmaxmin(f,t)=smax((D,mo)$(MC(D,f,mo,t)>1e-5),MC(D,f,mo,t))-smin((D,mo)$(MC(D,f,mo,t)>1e-5),MC(D,f,mo,t));
Parameters Optinc optimal scenario for inc
           Optlat,Optlong optimal location for new petroleum bulk stations in coordinates;

Loop((inc)$(zinc(inc)=zmin),
Optinc(inc)=ord(inc);
     );

Optlat(L)$(ord(L)>34)=0;
*sum(inc$(ord(inc)=Optinc(inc)),lat(L,inc));
Optlong(L)$(ord(L)>34)=0;
*sum(inc$(ord(inc)=Optinc(inc)),long(L,inc));

Parameters zmin_cap,zmin_fixedOM,zmin_transcstLD,zmin_transcstRL,zmin_transcstLL,zmin_value,zmin_CO2cst,zmin_truckAcc zmin components in thousand$,
           DieselConsump Diesel use by trucks in thousand L;

zmin_cap=sum((inc)$(zinc(inc)=zmin),
             sum((fgroups,R,L,t),pipecapcstRLdisp(R,L,t,inc)*pipebldcapRLdisp(fgroups,R,L,t,inc)*distdiscfact(t))
            +sum((L,D,t),pipecapcstLDdisp(L,D,t,inc)*pipebldcapLDdisp(L,D,t,inc)*distdiscfact(t))
            +sum((f,L,t),capcstdisp(L,f,t,inc)*bldcapdisp(L,f,t,inc)*distdiscfact(t))
             );

zmin_fixedOM=sum((inc)$(zinc(inc)=zmin),
             sum((fgroups,R,L,t),pipeomcstRLdisp(R,L,t,inc)*(pipeexistcapRLdisp(fgroups,R,L,t,inc)+pipebldcapRLdisp(fgroups,R,L,t,inc))*distdiscfact(t))
            +sum((L,D,t),pipeomcstLDdisp(L,D,t,inc)*(pipeexistcapLDdisp(L,D,t,inc)+pipebldcapLDdisp(L,D,t,inc))*distdiscfact(t))
            +sum((f,L,t),omcstdisp(L,f,t,inc)*(existcapdisp(L,f,t,inc)+bldcapdisp(L,f,t,inc))*distdiscfact(t))
             );

zmin_transcstLD=sum((inc)$(zinc(inc)=zmin),
             sum((f,L,D,t,m,mo), transcstLDdisp(f,m,L,D,t,inc)*qLDdisp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0))*distdiscfact(t) )
          );

zmin_transcstRL=sum((inc)$(zinc(inc)=zmin),
             sum((R,L,f,t,mo), sum(m$RLm(R,L,m),transcstRLdisp(f,m,R,L,t,inc)*qRLdisp(m,R,L,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)))*distdiscfact(t)  )
          );


zmin_transcstLL=sum((inc)$(zinc(inc)=zmin),
             sum((L,L2,f,t,mo), sum(m$LLm(L,L2,m),transcstLLdisp(f,m,L,L2,t,inc)*qLLdisp(m,L,L2,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)))*distdiscfact(t)  )
          );

zmin_value=sum((inc)$(zinc(inc)=zmin),
                              sum((L,f,t),fvaluedisp(L,f,t,inc)*distdiscfact(t))
          );

zmin_CO2cst=sum((inc)$(zinc(inc)=zmin),
                              sum(t,CO2socialcstdisp(t,inc)*distdiscfact(t))
          );

zmin_truckAcc=sum((inc)$(zinc(inc)=zmin),
                         sum((mo,t),(sum((f,L,R,m), TruckAccCostsRL(f,R,L)*qRLdisp(m,R,L,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                                     +sum((f,L,L2,m), TruckAccCostsLL(f,L,L2)*qLLdisp(m,L,L2,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                                      +sum((f,L,D,m), TruckAccCostsLD(f,L,D)*qLDdisp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                                )*distdiscfact(t)
                             )
          );

DieselConsump(t)=sum(inc$(zinc(inc)=zmin),DieselConsumpdisp(t,inc));
Parameter TotQLD,TotQLD2,TotQLD3 total quantities in million bpd, minDistused,maxdistused min and max distances crossed for transported products;
TotQLD(t)=sum((L,D,m,f,mo,inc)$(zinc(inc)=zmin),qLDdisp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)));
TotQLD2(t)=sum((L,D,m,f,mo,inc)$(zinc(inc)=zmin),qLD2disp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)));
TotQLD3(t)=sum((L,D,m,f,mo,inc)$(zinc(inc)=zmin),qLD3disp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)));
minDistused(m,f,t)=smin((L,D,mo)$(sum(inc$(zinc(inc)=zmin), (qLDdisp(m,L,D,mo,t,f,inc)+qLD2disp(m,L,D,mo,t,f,inc)) )>0),distanceLD(m,L,D));
maxdistused(m,f,t)=smax((L,D,mo)$(sum(inc$(zinc(inc)=zmin), (qLDdisp(m,L,D,mo,t,f,inc)+qLD2disp(m,L,D,mo,t,f,inc)) )>0),distanceLD(m,L,D));


Parameter survivaldays,survivaldays2 survival days by bulk plant,Fueldistancem,FueldistanceRLm,FueldistanceRLShip mass-distance transported by mode in metric tons-km,FuelImports imports in million barrels;
survivaldays(L,f,t)$(iniexistcap(L,f)>0)=(sum(inc$(zinc(inc)=zmin),existcapdisp(L,f,t,inc)+bldcapdisp(L,f,t,inc))+PBSaddition(L,f,t))/sum((D,m,mo,inc)$(zinc(inc)=zmin),qLDdisp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)));
survivaldays2(L,f,t)=sum((inc,mo)$(zinc(inc)=zmin),qstdisp(L,f,mo,t,inc)* ((DaysinMonth(mo))$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0))) /sum((D,m,mo,inc)$(zinc(inc)=zmin),qLDdisp(m,L,D,mo,t,f,inc)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)));

Fueldistancem(m,t)=sum((R,L,mo,inc)$(zinc(inc)=zmin), distanceRL(m,R,L)*sum(f,(qRLdisp(m,R,L,mo,t,f,inc)-1e-10)*LperBBL/Lperm3*rho(f)/kgperton/1000)*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                  +sum((L,D,mo,inc)$(zinc(inc)=zmin), distanceLD(m,L,D)*sum(f,(qLDdisp(m,L,D,mo,t,f,inc)-1e-10)*LperBBL/Lperm3*rho(f)/kgperton/1000)*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) )
                  +sum((L2,L,mo,inc)$(zinc(inc)=zmin), distanceLL(L,L2)*sum(f,(qLLdisp(m,L,L2,mo,t,f,inc)-1e-10)*LperBBL/Lperm3*rho(f)/kgperton/1000)*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) ) ;
FueldistanceRLm(m,t)=sum((R,L,mo,inc)$(zinc(inc)=zmin), distanceRL(m,R,L)*sum(f,(qRLdisp(m,R,L,mo,t,f,inc)-1e-10)*LperBBL/Lperm3*rho(f)/kgperton/1000)*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) ) ;
FueldistanceRLShip(R,L,t)=sum((mo,inc)$(zinc(inc)=zmin), distanceRL('ship',R,L)*sum(f,(qRLdisp('ship',R,L,mo,t,f,inc)-1e-10)*LperBBL/Lperm3*rho(f)/kgperton/1000)*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) ) ;
FuelImports(f,t)=sum((R,L,m,mo,inc)$(ord(R)>10 and zinc(inc)=zmin), qRLdisp(m,R,L,mo,t,f,inc)/1000*(DaysinMonth(mo)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+365$(coefa(t,mo)<>0 and coefa(t,'m2')=0)) );

Parameter EXRLgas91transAN,EXRLgas95transAN,EXRLdieseltransAN,EXRLjetfueltransAN,EXRLkerostransAN,
          EXRLgas91transM1,EXRLgas95transM1,EXRLdieseltransM1,EXRLjetfueltransM1,EXRLkerostransM1,
          EXRLgas91transM7,EXRLgas95transM7,EXRLdieseltransM7,EXRLjetfueltransM7,EXRLkerostransM7,

          EXLLgas91transAN,EXLLgas95transAN,EXLLdieseltransAN,EXLLjetfueltransAN,EXLLkerostransAN,
          EXLLgas91transM1,EXLLgas95transM1,EXLLdieseltransM1,EXLLjetfueltransM1,EXLLkerostransM1,
          EXLLgas91transM7,EXLLgas95transM7,EXLLdieseltransM7,EXLLjetfueltransM7,EXLLkerostransM7,

          EXLDgas91transAN,EXLDgas95transAN,EXLDdieseltransAN,EXLDjetfueltransAN,EXLDkerostransAN,
          EXLDgas91transM1,EXLDgas95transM1,EXLDdieseltransM1,EXLDjetfueltransM1,EXLDkerostransM1,
          EXLDgas91transM7,EXLDgas95transM7,EXLDdieseltransM7,EXLDjetfueltransM7,EXLDkerostransM7,

EXRL2021transANGas
EXRL2021transANLSD
EXRL2021transANJetFK

EXRL2025transANGas
EXRL2025transANLSD
EXRL2025transANJetFK

EXRL2030transANGas
EXRL2030transANLSD
EXRL2030transANJetFK

EXRL2035transANGas
EXRL2035transANLSD
EXRL2035transANJetFK

EXRL2040transANGas
EXRL2040transANLSD
EXRL2040transANJetFK


EXLD2021transANGas
EXLD2021transANLSD
EXLD2021transANJetFK

EXLD2025transANGas
EXLD2025transANLSD
EXLD2025transANJetFK

EXLD2030transANGas
EXLD2030transANLSD
EXLD2030transANJetFK

EXLD2035transANGas
EXLD2035transANLSD
EXLD2035transANJetFK

EXLD2040transANGas
EXLD2040transANLSD
EXLD2040transANJetFK

EXLL2021transANGas
EXLL2021transANLSD
EXLL2021transANJetFK

EXLL2025transANGas
EXLL2025transANLSD
EXLL2025transANJetFK

EXLL2030transANGas
EXLL2030transANLSD
EXLL2030transANJetFK

EXLL2035transANGas
EXLL2035transANLSD
EXLL2035transANJetFK

EXLL2040transANGas
EXLL2040transANLSD
EXLL2040transANJetFK

          EXRL2021transAN,EXLL2021transAN,EXLD2021transAN,
          EXRL2025transAN,EXRL2030transAN,EXRL2035transAN,EXRL2040transAN,
          EXLL2025transAN,EXLL2030transAN,EXLL2035transAN,EXLL2040transAN,
          EXLD2025transAN,EXLD2030transAN,EXLD2035transAN,EXLD2040transAN for easier exporting to Excel;

*qRL
EXRL2021transANGas(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qRLdisp(m,R,L,mo,'t1','f1',inc)+qRLdisp(m,R,L,mo,'t1','f2',inc)) ));
EXRL2021transANLSD(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*qRLdisp(m,R,L,mo,'t1','f4',inc) ));
EXRL2021transANJetFK(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qRLdisp(m,R,L,mo,'t1','f5',inc)+qRLdisp(m,R,L,mo,'t1','f3',inc)) ));

EXRL2025transANGas(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qRLdisp(m,R,L,mo,'t5','f1',inc)+qRLdisp(m,R,L,mo,'t5','f2',inc)) ));
EXRL2025transANLSD(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*qRLdisp(m,R,L,mo,'t5','f4',inc) ));
EXRL2025transANJetFK(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qRLdisp(m,R,L,mo,'t5','f5',inc)+qRLdisp(m,R,L,mo,'t5','f3',inc)) ));

EXRL2030transANGas(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qRLdisp(m,R,L,mo,'t10','f1',inc)+qRLdisp(m,R,L,mo,'t10','f2',inc)) ));
EXRL2030transANLSD(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*qRLdisp(m,R,L,mo,'t10','f4',inc) ));
EXRL2030transANJetFK(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qRLdisp(m,R,L,mo,'t10','f5',inc)+qRLdisp(m,R,L,mo,'t10','f3',inc)) ));

EXRL2035transANGas(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qRLdisp(m,R,L,mo,'t15','f1',inc)+qRLdisp(m,R,L,mo,'t15','f2',inc)) ));
EXRL2035transANLSD(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*qRLdisp(m,R,L,mo,'t15','f4',inc) ));
EXRL2035transANJetFK(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qRLdisp(m,R,L,mo,'t15','f5',inc)+qRLdisp(m,R,L,mo,'t15','f3',inc)) ));

EXRL2040transANGas(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qRLdisp(m,R,L,mo,'t20','f1',inc)+qRLdisp(m,R,L,mo,'t20','f2',inc)) ));
EXRL2040transANLSD(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*qRLdisp(m,R,L,mo,'t20','f4',inc) ));
EXRL2040transANJetFK(m,R,L)$(ord(R)>1)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qRLdisp(m,R,L,mo,'t20','f5',inc)+qRLdisp(m,R,L,mo,'t20','f3',inc)) ));

*qLL

EXLL2021transANGas(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qLLdisp(m,L,L2,mo,'t1','f1',inc)+qLLdisp(m,L,L2,mo,'t1','f2',inc)) ));
EXLL2021transANLSD(m,L,L2)=sum((inc)$(zinc(inc)=zmin), sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*qLLdisp(m,L,L2,mo,'t1','f4',inc) ));
EXLL2021transANJetFK(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qLLdisp(m,L,L2,mo,'t1','f5',inc)+qLLdisp(m,L,L2,mo,'t1','f3',inc)) ));

EXLL2025transANGas(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qLLdisp(m,L,L2,mo,'t5','f1',inc)+qLLdisp(m,L,L2,mo,'t5','f2',inc)) ));
EXLL2025transANLSD(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*qLLdisp(m,L,L2,mo,'t5','f4',inc) ));
EXLL2025transANJetFK(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qLLdisp(m,L,L2,mo,'t5','f5',inc)+qLLdisp(m,L,L2,mo,'t5','f3',inc)) ));

EXLL2030transANGas(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qLLdisp(m,L,L2,mo,'t10','f1',inc)+qLLdisp(m,L,L2,mo,'t10','f2',inc)) ));
EXLL2030transANLSD(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*qLLdisp(m,L,L2,mo,'t10','f4',inc) ));
EXLL2030transANJetFK(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qLLdisp(m,L,L2,mo,'t10','f5',inc)+qLLdisp(m,L,L2,mo,'t10','f3',inc)) ));

EXLL2035transANGas(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qLLdisp(m,L,L2,mo,'t15','f1',inc)+qLLdisp(m,L,L2,mo,'t15','f2',inc)) ));
EXLL2035transANLSD(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*qLLdisp(m,L,L2,mo,'t15','f4',inc) ));
EXLL2035transANJetFK(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qLLdisp(m,L,L2,mo,'t15','f5',inc)+qLLdisp(m,L,L2,mo,'t15','f3',inc)) ));

EXLL2040transANGas(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qLLdisp(m,L,L2,mo,'t20','f1',inc)+qLLdisp(m,L,L2,mo,'t20','f2',inc)) ));
EXLL2040transANLSD(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*qLLdisp(m,L,L2,mo,'t20','f4',inc) ));
EXLL2040transANJetFK(m,L,L2)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qLLdisp(m,L,L2,mo,'t20','f5',inc)+qLLdisp(m,L,L2,mo,'t20','f3',inc)) ));


*qLD

EXLD2021transANGas(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qLDdisp(m,L,D,mo,'t1','f1',inc)+qLDdisp(m,L,D,mo,'t1','f2',inc)) ));
EXLD2021transANLSD(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*qLDdisp(m,L,D,mo,'t1','f4',inc) ));
EXLD2021transANJetFK(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t1',mo)<>0 and coefa('t1','m2')<>0)+1$(coefa('t1',mo)<>0 and coefa('t1','m2')=0))*(qLDdisp(m,L,D,mo,'t1','f5',inc)+qLDdisp(m,L,D,mo,'t1','f3',inc)) ));

EXLD2025transANGas(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qLDdisp(m,L,D,mo,'t5','f1',inc)+qLDdisp(m,L,D,mo,'t5','f2',inc)) ));
EXLD2025transANLSD(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*qLDdisp(m,L,D,mo,'t5','f4',inc) ));
EXLD2025transANJetFK(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t5',mo)<>0 and coefa('t5','m2')<>0)+1$(coefa('t5',mo)<>0 and coefa('t5','m2')=0))*(qLDdisp(m,L,D,mo,'t5','f5',inc)+qLDdisp(m,L,D,mo,'t5','f3',inc)) ));

EXLD2030transANGas(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qLDdisp(m,L,D,mo,'t10','f1',inc)+qLDdisp(m,L,D,mo,'t10','f2',inc)) ));
EXLD2030transANLSD(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*qLDdisp(m,L,D,mo,'t10','f4',inc) ));
EXLD2030transANJetFK(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t10',mo)<>0 and coefa('t10','m2')<>0)+1$(coefa('t10',mo)<>0 and coefa('t10','m2')=0))*(qLDdisp(m,L,D,mo,'t10','f5',inc)+qLDdisp(m,L,D,mo,'t10','f3',inc)) ));

EXLD2035transANGas(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qLDdisp(m,L,D,mo,'t15','f1',inc)+qLDdisp(m,L,D,mo,'t15','f2',inc)) ));
EXLD2035transANLSD(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*qLDdisp(m,L,D,mo,'t15','f4',inc) ));
EXLD2035transANJetFK(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t15',mo)<>0 and coefa('t15','m2')<>0)+1$(coefa('t15',mo)<>0 and coefa('t15','m2')=0))*(qLDdisp(m,L,D,mo,'t15','f5',inc)+qLDdisp(m,L,D,mo,'t15','f3',inc)) ));

EXLD2040transANGas(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qLDdisp(m,L,D,mo,'t20','f1',inc)+qLDdisp(m,L,D,mo,'t20','f2',inc)) ));
EXLD2040transANLSD(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*qLDdisp(m,L,D,mo,'t20','f4',inc) ));
EXLD2040transANJetFK(m,L,D)=sum((inc)$(zinc(inc)=zmin),  sum(mo,((DaysinMonth(mo)/365)$(coefa('t20',mo)<>0 and coefa('t20','m2')<>0)+1$(coefa('t20',mo)<>0 and coefa('t20','m2')=0))*(qLDdisp(m,L,D,mo,'t20','f5',inc)+qLDdisp(m,L,D,mo,'t20','f3',inc)) ));


Display zmin,zinc,TruckingLimFracRLmonthlyTOT,TruckingLimFracLDmonthlyTOT,PBSInvCost,PipeInvCostRL,PipeInvCostLD,TransCostbyModeRL,TransCostbyModeLD,ITCostperq,MCyr,MCmean,MCmaxmin,TruckingLimFracRLavg,TruckingLimFracLDavg,FueldistanceRLm,FueldistanceRLShip,FuelImports,
        ModeShareRLtot,ModeShareLL,ModeShareRLLLtot,ModeShareLDtot,optinc,optlat,optlong,DieselConsump,zmin_CO2cst,TotQLD,TotQLD2,TotQLD3,mindistused,maxdistused,TruckingLimFracRL,TruckingLimFracLD;


execute_unload 'Transport.gdx'
EXRL2021transANGas
EXRL2021transANLSD
EXRL2021transANJetFK

EXRL2025transANGas
EXRL2025transANLSD
EXRL2025transANJetFK

EXRL2030transANGas
EXRL2030transANLSD
EXRL2030transANJetFK

EXRL2035transANGas
EXRL2035transANLSD
EXRL2035transANJetFK

EXRL2040transANGas
EXRL2040transANLSD
EXRL2040transANJetFK


EXLD2021transANGas
EXLD2021transANLSD
EXLD2021transANJetFK

EXLD2025transANGas
EXLD2025transANLSD
EXLD2025transANJetFK

EXLD2030transANGas
EXLD2030transANLSD
EXLD2030transANJetFK

EXLD2035transANGas
EXLD2035transANLSD
EXLD2035transANJetFK

EXLD2040transANGas
EXLD2040transANLSD
EXLD2040transANJetFK

EXLL2021transANGas
EXLL2021transANLSD
EXLL2021transANJetFK

EXLL2025transANGas
EXLL2025transANLSD
EXLL2025transANJetFK

EXLL2030transANGas
EXLL2030transANLSD
EXLL2030transANJetFK

EXLL2035transANGas
EXLL2035transANLSD
EXLL2035transANJetFK

EXLL2040transANGas
EXLL2040transANLSD
EXLL2040transANJetFK;

Parameter DomProdoverDem;

DomProdoverDem(f,t)=sum((R,mo)$(ord(R)<11),RefCap(R,f,mo,t)*((DaysinMonth(mo)/365)$(coefa(t,mo)<>0 and coefa(t,'m2')<>0)+1$(coefa(t,mo)<>0 and coefa(t,'m2')=0)))/sum((D,mo),demval(D,f,mo,t));

Display DomProdoverDem;

