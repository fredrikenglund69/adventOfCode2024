
data indata;
 length row $200;
 retain ax ay bx by tx ty;

 infile _infile delimiter='#';

 input row;

	if scan(row,1,':') = 'Button A' then do;
		ax= input(scan(scan(row,2,':'),2,'+,'),best.);
		ay= input(scan(scan(row,2,':'),3,'+'),best.);
	end;
	 
	if scan(row,1,':') = 'Button B' then do;
		bx= input(scan(scan(row,2,':'),2,'+,'),best.);
		by= input(scan(scan(row,2,':'),3,'+'),best.);
	end;

	if scan(row,1,':') = 'Prize' then do;
		tx= input(scan(scan(row,2,':'),2,'=,'),best.);
		ty= input(scan(scan(row,2,':'),3,'='),best.);
		*output;

		do a = 1 to 100;
			do b = 1 to 100;
				posx = a*ax + b*bx;
				posy = a*ay + b*by;
				cost = (a + 10000000000000)*3 + (b + 10000000000000*1);
				put cost 20.;
				if posx = tx and posy=ty then output;
			end; 
		end;
	end;

run;

proc summary data=indata nway missing;
 var cost;
 output out=tot sum=;
run;

data prnt;
 set tot;
 put cost 20.;
run;

/*
7680000000039290 - to high
*/