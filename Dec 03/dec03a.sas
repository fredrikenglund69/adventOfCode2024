/* Read data, check length to be sure to get all */
data indata;
 infile '/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec03_test.txt' delimiter='q';
 length ll 8 row $30000; 

 input row;
 ll = length(row);
run;

/* find mul(x,y) */
data muls;
     set indata;
     length rid pos len start stop a b prod 8 instr $10;
     rid = prxparse("/mul\(\d{1,3},\d{1,3}\)/");

     start = 1;
     stop = length(row);

     call prxnext(rid, start, stop, row, pos, len);
      do while (pos > 0);
         instr = substr(row, pos, len);
         put instr= pos= len=;
         a = scan(instr,2);
         b = scan(instr,3);
         prod = a * b;
         output;

         call prxnext(rid, start, stop, row, pos, len);
      end; 

run;

proc summary data=muls nway missing;
    var prod;
    output out= tot sum=;
run;

proc print data=tot;
run;
