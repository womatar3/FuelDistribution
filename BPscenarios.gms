*This is a sheet where any and all scenarios may be defined for bulk plant locations and asset additions/retirements:

$ontext
*These are  lands that are unused:
qRL.up(R,'L1',m,f,mo,t)=0;
qLD.up('L1',D,m,f,mo,t)=0;
qLL.fx(L,L2,m,f,mo,t)$(ord(L)=1 or ord(L2)1)=0;
qLD2.up('L1',D,m,f,mo,t)=0;
qLD3.up('L1',D,m,f,mo,t)=0;
qLL2.fx(L,L2,m,f,mo,t)$(ord(L)=1 or ord(L2)=1)=0;


count=count+1;
$offtext

*placeholders:
lat('L4',inc)=13.4; long('L4',inc)=23.6;
lat('L4',inc)=28.7; long('L4',inc)=26.3;


PBSaddition(L,f,t)=0;
PBSretirement(L,f,t)=0;
pipeadditionRL(fgroups,R,L,t)=0;




