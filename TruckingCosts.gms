*Some transportation characteristics data was taken from Marufuzzaman et al (2015) and Atterdige and Lloyd (2019) (on the computer):

*Capacity of 30 cubic meters:
FullLoad=30*Lperm3/LperBBL;

*0.63 SAR/L:
FuelPrice(t)=0.63/SARperUSD;
*In km/L:
TruckEff=5.1*kmpermile/LperGallon;
*($/month/person)*person/(trips/month):
LaborTruck=TruckWage*TruckDrivers/TripsperMonth/SARperUSD;
*From Marufuzzamn et al (2015), 0.17 $/mile.
TruckMaint=0.17/kmpermile;
*From Marufuzzamn et al (2015), 0.51 $/mile.
TruckFixedOM=0.51/kmpermile;

distanceRL(m,R,L)$(distanceRL(m,R,L)=0)=1;
distanceLD(m,L,D)$(distanceLD(m,L,D)=0)=1;

*Specific trucking cost:
*FuelPrice*Amount of fuel/km/bpd... ($/L*L/km/bpd)
*We divide by 2 because the truck is making the trip fully loaded one way, and then going back to the distribution station empty.
*Final units are in thousand$/bpd/km:
TruckCostRL(f,R,L,t)=(FuelPrice(t)/TruckEff+TruckMaint+TruckFixedOM+LaborTruck/(2*DistanceRL('truck',R,L)))/(FullLoad*AVGtruckspeed/(2*DistanceRL('truck',R,L)))/1e3;
TruckCostLD(f,L,D,t)=(FuelPrice(t)/TruckEff+TruckMaint+TruckFixedOM+LaborTruck/(2*DistanceLD('truck',L,D)))/(FullLoad*AVGtruckspeed/(2*DistanceLD('truck',L,D)))/1e3;
TruckCostLL(f,L,L2,t)$(DistanceLL(L,L2)>0)=(FuelPrice(t)/TruckEff+TruckMaint+TruckFixedOM+LaborTruck/(2*DistanceLL(L,L2)))/(FullLoad*AVGtruckspeed/(2*DistanceLL(L,L2)))/1e3;

*In L of diesel/barrel per day of fuel transported
TruckspecDieselRL(R,L)=DistanceRL('truck',R,L)/TruckEff/(FullLoad*Tripspermonth*12/365);
TruckspecDieselLD(L,D)=DistanceLD('truck',L,D)/TruckEff/(FullLoad*Tripspermonth*12/365);
TruckspecDieselLL(L,L2)=DistanceLL(L,L2)/TruckEff/(FullLoad*Tripspermonth*12/365);

*Accidents:
*10.2 2008Euro/(1000 tons*km) for heavy duty vehicles -> 2020USD/(bpd*km)
*1.16 2020Euro/2008Euro and 1.14 USD/Euro in 2020.
TruckAccCostsRL(f,R,L)=1.16*1.14*(10.2/1000)/kgperton*rho(f)/Lperm3*LperBBL/AVGtruckspeed*DistanceRL('truck',R,L)*Tripspermonth*12;
TruckAccCostsLL(f,L,L2)=1.16*1.14*(10.2/1000)/kgperton*rho(f)/Lperm3*LperBBL/AVGtruckspeed*DistanceLL(L,L2)*Tripspermonth*12;
TruckAccCostsLD(f,L,D)=1.16*1.14*(10.2/1000)/kgperton*rho(f)/Lperm3*LperBBL/AVGtruckspeed*DistanceRL('truck',L,D)*Tripspermonth*12;

display TruckEff,LaborTruck,TruckCostLL,TruckspecDieselRL,TruckAccCostsRL;


