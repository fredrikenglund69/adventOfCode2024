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

	output;
 end;

run;


/* create combinations with || */
data more;
 length newformel $200;
 set indata;
 array nums{&numssize.} 8 ;

 /* create combinations */
 nocomb = nocomb - 1; /*2**(i-4);*/
 do a = 1 to nocomb;
 	newformel = '';

 	do q = 2 to (i-1);
		if q < (i-1) then do; /* not last nums */
			sign=scan(formel,q-1,'1234567890');
			do range = 1 to nocomb by 2**(q-1);
			 if range <= a < (range + 2**(q-2)) then sign = '#';
			end;
		end;
		if q = (i-1) then sign = '';
		newformel = cats(newformel,scan(formel,q-1), sign);
	end;


	output;
 end;

run;
proc sort data=more nodupkey;
 by newformel;
run;

/* calc newformel */
data calc;
 set more;
 calc = scan(newformel,1);
 i = 2;

 do while(scan(newformel,i) ne '');
 	if scan(newformel,i-1,'1234567890') = '+' then calc = sum(calc,input(scan(newformel,i),best.));
 	if scan(newformel,i-1,'1234567890') = '*' then calc = calc * input(scan(newformel,i),best.);
 	i + 1;
 end;

 if calc = nums1 then output;
run;

data newindata;
 set more;
 array nums{&numssize.} 8 ;

	/* empty array and fill with new combinations */
	do q = 2 to &numssize.;
		nums(q) = .;
	end;

	i = 1;
	do until(scan(formel,i,'#') = '');
		nums{i+1} = input(scan(formel,i,'#'),best.);
		i + 1;
	end;
	i + 1; /* since formula not contains total sum */
run;


data allcomb;
 set newindata;
 array nums{&numssize.} 8 ;

 /* create combinations */
 i = 1;
 do until (nums(i) eq .);
 	i + 1;
 end;

 nocomb = 2**(i-1);
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

proc sort data=allcomb out=sorted nodupkey;
 by row;
run;

proc summary data=sorted nway missing;
 var calc;
 output out=tot sum=;
run;

