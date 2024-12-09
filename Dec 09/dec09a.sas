data indata;
 length row $20000 i a q t lid lidpos done mpos id 8 val $1 idtmp lidtmp part $200;

 infile _infile delimiter='';
 array ids(20000) $200;

 input row;
 i = 1;
 id = 0;

 /* read files and free space */
 do until (substr(row,i,1) = '');
 	q = input(substr(row,i,1),best.);

	if (i/2) ne int(i/2) then val = put(id,$1.); /* odd numbers of i */
	else do;
		val = '.';
		id + 1;
	end;

 	do a = 1 to q;
		ids(i) = cats(ids(i),val);
		if a ne q then ids(i) = cats(ids(i),',');
	end;

	i + 1;
 end;

 /* move digits from end to free space */
 lid = i - 1; /* last id */
 r = 1;
 do until(scan(ids(lid),r) = '');
 	r + 1;
 end;
 lidpos = r - 1; /* posistion to read within last id */

 done = 0;
 do until(done);
/* 	do w = 1 to i;*/
/*		put ids(w) @;*/
/*	end;*/
/*	put ' ';*/

 	do a = 1 to i;
		r = 1;
		mpos = 0;
		do while(scan(ids(a),r,',') not in (''));
			if scan(ids(a),r,',') = '.' and mpos = 0 then mpos = r ;
			r + 1;
		end;

		if mpos then do;
			idtmp = ids(a);
			lidtmp = ids(lid);

			ids(a) = '';
			ids(lid) = '';
			do w = 1 to mpos;
				if w ne mpos then ids(a) = cats(ids(a), scan(idtmp,w,','));
				else ids(a) = cats(ids(a),scan(lidtmp,lidpos,','));
				if w ne mpos then ids(a) = cats(ids(a),',');
			end;
			*put ids(a)=;
			do w = mpos+1 to r;
				if W ne r then ids(a) = cats(ids(a),',',scan(idtmp,w,','));
				else ids(a) = cats(ids(a),scan(idtmp,w,','));
			*put ids(a)=;
			end;

			do w = 1 to lidpos-1;
				if w ne lidpos then ids(lid) = cats(ids(lid), scan(lidtmp,w,','),',');
				else ids(lid) = cats(ids(lid), scan(lidtmp,w,','));
			end;
			lidpos = lidpos - 1;
			if lidpos = 0 then do;
				if findc(ids(lid-1),'.') then ids(lid-1) = '';
				lid = lid - 2;
				 r = 1;
				 do until(scan(ids(lid),r) = '');
				 	r + 1;
				 end;
				 lidpos = r - 1; /* posistion to read within last id */
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
 	q = 1;
	do while(scan(ids(a),q,',') ne '');
		t = input(scan(ids(a),q,','),best.);
		if t = . then leave;
		sum = sum + id*t;
		*put id= q= a= t= sum=;
		id + 1;
		q + 1;
	end;
 end;

 put sum=;


run;