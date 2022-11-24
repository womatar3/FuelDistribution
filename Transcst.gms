$Include PipelineCosts.gms
$Include TruckingCosts.gms
$Include MaritimeCosts.gms

*************From oil refineries or import terminals to bulk stations:

*Pipeline (thousand$/bpd/km)
spectranscstRL(f,'pipe',R,L,t)=EleccostRL(f,R,L,t);
*Trucking (thousand$/bpd/km)
spectranscstRL(f,'truck',R,L,t)=TruckCostRL(f,R,L,t);
*Seaborne (thousand$/(bpd*km)):
spectranscstRL(f,'ship',R,L,t)$RLm(R,L,'ship')=MaritimeCost(R,L,f,t);

*In $/bpd:
transcstRL(f,m,R,L,t)=spectranscstRL(f,m,R,L,t)*distanceRL(m,R,L)*1e3;


*************From bulk stations to customers:
*Pipeline (thousand$/bpd/km)
spectranscstLD(f,'pipe',L,D,t)=Eleccost(f,t);
*Trucking (thousand$/bpd/km)
spectranscstLD(f,'truck',L,D,t)=TruckCostLD(f,L,D,t);

transcstLD(f,m,L,D,t)=spectranscstLD(f,m,L,D,t)*distanceLD(m,L,D)*1e3;


*************Between bulk stations:
*Pipeline (thousand$/bpd/km)
spectranscstLL(f,'pipe',L,L2,t)=EleccostLL(f,L,L2,t);

*Trucking (thousand$/bpd/km)
spectranscstLL(f,'truck',L,L2,t)=TruckCostLL(f,L,L2,t);

transcstLL(f,m,L,L2,t)=spectranscstLL(f,m,L,L2,t)*distanceLL(L,L2)*1e3;

display transcstLL,transcstRL,transcstLD;



