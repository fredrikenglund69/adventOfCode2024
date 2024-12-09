/* find out size of grid */
data _null_;;
 length row $200 a 8.;
 infile _infile delimiter='';

 input row;
 if _n_ = 1 then do;
 	a = length(row);
	put a=;
	call symput('gridsize',put(a,best.));
 end;
run;

%macro printgrid(grid=grid);
	 /* print grid */
	 do y = 1 to &gridsize.;
	 	do x = 1 to &gridsize.;
		  put &grid{x,y} @;
		end;
		put ' ';
	 end;
	 put ' ';
%mend;

%macro evaluate;
if grid(currx,curry) = grid(searchx,searchy) then do;
	distx = searchx - currx;
	disty = searchy - curry;
	adotx = currx + 2*distx;
	adoty = curry + 2*disty;
	if  1 <= adotx <= &gridsize. and  1 <= adoty <= &gridsize. then adot(adotx,adoty) = '#'; 
*	put currx= curry= searchx= searchy= sqsize= distx= disty= adotx= adoty=;
end;
%mend;

data indata;
 length row $200 i x y currx curry searchx searchy distx disty adotx adoty sqsize 8 part $1;
 array grid{&gridsize.,&gridsize.} $1  ;
 array adot{&gridsize.,&gridsize.} $1  ;

 infile _infile delimiter='';
 retain grid adot;

 input row;

 /* read grid into array */
 do i = 1 to &gridsize.;
	grid{i,_n_} = substr(row,i,1);
	adot{i,_n_} = substr(row,i,1);
 end;


 /* last row read now - go! */
 if _n_ = &gridsize. then do;
 	%printgrid;

	/* loop grid */
	do curry = 1 to &gridsize.;
		do currx = 1 to &gridsize.;
			/* search by using square, */
			part = grid(currx,curry);

			if part ne '.' then do;
				do sqsize = 1 to &gridsize.;

					/* above */
					if (curry - sqsize) > 1 then do;
						searchy = curry - sqsize;
						do searchx = max(1,currx - sqsize) to min(&gridsize.,currx + sqsize);
							%evaluate;
						end;
					end;

					/* right */
					if (currx + sqsize) < &gridsize. then do;
						searchx = currx + sqsize;
						do searchy = max(1,curry - sqsize) to min(&gridsize.,curry + sqsize);
							%evaluate;
						end;
					end;

					/* below */
					if (curry + sqsize) < &gridsize. then do;
						searchy = curry + sqsize;
						do searchx = max(1,currx - sqsize) to min(&gridsize.,currx + sqsize);
							%evaluate;
						end;
					end;

					/* left */
					if (currx - sqsize) >  1  then do;
						searchx = currx - sqsize;
						do searchy = max(1,curry - sqsize) to min(&gridsize.,curry + sqsize);
							%evaluate;
						end;
					end;
				end;
			end;		
		end;
	end;

	%printgrid(grid=adot);

	cnt=0;
	do y = 1 to &gridsize.;
		do x = 1 to &gridsize.;
		if adot(x,y) = '#' then cnt + 1;;
		end;
	end;

	put cnt=;


 end;

run;