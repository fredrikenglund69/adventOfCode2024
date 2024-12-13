data test(drop=stones:);
	length row $100 nos nosn nostot 8 stonestmp $20;
/*	row = '125 17';*/
	row = '112 1110 163902 0 7656027 83039 9 74';
	array stones{2000000} 8;

	/* fill array */
/*	i = 1;*/
/*	put 'Initial:';*/
/*	do until(scan(row,i) = '');*/
/*		stones(i) = input(scan(row,i),8.);*/
/*		put stones(i) @;*/
/*		i + 1;*/
/*	end;*/

	nostot = 0;

	do k = 1 to 8;
		stones(1) = input(scan(row,k),20.);
		nos = 1;

		do blink = 1 to 25;
			nosn = nos;
			do w = 1 to nos;
				stonestmp = strip(put(stones(w),20.));

				l = length(stonestmp);

				if stones(w) = 0 then stones(w) = 1;

				else if l/2 = int(l/2) then do;
					nosn + 1;
					stones(w) = input(substr(stonestmp,1,l/2),20.);
					stones(nosn) = input(substr(stonestmp,l/2+1),20.);
				end;

				else do;
					stones(w) = stones(w) * 2024;
				end;

	/*			put w= nos= nosn= l= num1= num2= stones(w)= stones(w+1)=;*/

			end;
			nos = nosn;

	/*		put ;*/
	/*		put blink= nos= nosn=;*/
	/*		do q = 1 to 30;*/
	/*			put stones(q) @;*/
	/*		end;*/
	/*		put ;*/

		end;
		put nos=;
		nostot = nostot + nos;
	end;

	put nostot=;

run;

/*
183154 - to low
176471 - to low
183620 - correct
*/