Sets i time summation index for discounting /1*1000/;

*Discounting equations:

$MACRO  discfact(i,t)           1/(1+i)**t

$MACRO  sumdiscfact(T,i,n)      sum(n$(ord(n)<=T),discfact(i,(ord(n)-1)))

$MACRO  intdiscfact(i,t,tt)      sum(tt$(ord(tt)>=ord(t)),1/(1+i)**(ord(tt)-ord(t)))

$MACRO  discounting(Time,i,n,t,tt)  intdiscfact(i,t,tt)/sumdiscfact(Time,i,n)

;