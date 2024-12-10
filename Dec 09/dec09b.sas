data indata(drop=ids:);
 length row $20000 i a q t lid lidpos done nodig nodot dotpos id 8 val $300 idtmp lidtmp $300;

 infile _infile delimiter='';
 array ids(20000) $300;

 input row;
 i = 1;
 id = 0;

 /* read files and free space */
 do until (substr(row,i,1) = '');
 	q = input(substr(row,i,1),best.);

	if (i/2) ne int(i/2) then val = put(id,best.); /* odd numbers of i */
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
	hit = 0;
 	do a = 2 to lid-1 by 2;
		r = 1;
		nodot = 0;
		dotpos = 0;
		do while(scan(ids(a),r,',') not in (''));
			if scan(ids(a),r,',') = '.' then do;
				nodot + 1;
				if dotpos = 0 then dotpos=r;
			end;
			r + 1;
		end;

		r = 1;
		nodig = 0;
		do while(scan(ids(lid),r,',') not in (''));
			if scan(ids(lid),r,',') ne '.' then nodig + 1;
			r + 1;
		end;

		*put idtmp= lidtmp= a= lid= nodot= nodig= dotpos=;

		if nodot >= nodig then do;
			hit = 1;
			idtmp = ids(a);
			lidtmp = ids(lid);

			ids(a) = '';
			ids(lid) = '';
			do w = 1 to dotpos-1;
				ids(a) = cats(ids(a),scan(idtmp,w,','),',');
				*if w ne dotpos-1 then ids(a) = cats(ids(a),',');
			end;
			do w = 1 to nodig;
/*				if w ne nodig then ids(a) = cats(ids(a), scan(lidtmp,w,','));*/
/*				else ids(a) = cats(ids(a),scan(lidtmp,w,','));*/
				ids(a) = cats(ids(a), scan(lidtmp,w,','));
				if w ne nodig then ids(a) = cats(ids(a),',');
			*put ids(a)=;
			end;
			do w = nodig+dotpos to nodot+dotpos;
				ids(a) = cats(ids(a),',',scan(idtmp,w,','));
/*				if W ne nodot then ids(a) = cats(ids(a),',',scan(idtmp,w,','));*/
/*				else ids(a) = cats(ids(a),scan(idtmp,w,','));*/
			*put ids(a)=;
			end;

/*			do w = 1 to lidpos-1;*/
/*				if w ne lidpos then ids(lid) = cats(ids(lid), scan(lidtmp,w,','),',');*/
/*				else ids(lid) = cats(ids(lid), scan(lidtmp,w,','));*/
/*			end;*/
			do e = 1 to nodig;
				ids(lid) = cats(ids(lid), '.');
				if e ne nodig then ids(lid) = cats(ids(lid),',');
			end;
			lid = lid - 2;
			leave;
		end;
		*else lid = lid - 2;
	end;
	if hit = 0 then lid = lid - 2;
	if lid <= 0 then done = 1;
 end;

 /* calc checksum */
 id = 0;
 sum = 0;

 do a = 1 to i;
 	q = 1;
	do while(scan(ids(a),q,',') ne '');
		t = input(scan(ids(a),q,','),best.);
		*if t = . then leave;
		if t ne . then sum = sum + id*t;
		*put id= q= a= t= sum=;
		id + 1;
		q + 1;
	end;
 end;

 put sum=;


run;

data test;
 set indata;
 put sum 20.;
run;

/*
6437095347850 - to high
6436819084274 - correct
*/