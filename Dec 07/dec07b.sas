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


/* create combinations with || ie # */
data more(drop=nums:);
 length newformel $200;
 set indata;
 array nums{&numssize.} 8 ;
 /* output existing rows*/;
 newformel = formel;
 output;
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
 length calc1 sum 8.;
 format calc1 15.;
 sum = input(scan(row,1,':'),best15.);
 calc1 = input(scan(newformel,1,'#+*'),best15.);
 i = 2;
 do while(scan(newformel,i,'#*+') ne '');
 	if scan(newformel,i-1,'1234567890') = '+' then calc1 = sum(calc1,input(scan(newformel,i,'#*+'),best15.));
 	if scan(newformel,i-1,'1234567890') = '*' then calc1 = calc1 * input(scan(newformel,i,'#*+'),best15.);
 	if scan(newformel,i-1,'1234567890') = '#' then calc1 = input(cats(put(calc1,best15.), scan(newformel,i,'#*+')),best15.);
 	i + 1;
 end;

 if calc1 = sum then output;
run;

proc sort data=calc out=sorted nodupkey;
 by row;
run;


proc summary data=sorted nway missing;
 var calc1;
 output out=tot sum=;
run;

/*
663613490587 - correct on task a

675856833361 - to low 
681775877852 - to low

110365987435001 - correct, bug i program :)
*/

