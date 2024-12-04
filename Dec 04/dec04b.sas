%let gridsize = 140;

data indata;
 length row $200 i cnt x y 8 word1 word2 $3;
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

 	do y = 1 to &gridsize.;
	  do x = 1 to &gridsize.;

	  	if grid(x,y) = 'A' and (1 < x < &gridsize.) and (1 < y < &gridsize.) then do;

		  	/* word / */
			word1 = cats(grid(x+1,y-1),'A',grid(x-1,y+1));

		  	/* word \ */
			word2 = cats(grid(x-1,y-1),'A',grid(x+1,y+1));

			if (word1 = 'MAS' or reverse(word1) = 'MAS') and (word2 = 'MAS' or reverse(word2) = 'MAS')  then cnt + 1;
		end;

	  end;
	end;
	put cnt=;
 end;

run;