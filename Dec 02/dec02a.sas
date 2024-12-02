/* Read data */
data indata;
 infile '/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec02.txt' delimiter=',';
 length row $200; 

 input row;
run;

/* examine each row, until last value */
data first;
     set indata;
     length value prev_value diff 8 dir curr_dir $3;
     i = 2;
     report_ok = 1; /* until found unvalid */
     prev_value = input(scan(row,1),8.); /* read first value */
     value = input(scan(row,2),8.); /* read second value to determine inc or dec */
     
     if value > prev_value then dir = 'inc';
     else dir = 'dec';

     do until (scan(row,i) = '');
        value = input(scan(row,i),8.);
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

     proc summary data=first nway missing;
        var report_ok;
        output out=tot sum=;
     run;