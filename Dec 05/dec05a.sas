data indata;
 length row $200 i k a currdoc valid middoc midsum 8;
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
 	i = 2; /* skip check on first doc */
	valid = 1; /* treat row as valid at start */
	do while(scan(row,i) ne '');
		currdoc = input(scan(row,i),8.);
		/* check if doc order is valid */
		k = 1;
		do while(scan(rules{currdoc},k) ne '');
			do a = 1 to i - 1;
				/* if we can find rule before current doc it is not valid */
				if scan(row,a) = scan(rules{currdoc},k) then valid = 0;
			end;
			k + 1;
		end;

		put currdoc= valid=;
		i + 1;
	end;

	/* if row is valid pick middle number */
	if valid then do;
		middoc = input(scan(row,i/2),8.);
		midsum = sum(midsum,middoc);
	end;

	output;
 end;

run;
