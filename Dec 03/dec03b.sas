/* Read data, append to one line */
data indata;
 infile '/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec03.txt' delimiter='q' end=_last;
 length tmp $4000 row $30000; 
 retain row;

 input tmp ;
 row = cats(row,tmp);
 if _last then output;
run;

/* trim data, remove all between do and dont */
data trim;
     set indata;
     length rid_do rid_dont rid_act pos len start stop doread prev_pos 8 trim $4000;

     retain doread prev_pos;
     /* we start with read enabled */
     if _n_ = 1 then do;
        doread = 1;
     end;

     prev_pos = 1; /* for each row we start at the beginning */

     /* regex fro the 3 different search mul, do and dont */
     rid_do = prxparse("/do\(\)/");
     rid_dont = prxparse("/don\'t\(\)/");
     rid_act = rid_dont;

     start = 1;
     stop = length(row);

     call prxnext(rid_act, start, stop, row, pos, len);
      do while (pos > 0);
         if doread = 1 then do;
            doread = 0;
            rid_act = rid_do; /* change what we search for to do */
            trim=substr(row,prev_pos,(pos - prev_pos));
            output;
         end;
         else do;
            doread = 1;
            rid_act = rid_dont; /* change search to dont */
            prev_pos = pos;
         end;
         
         call prxnext(rid_act, start, stop, row, pos, len);

         /* last instruction, since do while exits before substr */
         if pos = 0 and doread = 1 then do;
            trim=substr(row,prev_pos,(pos - prev_pos));
            output;
         end;
      end; 
run;

/* find mul(x,y) */
data muls;
     set trim;
     length rid pos len start stop a b prod 8 instr $12;
     rid = prxparse("/mul\(\d{1,3},\d{1,3}\)/");

     start = 1;
     stop = length(trim);

     call prxnext(rid, start, stop, trim, pos, len);
      do while (pos > 0);
         instr = substr(trim, pos, len);
         put instr= pos= len=;
         a = scan(instr,2);
         b = scan(instr,3);
         prod = a * b;
         output;

         call prxnext(rid, start, stop, trim, pos, len);
      end; 

run;

proc summary data=muls nway missing;
    var prod;
    output out= tot sum=;
run;

proc print data=tot;
run;

/*
100314593 to high
99532691 correct
*/