data ds_kola(keep=kola) ds_kolb(keep=kolb);
 infile '/opt/sas/lagring/Lev4/it/adventofcode2024/kfen01/in_dec01.txt' delimiter=' ';
 length kola kolb 8; 

 input kola kolb;
 output;
run;

proc sort data=ds_kola;
    by kola;
run;
proc sort data=ds_kolb;
    by kolb;
run;

proc sql;
    create table kol as
    select kola, kolb
    from ds_kola
    inner join
    ds_kolb
    on 1=1
    ;
quit;

data diff;
     set kol;
     length diff 8;
     diff = abs(kola - kolb);
run;

proc summary data=diff nway missing;
    var diff;
    output out=tot sum=;
quit;