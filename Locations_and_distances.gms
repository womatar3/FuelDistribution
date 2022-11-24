*******Defining geographical coordinates of petroleum bulk stations and demand centers:
Table geoloc(*,*) geographical location of existing facilities in degrees lat N long W
   long       lat
*R1:
R1 34         08
*R2
R2 30         50

*L1
L1 40         14
*L2
L2 45         16

;
*In thousand bpd:
$CALL GDXXRW.exe distdata.xlsx par=dloclat rng=demareas!b1:c488 Rdim=1 Cdim=1
Parameter dloclat(D,*) demand centers' coordinates;
$GDXIN distdata.gdx
$LOAD dloclat
$GDXIN
;
*In thousand bpd:
$CALL GDXXRW.exe distdata.xlsx par=dloclong rng=demareas!d1:e488 Rdim=1 Cdim=1
Parameter dloclong(D,*) demand centers' coordinates;
$GDXIN distdata.gdx
$LOAD dloclong
$GDXIN
;

geoloc(D,'lat')=dloclat(D,'lat');
geoloc(D,'long')=dloclong(D,'long');
display dloclat,dloclong,geoloc;


Parameter geolocrad in radians,
          distanceRL,distanceLD,distanceLL distance in thousands of kilometers between (R and L) & (L and D) & (L and L2);
geolocrad(R,'lat')=geoloc(R,'lat')*pi/180;
geolocrad(R,'long')=geoloc(R,'long')*pi/180;
geolocrad(L,'lat')=geoloc(L,'lat')*pi/180;
geolocrad(L,'long')=geoloc(L,'long')*pi/180;
geolocrad(D,'lat')=geoloc(D,'lat')*pi/180;
geolocrad(D,'long')=geoloc(D,'long')*pi/180;



$CALL GDXXRW.exe distdata.xlsx par=distruckRL rng=RoadDist!m2:o289 Rdim=2 Cdim=0
Parameter distruckRL(R,L) trucking distance in km from R to L;
$GDXIN distdata.gdx
$LOAD distruckRL
$GDXIN
;
distanceRL('truck',R,L)=distruckRL(R,L);
display distanceRL;

*******From oil refineries to bulk stations:
*Distance in radians:
distanceRL(m,R,L)$((ord(m)=card(m) and distruckRL(R,L)=0) or ord(m)<card(m))=2*arcsin(sqrt((sin(ABS(geolocrad(R,'lat')-geolocrad(L,'lat'))/2))**2 + cos(geolocrad(R,'lat'))*cos(geolocrad(L,'lat'))*(sin(ABS(geolocrad(R,'long')-geolocrad(L,'long'))/2))**2));
*Distance in km is distance in radians multiplied by the earth's radius in km (6,371 km):
distanceRL(m,R,L)$((ord(m)=card(m) and distruckRL(R,L)=0) or ord(m)<card(m))=distanceRL(m,R,L)*6371;
Display distanceRL;
distanceRL(m,R,L)$(distanceRL(m,R,L)=0)=1;


*******Multipliers because ships have to travel farther (around peninsula), still in $/bpd:
Parameter DistanceMP distance multiplier between R and L to factor in shipping distance around Arabian Peninsula (unitless);
*For example, maritime shipping from R to L may cross 6,000 km, whereas the trucking distance between the two points is 1,000 km.
distanceMP(R,L)=1/distanceRL('ship',R,L);
distanceRL('ship',R,L)$RLm(R,L,'ship')=distanceRL('ship',R,L)*distanceMP(R,L);
Display distanceRL;


*******From bulk station to bulk station:
distanceLL(L,L2)$(ord(L)<>ord(L2))=2*arcsin(sqrt((sin(ABS(geolocrad(L,'lat')-geolocrad(L2,'lat'))/2))**2 + cos(geolocrad(L,'lat'))*cos(geolocrad(L2,'lat'))*(sin(ABS(geolocrad(L,'long')-geolocrad(L2,'long'))/2))**2));
*Distance in km is distance in radians multiplied by the earth's radius in km (6,371 km):
distanceLL(L,L2)$(ord(L)<>ord(L2))=distanceLL(L,L2)*6371;
distanceLL(L,L2)$(distanceLL(L,L2)=0)=1;



$CALL GDXXRW.exe distdata.xlsx par=distruckLD rng=RoadDist!c2:e15067 Rdim=2 Cdim=0
Parameter distruckLD(L,D) trucking distance in km from L to D;
$GDXIN distdata.gdx
$LOAD distruckLD
$GDXIN
;
distanceLD('truck',L,D)=distruckLD(L,D);

********From bulk stations to customers:
distanceLD(m,L,D)$((ord(m)=card(m) and distruckLD(L,D)=0) or ord(m)<card(m))=2*arcsin(sqrt((sin(abs(geolocrad(L,'lat')-geolocrad(D,'lat'))/2))**2 + cos(geolocrad(L,'lat'))*cos(geolocrad(D,'lat'))*(sin(abs(geolocrad(L,'long')-geolocrad(D,'long'))/2))**2));
*Distance in km is distance in radians multiplied by the earth's radius in km (6,371 km):
distanceLD(m,L,D)$((ord(m)=card(m) and distruckLD(L,D)=0) or ord(m)<card(m))=distanceLD(m,L,D)*6371;

distanceLD(m,L,D)$(distanceLD(m,L,D)=0)=1;

Display distanceRL,distanceLD,distanceLL,distruckLD,distruckRL,geolocrad;
