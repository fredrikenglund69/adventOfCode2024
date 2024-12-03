%let dag = 4;
%let dd = %sysfunc(putn(&dag,z2.));

filename output "/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec&dd..txt";

proc http           
url="https://adventofcode.com/2024/day/&dag/input"       
method="get"
out=output;    
headers 
    
run;