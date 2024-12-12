data test(drop=stones:);
	length row $100 nos nosn num1 num2 8;
/*	row = '125 17';*/
	row = '112 1110 163902 0 7656027 83039 9 74';
	array stones(2000000) $20;

	/* fill array */
	i = 1;
	do until(scan(row,i) = '');
		stones(i) = scan(row,i);
		i + 1;
	end;

	nos  = i - 1;

	do blink = 1 to 75;
		nosn = 0;
		do w = 1 to nos;
			l = length(stones(w+nosn));

			if stones(w+nosn) = '0' then stones(w+nosn) = '1';

			else if l/2 = int(l/2) then do;
				num1 = input(substr(stones(w+nosn),1,l/2),20.);
				num2 = input(substr(stones(w+nosn),l/2+1),20.);
				stones(w+nosn) = strip(put(num1,best.));
				do y = nos+nosn to w+1+nosn by -1;
					stones(y+1) = stones(y);
				end;
				nosn + 1;
				stones(w+nosn) = strip(put(num2,best.));
			end;

			else do;
				num1 = input(stones(w+nosn),best.);
				stones(w+nosn) = strip(put((num1 * 2024),20.));
			end;

/*			put w= nos= nosn= l= num1= num2= stones(w)= stones(w+1)=;*/

		end;
		nos = nos+nosn;

/*		put ;*/
/*		put blink= nos= nosn=;*/
/*		do q = 1 to 30;*/
/*			put stones(q) @;*/
/*		end;*/
/*		put ;*/

	end;

	put nos=;

run;

/*
183154 - to low
176471 - to low
183620 - correct
*/