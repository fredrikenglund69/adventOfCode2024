/* Read data, split in two datasets */
data ds_cola(keep=cola) ds_colb(keep=colb);
 infile _infile delimiter=' ';
 length cola colb 8; 

 input cola colb;
run;

/* join ds together, group by cola and count number of occurrancies */
proc sql;
    create table kol as
    select cola, count(colb) as noo
    from ds_cola a
    inner join
    ds_colb b
    on a.cola=b.colb
    group by cola
    ;
quit;

/* calc product */
data diff;
     set kol;
     length sims 8;
     sims = cola * noo;
run;

/* sum sims */
proc summary data=diff nway missing;
    var sims;
    output out=tot sum=;
quit;

