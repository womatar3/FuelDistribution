Parameter spectranscstRL, spectranscstLD, spectranscstLL costs for each fuel in thousand$ per bpd per km;
*Pipeline
Parameters Dm proposed diameter (m), DmRL, DmLL actual diameters of existing pipeline (m), utilrate utiliziation rate (%), pumpeff pump efficiency (%),
           ElecP electricity price (SAR per MWh), rho mass densities of products in kg per cubic m,
           FlowRate volumetric flow rate in cubic meters per hour, g gravitation acceleration in m per sec2
           nu kinematic viscosity in m2 per sec,hrsyr number of hours in a year;

Parameters fc,fcRL,fcLL friction coefficient unitless, hl,hlRL,hlLL head loss gradient unitless,rough absolute roughness of pipe material in meters
           speed speed in m per sec, Re,ReRL,ReLL Reynolds number,A,B,A_RL,B_RL,A_LL,B_LL parameters used to compute fc
           elecreq,elecreqRL,elecreqLL electricity required in MWh per bpd per m of pipline length,
           eleccost,eleccostRL,eleccostLL thousand$ per bpd per km of pipeline length;

Scalar MetersinaFoot meters in a foot /0.3048/;




$ontext
Maritime

Seaborne costs are from https://www.bimco.org/news/market_analysis/2021/20210903-tanker-shipping---profitability-still-a-way-off-for-loss-making-tankers-as-pandemic-drags-on
We are presuming an oil products tanker, which holds ~50,000 DWT. Costs are around 8,400 dollars/day.

Source for average speed: https://www.sciencedirect.com/science/article/pii/S1366554520306232 (using 12 knots)
$offtext

Parameter MaritimeCost cost of shipping in thousand$ per bpd per km
          traveltime(R,L) number of days to travel distance;

Scalar ProdTankDWT dead weight tonnage of product tanker in tons /5e4/
       ProdTankRate daily rate for leasing product tanker in thousand$ per day /8.4/
       Lperm3 Liters in a cubic meter /1e3/
       LperBBL liters in a barrel /158.99/
       kgperton kg in a ton /1e3/
       AVGspeed km per day /533/;



*Trucking
Parameters FuelPrice domestic price of diesel (thousand$ per thousandL),
           TruckEff fuel economy of truck when fully loaded with fuel (thousandKM per thousandL),
           LaborTruck cost of labor in thousand$ per thousand trips,
           TruckMaint variable maintenance costs in thousand$ per thousandKM,
           FullLoad payload of fuel in barrels,
           TruckFixedOM fixed operations and maintenance costs in thousand$ per thousandKM,
           TruckCostLD total cost of trucking fuel in thousand$ per bpd per km between L and D,
           TruckCostRL total cost of trucking fuel in thousand$ per bpd per km between R and L
           TruckCostLL total cost of trucking fuel in thousand$ per bpd per km between L and L2
           TruckspecDieselRL Diesel use in L per barrel per day along R and L
           TruckspecDieselLD Diesel use in L per barrel per day along L and D
           TruckspecDieselLL Diesel use in L per barrel per day along L and L2   
           TruckAccCostsRL Estimated cost of road accidents in 2020USD per bpd per km from R to L
           TruckAccCostsLL Estimated cost of road accidents in 2020USD per bpd per km from L to L2
           TruckAccCostsLD Estimated cost of road accidents in 2020USD per bpd per km from L to D;

Scalar LperGallon /3.785/
       kmpermile /1.6/
       SARperUSD /3.75/
*EPA Emission Factors for Greenhouse Gas Inventories (Table 2 - Mobile Combustion CO2):
       DieselCO2perGallon kg of CO2 per gallon of diesel /10.21/
       TruckWage SAR per month per person /1500/
       TruckDrivers Number of truckers /6/
       TripsperMonth /80/
       DieseltCO2perL tons of CO2 per L of diesel
*8-hour shift
       AVGtruckspeed km per day /800/;

DieseltCO2perL=DieselCO2perGallon/kgperton/LperGallon;

Display DieseltCO2perL;
