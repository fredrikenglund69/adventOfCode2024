data test(drop=stones: stonesnew:);
	length row $200 nos nosn num1 num2 8;
/*	row = '125 17';*/
	row = '112 1110 163902 0 7656027 83039 9 74';
	array stones(200000) $200;
	array stonesnew(200000) $200;

	/* fill array */
	i = 1;
	do until(scan(row,i) = '');
		stones(i) = scan(row,i);
		i + 1;
	end;

	nos  = i - 1;
	nosn = 1;

	do blink = 1 to 25;
		do w = 1 to nos;
			l = length(stones(w));

			if stones(w) = '0' then stonesnew(nosn) = '1';

			else if l/2 = int(l/2) then do;
				num1 = input(substr(stones(w),1,l/2),20.);
				num2 = input(substr(stones(w),l/2+1),20.);
				stonesnew(nosn) = strip(put(num1,best.));
				nosn + 1;
				stonesnew(nosn) = strip(put(num2,best.));
				*put nosn= l= num1= num2= stones(w)=;
			end;

			else do;
				num1 = input(stones(w),best.);
				stonesnew(nosn) = strip(put((num1 * 2024),20.));
			end;

			nosn + 1;
		end;
		nosn = nosn - 1;

/*		put ;*/
/*		put nosn=;*/
/*		do q = 1 to nosn;*/
/*			put stonesnew(q) @;*/
/*		end;*/

		/* copy new to org */
		do r = 1 to nosn;
			stones(r) = stonesnew(r);
			stonesnew(r) = '';
		end;
		nos = nosn;
		nosn = 1;
	end;

	put nos=;

run;

/*
183154 - to low
176471 - to low
183620 - correct
*/