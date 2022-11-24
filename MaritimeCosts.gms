traveltime(R,L)$RLm(R,L,'ship')=distanceRL('ship',R,L)/avgspeed;
display traveltime;

*In thousand$/bpd
MaritimeCost(R,L,f,t)$RLm(R,L,'ship')=ProdTankRate*traveltime(R,L)*rho(f)/kgperton/ProdTankDWT/Lperm3*LperBBL/AVGspeed;




