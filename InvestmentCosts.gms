$ontext
API (2017,, p.22) states an investment cost of about 15 $/barrel for crude oil storage.
Taking fixed O&M costs as 3% of investment costs.
$offtext

*$/barrel:
capcst(L,f,t)=15;
omcst(L,f,t)=0.03*capcst(L,f,t);


*Trucking loading bays ($/bpd):
*ICF(2018, p.34) estimates 1 $/gal/day for incremental investment and 2 $/gal/day for new investment.
LBcapcst(t)=42;
LBomcst(t)=LBcapcst(t)*0.005;


*$/bpd for a 33-inch-diameter pipeline used by Verma et al (2017) whose capacity is 750,000 bpd.
*Booster stations every 100 km.
*3508 thousand$/mile*mile/1.6km*3000km + 16600 thousand$ for an inlet pump+ 72,302 thousand$/booster station*31 booster stations
pipecapcstRL(R,L,t)=8.83e9/3000/750000*distanceRL('pipe',R,L);
*17.7 thousand$/mile/yr*1.6 miles*3000km for pipeline maintenance + 15936.1 thousand$/yr for pump maintenance :
pipeomcstRL(R,L,t)=49e6/3000/750000*distanceRL('pipe',R,L);

pipecapcstLD(L,D,t)=8.83e9/3000/750000*distanceLD('pipe',L,D);
pipeomcstLD(L,D,t)=49e6/3000/750000*distanceLD('pipe',L,D);

pipecapcstLL(L,L2,t)=8.83e9/3000/750000*distanceLL(L,L2);
pipeomcstLL(L,L2,t)=49e6/3000/750000*distanceLL(L,L2);

fullcapcst(L,f,t)=capcst(L,f,t);
fullpipecapcstRL(R,L,t)=pipecapcstRL(R,L,t);
fullpipecapcstLD(L,D,t)=pipecapcstLD(L,D,t);
fullpipecapcstLL(L,L2,t)=pipecapcstLL(L,L2,t);

*Discounting
distdiscfact(t)=discfact(discrate,ord(t));
*Discounting plant capital costs over lifetime (assuming 25 years):
discoef(t)=discounting(30,discrate,i,t,t2);
display discoef,distdiscfact,capcst,pipecapcstRL;
capcst(L,f,t)=capcst(L,f,t)*discoef(t);
LBcapcst(t)=LBcapcst(t)*discoef(t);
pipecapcstRL(R,L,t)=pipecapcstRL(R,L,t)*discoef(t);
pipecapcstLD(L,D,t)=pipecapcstLD(L,D,t)*discoef(t);
pipecapcstLL(L,L2,t)=pipecapcstLL(L,L2,t)*discoef(t);

display capcst,pipecapcstRL,pipecapcstLD,pipecapcstLL;



