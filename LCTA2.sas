
/*import data*/
/*mixed model analysis between different groups*/
PROC IMPORT OUT= WORK.LCT 
            DATAFILE= "C:\glucagon_robert\glucagon5_export_Fons.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
data lct;
set lct;
log_gluk0 = log(gluk0);
log_gluk2 = log(gluk2);
log_gluk3 = log(gluk3);
log_gluk4 = log(gluk4);
log_gluk5 = log(gluk5);
dgluk2 = gluk2 - gluk0 + 130;
dgluk3 = gluk3 - gluk0 + 130;
dgluk4 = gluk4 - gluk0 + 130;
dgluk5 = gluk5 - gluk0 + 130;
glukr = gluk5/gluk0;
run;
proc univariate data=lct normal;
var dgluk2-dgluk5 glukr;
histogram dgluk2-dgluk5 glukr;
run;
data lct;
set lct;
z=0;
run;
proc transreg data=lct maxiter=0 nozeroconstant;
model boxcox(dgluk2 dgluk3 dgluk4 dgluk5 / parameter=1)=identity (z);
run;
data lct;
set lct;
log_dgluk2 = (dgluk2**1.75 + 1)/1750;
log_dgluk3 = (dgluk3**1.75 + 1)/1750;
log_dgluk4 = (dgluk4**1.75 + 1)/1750;
log_dgluk5 = (dgluk5**1.75 + 1)/1750;
run;
proc univariate data=lct normal;
var log_dgluk2-log_dgluk5;
histogram log_dgluk2-log_dgluk5;
run;
data lct_long;
set lct_long;
log_gluk = log(gluk1);
log_ins = (ins1**0.25 + 1)/0.25;
log_bz = (bz1**-.5 +1)/-0.5;
log_bmi = (bmi**-0.75 + 1) / -0.75;
log_matsuda = log(matsuda_isi);
run;



proc traj data=work.lct out=out outstat=os
outplot=op;
var INS0 INS2-INS5;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id NR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var INS0 INS2-INS5;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id NR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var INS0 INS2-INS5;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id NR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”,,time);





proc traj data=work.lct out=out outstat=os
outplot=op;
var bz0 bz2-bz5;
indep time0 time2-time5;
rorder 1;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id NR;
run;
%trajplot (OP, OS, blood glucose,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var bz0 bz2-bz5;
indep time0 time2-time5;
rorder 1;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id NR;
run;
%trajplot (OP, OS, blood glucose,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var bz0 bz2-bz5;
indep time0 time2-time5;
rorder 1;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id NR;
run;
%trajplot (OP, OS, blood glucose,
,,time);




proc traj data=work.lct out=out outstat=os
outplot=op;
var log_gluk0 log_gluk2-log_gluk5;
rorder 1;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 1;
order 2 ;
id NR;
run;
%trajplot (OP, OS, glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_gluk0 log_gluk2-log_gluk5;
rorder 1;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id NR;
run;
%trajplot (OP, OS, glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_gluk0 log_gluk2-log_gluk5;
rorder 1;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id NR;
run;
%trajplot (OP, OS, glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_gluk0 log_gluk2-log_gluk5;
rorder 1;
indep time0 time2-time5;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id NR;
run;
%trajplot (OP, OS, glucagon,
,,time);
/*delta glucagon*/
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_dgluk2-log_dgluk5;
rorder 0;
indep time2-time5;
model cnorm;
max 10000;
ngroups 1;
order 2;
id NR;
run;
%trajplot (OP, OS, delta glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_dgluk2-log_dgluk5;
rorder 0;
indep time2-time5;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id NR;
run;
%trajplot (OP, OS, delta glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_dgluk2-log_dgluk5;
rorder 0;
indep time2-time5;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id NR;
run;
%trajplot (OP, OS, delta glucagon,
,,time);
proc traj data=work.lct out=out outstat=os
outplot=op;
var log_dgluk2-log_dgluk5;
rorder 0;
indep time2-time5;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id NR;
run;
%trajplot (OP, OS, delta glucagon,
,,time);

/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2;
multgroups 2;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);

/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);

/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
var gluk0 gluk2-gluk5;
rorder 1;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2 2 2;
multgroups 4;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);



/*multiple trajectory model*/
/*2 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, blood glucose,
,,time);
/*3 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, blood glucose,
,,time);
/*4 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2 2 2;
multgroups 4;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, blood glucose,
,,time);
/*5 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2 2 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2 2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2 2 2 2;
multgroups 5;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, blood glucose,
,,time);



/*normal bmi*/
data lct_lean;
set lct;
if BMI <25;
run;
proc traj data = work.lct_lean outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucose,
,,time);
proc traj data = work.lct_lean outplot=op outstat=os ;
var ins0 ins2-ins5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
groups 2;
run;
%trajplot (OP, OS, insulin,
,,time);
proc traj data = work.lct_lean outplot=op outstat=os ;
var bz0 bz2-bz5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
groups 2;
run;
%trajplot (OP, OS, blood glucose,
,,time);

data lct_obe;
set lct;
if BMI >25;
run;
proc traj data = work.lct_obe outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucose,
,,time);


/*no prediabetes*/
data lct_health;
set lct;
if bz0<5.7 and bz2<7.9 and bz3 <7.9 and bz4<7.9 and bz5<7.9;
run;
proc traj data = work.lct_health out=out_health outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var gluk0 gluk2-gluk5;
indep time0 time2-time5;
model cnorm;
max 10000;
order 2 2;
var2 ins0 ins2-ins5;
indep2 time0 time2-time5;
model2 cnorm;
max2 10000;
order2 2 2;
var3 bz0 bz2-bz5;
indep3 time0 time2-time5;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, glucagon,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucose,
,,time);
proc traj data = work.lct_health outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2 2;
var2 ins01-ins05;
indep2 time01-time05;
model2 cnorm;
max2 10000;
order2 2 2 2;
var3 gluk01 gluk02 ins05;
indep3 time01 time02 time05;
model3 cnorm;
max3 10000;
order3 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, blood glucose,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucagon,
,,time);
/*prediabetic*/
data lct_pre;
set lct;
if bz01>5.7 or bz02>7.9 or bz03 >7.9 or bz04>7.9 or bz05>7.9;
run;
proc traj data = work.lct_pre outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2;
var2 ins01-ins05;
indep2 time01-time05;
model2 cnorm;
max2 10000;
order2 2 2;
var3 gluk01 gluk02 ins05;
indep3 time01 time02 time05;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucagon,
,,time);
proc traj data = work.lct_pre outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2 2;
var2 ins01-ins05;
indep2 time01-time05;
model2 cnorm;
max2 10000;
order2 2 2 2;
var3 gluk01 gluk02 ins05;
indep3 time01 time02 time05;
model3 cnorm;
max3 10000;
order3 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, blood glucose,
,,time);
%trajplot (OP2, OS2, insulin,
,,time);
%trajplot (OP3, OS3, glucagon,
,,time);




