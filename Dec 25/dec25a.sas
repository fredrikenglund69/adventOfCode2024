/* Read data, split in two datasets */
data locks keys;
 infile _infile delimiter='';
 length row $5 a b c d e 8 type $1; 
 retain a b c d e type;

 input row;

 if _n_ = 1 then do;
 	i = 1;
 end;

 if i = 1 then do;
 	a=-1; b=-1; c=-1; d=-1; e=-1; /* one row is either locks or keys :) */
	if row = '#####' then type = 'L';
	else type = 'K';
 end;

 if substr(row,1,1) = '#' then a + 1;
 if substr(row,2,1) = '#' then b + 1;
 if substr(row,3,1) = '#' then c + 1;
 if substr(row,4,1) = '#' then d + 1;
 if substr(row,5,1) = '#' then e + 1;

 i + 1;

 if i = 8 then do;
 	i = 1;
	if type = 'L' then output locks;
	if type = 'K' then output keys;
 end;

run;

proc sql;
 create table tot as 
 select l.a,l.b,l.c,l.d,l.e, k.a as a1, k.b as b1, k.c as c1, k.d as d1, k.e as e1 from locks as l
 full join keys as k
 on l.i = k.i
 ;
quit;

data fits;
 set tot;
 if a + a1 < 6
 and b + b1 < 6
 and c + c1 < 6
 and d + d1 < 6
 and e + e1 < 6
 ;
run;
