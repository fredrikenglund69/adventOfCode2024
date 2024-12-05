%macro validate(in=);
 	i = 2; /* skip check on first doc */
	valid = 1; /* treat row as valid at start */
	do while(scan(&in,i) ne '');
		currdoc = input(scan(&in,i),8.);
		/* check if doc order is valid */
		k = 1;
		do while(scan(rules{currdoc},k) ne '');
			do a = 1 to i - 1;
				/* if we can find rule before current doc it is not valid */
				if scan(&in,a) = scan(rules{currdoc},k) then do;
					valid = 0;
					rule = scan(&in,a);
					k = 1000; /* to leave loop */
					leave;
				end;
			end;
			k + 1;
		end;

		if k > 1000 then leave;

		i + 1;
	end;
%mend;

data indata;
 length row row2 rowtmp $200 i k a q l s currdoc valid middoc midsum 8 rule $2;
 array rules{100} $200;
 infile _infile delimiter='' end=_last;
 retain rules midsum;

 input row;

 /* if row contains rule (|), add rule to rules array separated by |*/
 if findc(row,'|') then do;
 	rules{input(scan(row,1),8.)} = cats(rules{input(scan(row,1),8.)},scan(row,2),'|');
 end;

 /* if rows contain docs, check if valid and then find middle no */
 if findc(row,',') then do;
 	%validate(in=row);
	if valid = 0 then do;
		s = 0;
		row2 = row;
		rowtmp = '';

		do until(valid = 1 or s > 10000);
			/* rearrange if not valid, place wrong doc after current doc */
			if valid = 0 then do;
				/* first to wrong doc */
				do q = 1 to a - 1;
					rowtmp = cats(rowtmp,scan(row2,q),',');
				end;

				/* then to current doc */
				do q = a + 1 to i;
					rowtmp = cats(rowtmp,scan(row2,q),',');
				end;

				/* then add wrong after current */
				rowtmp = cats(rowtmp,scan(row2,a),',');

				/* then the rest */
				l = i + 1;
				do while(scan(row2,l) ne '');
					rowtmp = cats(rowtmp,scan(row2,l),',');

					l + 1;
				end;
			end;

			%validate(in=rowtmp);
			row2 = rowtmp;
			rowtmp = '';
			s + 1;

		end;

		/* if row is valid pick middle number */
		if valid then do;
			middoc = input(scan(row2,i/2),8.);
			midsum = sum(midsum,middoc);
		end;

		output;
	end;
 end;

run;

/* 1953 - to low */
