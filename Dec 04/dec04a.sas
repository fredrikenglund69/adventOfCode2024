%let gridsize = 10;

data indata;
 length row $200 i 8;
 array grid{&gridsize.,&gridsize.} $1;
 infile '/opt/sas/lagring/Lev1/it/adventofcode2024/kfen01/in_dec04_test.txt' delimiter='';
 retain pipes currposx currposy;

 input row;

 do i = 1 to &gridsize.;
	grid{i,_n_} = substr(row,i,1);

	if grid{i,_n_} = 'S' then do;
	   	currposx = i;
		currposy = _n_;
	end;
 end;

 if _n_ = &gridsize. then do;
 end;

run;