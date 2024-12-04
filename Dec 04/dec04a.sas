%let gridsize = 140;

data indata;
 length row $200 i cnt x y 8 word $4 part $1;
 array grid{&gridsize.,&gridsize.} $1 ;
 infile '/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec04.txt' delimiter='';
 retain grid;

 input row;

 /* read grid into array */
 do i = 1 to &gridsize.;
	grid{i,_n_} = substr(row,i,1);
 end;


 /* last row read now - go! */
 if _n_ = &gridsize. then do;

	 /* print grid */
	 do y = 1 to &gridsize.;
	 	do x = 1 to &gridsize.;
		  put grid{x,y} @;
		end;
		put ' ';
	 end;

	cnt = 0;
	word = '';

 	do y = 1 to &gridsize.;
	  do x = 1 to &gridsize.;

	  	/* search right */
	  	if (x < (&gridsize. - 2)) then do;
			word = '';
			do i = 0 to 3;
				word = cats(word,grid(x+i,y));
				if word = 'XMAS' or reverse(word) = 'XMAS' then cnt + 1;
			end;
		end;

	  	/* search right-down */
	  	if ((x < (&gridsize. - 2)) and (y < (&gridsize. - 2))) then do;
			word = '';
			do i = 0 to 3;
				word = cats(word,grid(x+i,y+i));
				if word = 'XMAS' or reverse(word) = 'XMAS' then cnt + 1;
			end;
		end;

		/* search down */
	  	if (y < (&gridsize. - 2)) then do;
			word = '';
			do i = 0 to 3;
				word = cats(word,grid(x,y+i));
				if word = 'XMAS' or reverse(word) = 'XMAS' then cnt + 1;
			end;
		end;

	  	/* search down-left */
	  	if ((x > 3) and (y < (&gridsize. - 2))) then do;
			word = '';
			do i = 0 to 3;
				word = cats(word,grid(x-i,y+i));
				if word = 'XMAS' or reverse(word) = 'XMAS' then cnt + 1;
			end;
		end;

	  end;
	end;
	put cnt=;
 end;

run;