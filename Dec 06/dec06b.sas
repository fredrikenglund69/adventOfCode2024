/* if grid already visited, check if direction on that is +90 if so inc blocks and continue */
/* also check whole direction from visited +90 until same dir found */
/* a grid can only be visited max 2 times */
/* U-R : 1 */
/* R-D : 2 */
/* D-L : 3 */
/* L-U : 4 */

%let gridsize = 130;

data indata(drop=grid: visited:);
 length row $200 currposx currposy nosteps exit i noblocks startposx startposy x1 y1 8 dir $1;
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
	startposx = currposx;
	startposy = currposy;

	do y1 = 1 to &gridsize.;
		do x1 = 1 to &gridsize.;
		output;
			dir = 'U';
			exit = 0;
			currposx = startposx;
			currposy = startposy;
			nosteps = 0;

			/* empty grid */
			 do y = 1 to &gridsize.;
			 	do x = 1 to &gridsize.;
				  visited{x,y} = '';
				end;
			 end;


			if grid(x1,y1) = '.' then do;
				grid(x1,y1) = '#';

				do until(exit or nosteps >20000);
					if visited(currposx,currposy) = '' then visited(currposx,currposy) = dir; 
					select(dir);
						when ('U') do;
							if currposy > 1 then do;
								if grid(currposx,currposy - 1) = '#' then do;
									dir = 'R';
									visited(currposx,currposy) = 'R'; 
								end;
								else do;
									if visited(currposx,currposy - 1) = dir then do;
										noblocks + 1; 
										exit = 2;
									end;
									else do;
										currposy = currposy - 1;
										nosteps + 1;
									end;
								end;
							end;
							else exit = 1;
						end;

						when ('D') do;
							if currposy < &gridsize. then do;
								if grid(currposx,currposy + 1) = '#' then do;
									dir = 'L';
									visited(currposx,currposy) = 'L';
								end;
								else do;
									if visited(currposx,currposy + 1) = dir then do;
										noblocks + 1; 
										exit = 3;
									end;
									else do;
										currposy + 1;
										nosteps + 1;
									end;
								end;
							end;
							else exit = 1;
						end;

						when ('R') do;
							if currposx < &gridsize. then do;
								if grid(currposx + 1,currposy) = '#' then do;
									dir = 'D';
									visited(currposx,currposy) = 'D';
								end;
								else do;
									if visited(currposx + 1,currposy) = dir then do;
										noblocks + 1; 
										exit = 4;
									end;
									else do;
										currposx + 1;
										nosteps + 1;
									end;
								end;
							end;
							else exit = 1;
						end;

						when ('L') do;
							if currposx > 1 then do;
								if grid(currposx - 1,currposy) = '#' then do;
									dir = 'U';
									visited(currposx,currposy) = 'U';
								end;
								else do;
									if visited(currposx - 1,currposy) = dir then do;
										noblocks + 1; 
										exit = 5;
									end;
									else do;
										currposx = currposx - 1;
										nosteps + 1;
									end;
								end;
							end;
							else exit = 1;
						end;

						otherwise;

					end;
					*put currposx= currposy= dir= exit= noblocks=;
				end;

				grid(x1,y1) = '.';

			end;
		end;
	end;
 end;
put noblocks=;

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
1710 - wrong
1711 - correct
*/