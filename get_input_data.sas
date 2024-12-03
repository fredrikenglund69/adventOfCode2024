%let dag = 4;
%let dd = %sysfunc(putn(&dag,z2.));

filename output "/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec&dd..txt";

proc http           
url="https://adventofcode.com/2024/day/&dag/input"       
method="get"
out=output;    
headers 
"cookie"="session=53616c7465645f5f19c72982cb64796954852bfc242c79d4795750be35796e42201302b6b8870823861f527e945f5795eb23fe467b221dc556e1c21531b975ce;";
    
run;