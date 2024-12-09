data indata;
 length row $20000 i a q t lid lidpos done mpos id 8 val part $1;

 infile _infile delimiter='';
 array ids(20000) $20;

 input row;
 i = 1;
 id = 0;

 /* read files and free space */
 do until (substr(row,i,1) = '');
 	q = input(substr(row,i,1),best.);

	if (i/2) ne int(i/2) then val = input((id),best.); /* odd numbers of i */
	else do;
		val = '.';
		id + 1;
	end;

 	do a = 1 to q;
		ids(i) = cats(ids(i),val);
	end;

	i + 1;
 end;

 /* move digits from end to free space */
 lid = i - 1; /* last id */
 lidpos = length(ids(lid)); /* posistion to read within last id */

 done = 0;
 do until(done);
 	do w = 1 to i;
		put ids(w) @;
	end;
	put ' ';

 	do a = 1 to i;
		mpos = findc(ids(a),'.');
		*put mpos=;
		if mpos then do;
			substr(ids(a),mpos,1) = substr(ids(lid),lidpos,1);
			substr(ids(lid),lidpos,1) = '';
			lidpos = lidpos - 1;
			if lidpos = 0 then do;
				if findc(ids(lid-1),'.') then ids(lid-1) = '';

				lid = lid - 2;
				lidpos = length(ids(lid));
			end;
			leave;
		end;
	end;
	if mpos = 0 then done = 1;
 end;

 /* calc checksum */
 id = 0;
 sum = 0;

 do a = 1 to i;
	do q = 1 to length(ids(a));
		t = input(substr(ids(a),q,1),best.);
		if t = . then leave;
		sum = sum + id*t;
		put id= q= a= t= sum=;
		id + 1;
	end;
 end;

 put sum=;


run;