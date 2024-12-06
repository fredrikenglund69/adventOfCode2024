/* if grid already visited, check if direction on that is +90 if so inc blocks and continue */
/* also check whole direction from visited +90 until same dir found */
/* a grid can only be visited max 2 times */
/* U-R : 1 */
/* R-D : 2 */
/* D-L : 3 */
/* L-U : 4 */

%let gridsize = 10;

data indata(drop=grid: visited:);
 length row $200 currposx currposy nosteps exit i noblocks 8 dir $1;
 infile _infile delimiter='' end=_last;

 array grid{&gridsize.,&gridsize.} $1;
 array visited{&gridsize.,&gridsize.} $1;
 retain grid visited;

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
	noblocks = 0;
	dir = 'U';
	exit = 0;
	output; /* startpos */

	do until(exit);
		if visited(currposx,currposy) = '' then visited(currposx,currposy) = dir; 
		select(dir);
			when ('U') do;
				if currposy > 1 then do;
					if grid(currposx,currposy - 1) = '#' then do;
						dir = 'R';
						visited(currposx,currposy) = '1'; 
					end;
					else do;
						*if visited(currposx,currposy - 1) = 'R' then noblocks + 1; 

						do q = currposx to &gridsize.;
							if visited(q,currposy - 1) ne '' then do;
								if visited(q,currposy - 1) in('R','4') then do;
									noblocks + 1;
									leave;
								end;
							end;
						end;

						currposy = currposy - 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('D') do;
				if currposy < &gridsize. then do;
					if grid(currposx,currposy + 1) = '#' then do;
						dir = 'L';
						visited(currposx,currposy) = '3';
					end;
					else do;
						*if visited(currposx,currposy + 1) = 'L' then noblocks + 1; 

						do q = currposx to 1 by -1;
							if visited(q,currposy + 1) ne '' then do;
								if visited(q,currposy + 1) in('L','2') then do;
									noblocks + 1;
									leave;
								end;
							end;
						end;

						currposy + 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('R') do;
				if currposx < &gridsize. then do;
					if grid(currposx + 1,currposy) = '#' then do;
						dir = 'D';
						visited(currposx,currposy) = '2';
					end;
					else do;
						*if visited(currposx + 1,currposy) = 'D' then noblocks + 1; 

						do q = currposy to &gridsize.;
							if visited(currposx + 1, q) ne '' then do;
								if visited(currposx + 1, q) in ('D','1') then do;
									noblocks + 1;
									leave;
								end;
							end;
						end;

						currposx + 1;
						nosteps + 1;
						output; /* store coordinates */
					end;
				end;
				else exit = 1;
			end;

			when ('L') do;
				if currposx > 1 then do;
					if grid(currposx - 1,currposy) = '#' then do;
						dir = 'U';
						visited(currposx,currposy) = '4';
					end;
					else do;
						*if visited(currposx - 1,currposy) = 'U' then noblocks + 1; 

						do q = currposy to 1 by -1;
							if visited(currposx - 1, q) ne '' then do;
								if visited(currposx - 1, q) in('U','3') then do;
									noblocks + 1;
									leave;
								end;
							end;
						end;

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

 /* print grid */
 do y = 1 to &gridsize.;
 	do x = 1 to &gridsize.;
	  put visited{x,y} @;
	end;
	put ' ';
 end;

run;



/*
	 do y = 1 to &gridsize.;
	 	do x = 1 to &gridsize.;
		  put grid{x,y} @;
		end;
		put ' ';
	 end;


671 - to low
10000 - to high
1000 - to low
1009 - wrong
1008 - wrong
1007 - wrong
1006 - wrong
*/