/*wide to long format*/

proc sort data=lct;
by NR;
run;
data lctg;
set lct;
keep NR GRP1PRB GRP2PRB GROUP SEX AGE BMI Matsuda_ISI;
run;
proc transpose data=lct out= longt prefix=time;
by NR;
var time0 time2-time5;
run;
proc transpose data=lct out= longb prefix=bz;
by NR;
var bz0 bz2-bz5;
run;
proc transpose data=lct out= longi prefix=ins;
by NR;
var ins0 ins2-ins5;
run;
proc transpose data=lct out= longg prefix=gluk;
by NR;
var gluk0 gluk1-gluk5;
run;
data lct_long;
merge longt (rename=(time1=time) drop=_name_) longb longi longg lctg;
by NR;
run;

/*boxcox*/
data lct_long;
set lct_long;
z=0;
run;
proc transreg data=lct_long maxiter=0 nozeroconstant;
model boxcox(gluk1 ins1 bz1 / parameter=1)=identity (z);
run;
proc transreg data=lct_long maxiter=0 nozeroconstant;
where time1=0;
model boxcox(bmi matsuda_isi / parameter=1)=identity (z);
run;
data lct_long;
set lct_long;
log_gluk = log(gluk1);
log_ins = (ins1**0.25 + 1)/0.25;
log_bz = (bz1**-.5 +1)/-0.5;
log_bmi = (bmi**-0.75 + 1) / -0.75;
log_matsuda = log(matsuda_isi);
run;

/*mixed model between 2groups*/
proc mixed data = lct_long;
class NR time group;
model log_gluk = time|group / residual solution cl;
repeated time / sub= NR type=un r;
run;
proc mixed data = lct_long;
class NR time group;
model log_ins = time|group / residual solution cl;
repeated time / sub= NR type=un r;
run;
proc mixed data = lct_long;
class NR time group;
model log_bz = time|group / residual solution cl;
repeated time / sub= NR type=un r;
run;

proc mixed data= lct_long;
class NR group;
where time = 0;
model log_matsuda=gluk1 / residual solution cl;
random intercept;
run;
proc mixed data= lct_long;
class NR group;
where time = 0;
model log_matsuda=group|gluk1 / residual solution cl;
random intercept;
run;

/*glm model between 2groups*/
proc glm data = lct_long;
class NR time1 group;
model log_gluk = time1|group /effectsize ;
repeated time1 ;
run;
proc glm data = lct_long;
class NR time1 group;
model log_ins = time1|group / effectsize;
repeated time1 ;
run;
proc glm data = lct_long;
class NR time1 group;
model log_bz = time1|group / effectsize;
repeated time1 ;
run;

proc glm data= lct_long;
class NR group;
where time1 = 0;
model log_BMI=group / residual solution cl;
run;
proc glm data= lct_long;
class NR group;
where time1 = 0;
model log_matsuda=group / residual solution cl;
run;

proc sort data=lct_long;
by group;
run;
proc means data=lct_long;
where time1=0;
class group time1;
by group;
var BMI matsuda_isi gluk1;
run;
proc corr data=lct_long;
where time1=0;
by group;
var BMI matsuda_isi gluk1;
run;
