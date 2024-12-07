%let numssize = 10;

data indata;
 length row $200 i a q nocomb range 8 sign $1 formel $200;
 infile _infile delimiter='#';

 array nums{&numssize.} 8 ;

 input row;

 /* read nums into array */
 i = 1;
 do until(scan(row,i,': ') = '');
	nums{i} = input(scan(row,i,': '),8.);
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
			 put row= nocomb= a= q= range= sign=;

			end;
		end;
		if q = (i-1) then sign = '';
		formel = cats(formel,nums(q), sign);
		*output;


/*		if q = 2 then do;*/
/*			if a in(1,3,5,7,9,11,13,15,17,19,21,23,25,27,29) then sign = '+';*/
/*			else sign = '*';*/
/*		end;*/
/**/
/*		if q = 3 then do;*/
/*			if a in(1,2,5,6,9,10,13,14,17,18,21,22,25,26,29,30) then sign = '+';*/
/*			else sign = '*';*/
/*		end;*/
/**/
/*		if q = 4 then do;*/
/*			if a in(1,2,3,4,9,10,11,12,17,18,19,20,25,26,27,28) then sign = '+';*/
/*			else sign = '*';*/
/*		end;*/
/**/
/*		if q = 5 then do;*/
/*			if a in(1,2,3,4,5,6,7,8,17,18,19,20,21,22,23,24) then sign = '+';*/
/*			else sign = '*';*/
/*		end;;*/

/*		if q = (i-1) then sign = '';*/
/*		formel = cats(formel,nums(q), sign);*/
	end;

	output;
 end;


run;