/* Read data */
data indata;
 infile _infile delimiter=',';
 length row $200; 

 input row;
run;

/* create combinations for each row, skipping one value at a time */
data first;
     set indata;
     length new_row $200 i 8;

     new_row = '';
     i = 1;
     
     do skip = 1 to 10; /* max values on each row */
        do until (scan(row,i) = '');
            if i ne skip then new_row = catx(' ',new_row,scan(row,i));
            i + 1;
        end;
        if new_row ne row then output; /* just when not the same, due to skip-loop exceeding number of values in one row */
        new_row = '';
        i = 1;
    end;
run;
     

/* examine each row, until last value */
data second;
     set first;
     length value prev_value diff 8 dir curr_dir $3;
     i = 2;
     report_ok = 1; /* until found unvalid */
     prev_value = input(scan(new_row,1),8.); /* read first value */
     value = input(scan(new_row,2),8.); /* read second value to determine inc or dec */
     
     if value > prev_value then dir = 'inc';
     else dir = 'dec';

     do until (scan(new_row,i) = '');
        value = input(scan(new_row,i),8.);
        diff = abs(value - prev_value);

        /* determine direction */
        if value > prev_value then curr_dir = 'inc';
        else curr_dir = 'dec';

        if (diff > 3 or diff = 0 or curr_dir ne dir) then do;
            report_ok = 0;
            leave; /* exit and go to next row if unvalid report */
        end;
        else do;
            prev_value = value;
            i + 1;
        end;

     end;

     /* get max of report_ok for each row meaning ig there is at least one report_ok = 1 for the combinations on a row it will be ok */
     proc summary data = second nway missing;
        class row;
        var report_ok;
        output out=firstsum max=report_ok;
     run;

     /* summarize to get all valid reports */
     proc summary data=firstsum nway missing;
        var report_ok;
        output out=tot sum=;
     run;