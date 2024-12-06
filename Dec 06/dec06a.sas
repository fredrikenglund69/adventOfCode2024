%let gridsize = 140;

data indata;
 length row $200 currposx currposy nosteps exit i 8 dir $1;
 infile _infile delimiter='' end=_last;

 array grid{&gridsize.,&gridsize.} $1;
 retain grid;

 input row;

 /* read grid into array */
 do i = 1 to &gridsize.;
	grid{i,_n_} = substr(row,i,1);
	if substr(row,i,1) = '^' then do;
		currposx = i;
		currposy = _n_;
	end;
 end;

 if _last then do;
 	nosteps = 1; /* start counts */
	dir = 'U';
	exit = 0;
	output; /* startpos */

	do until(exit);
		select(dir);
			when ('U') do;
				if currposy > 1 then do;
					if grid(currposx,currposy - 1) = '#' then dir = 'R';
					else do;
						currposy = currposy - 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('D') do;
				if currposy < &gridsize. then do;
					if grid(currposx,currposy + 1) = '#' then dir = 'L';
					else do;
						currposy + 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('R') do;
				if currposx < &gridsize. then do;
					if grid(currposx + 1,currposy) = '#' then dir = 'D';
					else do;
						currposx + 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('L') do;
				if currposx > 1 then do;
					if grid(currposx - 1,currposy) = '#' then dir = 'U';
					else do;
						currposx = currposx - 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			otherwise;

		end;
	end;
	
 end;

run;

/* sort distinct coordinates */
proc sort data=indata out= sorted nodupkey;
 by currposx currposy;
run;
