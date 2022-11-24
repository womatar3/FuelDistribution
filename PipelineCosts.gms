*33-in (0.8382-m) diameter for prospective investments:
Dm=0.8382;
DmRL(R,L)=0.8382;
DmLL(L,L2)=0.8382;

*Actual data:
DmRL(R,L)=0.762;
DmLL(L,L2)=0.610;

utilrate=0.9;
pumpeff=0.8;
g=9.81;
hrsyr=8760;

*Current industrial tariff of 500 USD/MWh:
ElecP(t)=500;

*(kg/m^3):
rho(f)=844;


*(sq m/sec):
*1 cSt=1e-6 m^2/sec
nu(f)=0.64*1e-6;

*Calculations (based on Verma et al (2017)):
*volumetric flow rate = velocity * cross-sectional area of pipe
*m/sec
speed(f)=0.333481;

*Reynolds number:
Re(f)=speed(f)*Dm/nu(f);
ReRL(f,R,L)=speed(f)*DmRL(R,L)/nu(f);
ReLL(f,L,L2)=speed(f)*DmLL(L,L2)/nu(f);

*Friction coefficient (laminar flow (Re < 2000) ---> f=64/Re; turbulent flow (Re > 4000) ---> f=f(moody chart for a roughness of commercial steel=0.00015 ft);
*in-between (2000<Re<4000) ---> f=f(moody chart for a roughness of commercial steel=0.00015 ft) (approximation to the Colebrook equation)
*McQuiston et al (2005) and ScienceDirect
rough=0.00015*MetersinaFoot;
A(f)=(2.457*log(1/((7/Re(f))**0.9+0.27*rough/Dm)))**16;
B(f)=(37530/Re(f))**16;

fc(f)$(Re(f)<=2000)=64/Re(f);
fc(f)$(Re(f)>2000 and Re(f)<=4000)=8*((8/Re(f))**12+1/(A(f)+B(f))**1.5)**(1/12);
fc(f)$(Re(f)>4000)=(1.14+2*log10(Dm/rough))**(-2);

*R to L:
A_RL(f,R,L)=(2.457*log(1/((7/ReRL(f,R,L))**0.9+0.27*rough/DmRL(R,L))))**16;
B_RL(f,R,L)=(37530/ReRL(f,R,L))**16;

fcRL(f,R,L)$(ReRL(f,R,L)<=2000)=64/ReRL(f,R,L);
fcRL(f,R,L)$(ReRL(f,R,L)>2000 and ReRL(f,R,L)<=4000)=8*((8/ReRL(f,R,L))**12+1/(A_RL(f,R,L)+B_RL(f,R,L))**1.5)**(1/12);
fcRL(f,R,L)$(ReRL(f,R,L)>4000)=(1.14+2*log10(DmRL(R,L)/rough))**(-2);

*L to L2
A_LL(f,L,L2)=(2.457*log(1/((7/ReLL(f,L,L2))**0.9+0.27*rough/DmLL(L,L2))))**16;
B_LL(f,L,L2)=(37530/ReLL(f,L,L2))**16;

fcLL(f,L,L2)$(ReLL(f,L,L2)<=2000)=64/ReLL(f,L,L2);
fcLL(f,L,L2)$(ReLL(f,L,L2)>2000 and ReLL(f,L,L2)<=4000)=8*((8/ReLL(f,L,L2))**12+1/(A_LL(f,L,L2)+B_LL(f,L,L2))**1.5)**(1/12);
fcLL(f,L,L2)$(ReLL(f,L,L2)>4000)=(1.14+2*log10(DmLL(L,L2)/rough))**(-2);


*Head loss gradient (hL/L; unitless):
*hL=f*L*v^2/(2*D*g);
hl(f)=fc(f)*speed(f)**2/(2*Dm*g);
hlRL(f,R,L)=fcRL(f,R,L)*speed(f)**2/(2*DmRL(R,L)*g);
hlLL(f,L,L2)=fcLL(f,L,L2)*speed(f)**2/(2*DmLL(L,L2)*g);

*Electricity required:
*In MWh/m/bpd:
*specific gravity*head loss gradient*volumetric flow rate= power in W
*utilrate/pumpefficiency takes into account efficiency losses and utiliziation
*hrsyr is the number of hours in a year to convert power to energy
*1e6 is to convert W to MW.
*Divided by bpd, which is just speed*A*conversion_factors
Elecreq(f)=rho(f)*g*hl(f)/pumpeff*utilrate*hrsyr/( Lperm3/LperBBL*3600*24 )/1e6;
ElecreqRL(f,R,L)=rho(f)*g*hlRL(f,R,L)/pumpeff*utilrate*hrsyr/( Lperm3/LperBBL*3600*24 )/1e6;
ElecreqLL(f,L,L2)=rho(f)*g*hlLL(f,L,L2)/pumpeff*utilrate*hrsyr/( Lperm3/LperBBL*3600*24 )/1e6;

*In thousand$/km/bpd:
Eleccost(f,t)=ElecP(t)*Elecreq(f);
EleccostRL(f,R,L,t)=ElecP(t)*ElecreqRL(f,R,L);
EleccostLL(f,L,L2,t)=ElecP(t)*ElecreqLL(f,L,L2);

Display speed,Re,ReRL,ReLL,hl,fc,fcRL,Elecreq,Eleccost;
