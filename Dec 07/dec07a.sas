%let numssize = 30;

data indata;
 length row $200 i a q nocomb range calc 8 sign $1 formel $200;
 infile _infile delimiter='#';

 array nums{&numssize.} 8 ;

 input row;

 /* read nums into array */
 i = 1;
 do until(scan(row,i,': ') = '');
	nums{i} = input(scan(row,i,': '),best.);
	i + 1;
 end;

 /* create combinations */
 nocomb = 2**(i-3);
 do a = 1 to nocomb;
 	formel = '';

 	do q = 2 to (i-1);
		if q < (i-1) then do; /* not last nums */
			sign='*';
			do range = 1 to nocomb by 2**(q-1);
			 if range <= a < (range + 2**(q-2)) then sign = '+';
			end;
		end;
		if q = (i-1) then sign = '';
		formel = cats(formel,nums(q), sign);
		if q = 2 then calc = nums(q);
		if sign = '+' then calc = sum(calc,nums(q+1));
		if sign = '*' then calc = calc * nums(q+1);
	end;

	if calc = nums(1) then output;
 end;

run;

proc sort data=indata out=sorted nodupkey;
 by row;
run;

proc summary data=sorted nway missing;
 var calc;
 output out=tot sum=;
run;

/*
346 - to low , not sum just no rows!
434 - to low , not sum just no rows!
663613490587
*/