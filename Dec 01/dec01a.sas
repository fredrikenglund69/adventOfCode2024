/* Read data, split in two datasets */
data ds_cola(keep=cola) ds_colb(keep=colb);
 infile _infile delimiter=' ';
 length cola colb 8; 

 input cola colb;
run;

/* sort in ascending order */
proc sort data=ds_cola;
    by cola;
run;
proc sort data=ds_colb;
    by colb;
run;

/* Add key used in join */
data ds_cola;
     set ds_cola;
     length key 8;
     key = _n_;
run;

data ds_colb;
     set ds_colb;
     length key 8;
     key = _n_;
run;

/* append columns in one dataset */
proc sql;
    create table kol as
    select cola, colb
    from ds_cola a
    inner join
    ds_colb b
    on a.key=b.key
    ;
quit;

data diff;
     set kol;
     length diff 8;
     diff = abs(cola - colb);
run;

proc summary data=diff nway missing;
    var diff;
    output out=tot sum=;
quit;

