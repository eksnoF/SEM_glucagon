/*import data*/
PROC IMPORT OUT= WORK.lct
            DATAFILE= "C:\glucagon_robert\glucagon_cross_lagged_LCT.xlsx" 
            DBMS=EXCELCS REPLACE;
     RANGE="sheet 1$"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

proc traj data=work.lct out=out outstat=os
outplot=op;
var INS01-INS05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var INS01-INS05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var INS01-INS05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”, “Y-axis label”, “X-axis label”);

proc traj data=work.lct out=out outstat=os
outplot=op;
var bz01-bz05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”, “Y-axis label”, “X-axis label”);



proc traj data=work.lct out=out outstat=os
outplot=op;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);


proc traj data=work.lct out=out outstat=os
outplot=op;
var GLUK01 GLUK02 GLUK05;
indep time01 time02 time05;
model cnorm;
max 10000;
ngroups 2;
order 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, glucagon,
, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var GLUK01 GLUK02 GLUK05;
indep time01 time02 time05;
model cnorm;
max 10000;
ngroups 3;
order 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, glucagon,
, “Y-axis label”, “X-axis label”);
proc traj data=work.lct out=out outstat=os
outplot=op;
var GLUK01 GLUK02 GLUK05;
indep time01 time02 time05;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, glucagon,
, “Y-axis label”, “X-axis label”);


/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
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
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
var BZ01 BZ02 BZ05;
indep time01 time02 time05;
model cnorm;
max 10000;
order 2 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);

/*multiple trajectory model*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01 BZ02 BZ05;
indep time01 time02 time05;
model cnorm;
max 10000;
order 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2;
var3 ins01 ins02 ins05;
indep3 time01 time02 time05;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, insulin,
, “Y-axis label”, “X-axis label”);


/*multiple trajectory model*/
/*2 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2;
var3 ins01-ins05;
indep3 time01-time05;
model3 cnorm;
max3 10000;
order3 2 2;
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, insulin,
, “Y-axis label”, “X-axis label”);
/*3 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2 2;
var3 ins01-ins05;
indep3 time01-time05;
model3 cnorm;
max3 10000;
order3 2 2 2;
multgroups 3;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, insulin,
, “Y-axis label”, “X-axis label”);
/*4 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2 2 2;
var3 ins01-ins05;
indep3 time01-time05;
model3 cnorm;
max3 10000;
order3 2 2 2 2;
multgroups 4;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, insulin,
, “Y-axis label”, “X-axis label”);
/*5 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
var BZ01-BZ05;
indep time01-time05;
model cnorm;
max 10000;
order 2 2 2 2 2;
var2 gluk01 gluk02 gluk05;
indep2 time01 time02 time05;
model2 cnorm;
max2 10000;
order2 2 2 2 2 2;
var3 ins01-ins05;
indep3 time01-time05;
model3 cnorm;
max3 10000;
order3 2 2 2 2 2;
multgroups 5;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, glucagon,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, insulin,
, “Y-axis label”, “X-axis label”);




/*blood glucose and insulin*/
/*2 groups*/
proc traj data = work.lct outplot=op outstat=os outplot2=op2 outstat2=os2;
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
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
data LCT;
set DATA11;
GRP1PRB = GRP1PRB;
GRP2PRB = GRP2PRB;
group = group;
run;

/*normal bmi*/
data lct_lean;
set lct;
if BMI <25;
run;
proc traj data = work.lct_lean outplot=op outstat=os outplot2=op2 outstat2=os2;
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
multgroups 2;
run;
%trajplot (OP, OS, blood glucose,
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
proc traj data=work.lct2 out=out outstat=os
outplot=op;
var bz01-bz05;
indep time01-time05;
model cnorm;
max 10000;
ngroups 4;
order 2 2 2 2;
id TUEFNR;
run;
%trajplot (OP, OS, “Title of graph”,
“Subtitle”, “Y-axis label”, “X-axis label”);


/*no prediabetes*/
data lct_health;
set lct;
if bz01<5.7 and bz02<7.9 and bz03 <7.9 and bz04<7.9 and bz05<7.9;
run;
proc traj data = work.lct_health outplot=op outstat=os outplot2=op2 outstat2=os2 outplot3=op3 outstat3=os3;
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
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, glucagon,
, “Y-axis label”, “X-axis label”);
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
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, glucagon,
, “Y-axis label”, “X-axis label”);
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
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, glucagon,
, “Y-axis label”, “X-axis label”);
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
, “Y-axis label”, “X-axis label”);
%trajplot (OP2, OS2, insulin,
, “Y-axis label”, “X-axis label”);
%trajplot (OP3, OS3, glucagon,
, “Y-axis label”, “X-axis label”);


/*import data*/
/*mixed model analysis between different groups*/
PROC IMPORT OUT= WORK.lct2grps
            DATAFILE= "C:\glucagon_robert\glucagon_cross_lagged_LCT.xlsx" 
            DBMS=EXCELCS REPLACE;
     RANGE="out2grps$"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
/*wide to long format*/
data lct2grps;
set lct2grps;
gluk03=.;
gluk04=.;
run;
proc sort data=lct2grps;
by tuefnr;
run;
data lctg;
set lct2grps;
keep tuefnr bmi matsuda_isi grp1prb grp2prb group;
run;
proc transpose data=lct2grps out= longt prefix=time;
by tuefnr;
var time01-time05;
run;
proc transpose data=lct2grps out= longb prefix=bz;
by tuefnr;
var bz01-bz05;
run;
proc transpose data=lct2grps out= longi prefix=ins;
by tuefnr;
var ins01-ins05;
run;
proc transpose data=lct2grps out= longf prefix=ffami;
by tuefnr;
var FFAMI01-FFAMI05;
run;
proc transpose data=lct2grps out= longg prefix=gluk;
by tuefnr;
var gluk01-gluk05;
run;
data lct_long;
merge longt /*(rename=(time1=time) drop=_name_)*/ longb longi longf longg lctg;
by tuefnr;
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
class tuefnr time1 group;
model log_gluk = time1|group / residual solution cl;
repeated time1 / sub= tuefnr type=un r;
run;
proc mixed data = lct_long;
class tuefnr time1 group;
model log_ins = time1|group / residual solution cl;
repeated time1 / sub= tuefnr type=un r;
run;
proc mixed data = lct_long;
class tuefnr time1 group;
model log_bz = time1|group / residual solution cl;
repeated time1 / sub= tuefnr type=un r;
run;

proc mixed data= lct_long;
class tuefnr group;
where time1 = 0;
model log_BMI=group / residual solution cl;
run;
proc mixed data= lct_long;
class tuefnr group;
where time1 = 0;
model log_matsuda=group / residual solution cl;
run;
/*glm model between 2groups*/
proc glm data = lct_long;
class tuefnr time1 group;
model log_gluk = time1|group /effectsize ;
repeated time1 ;
run;
proc glm data = lct_long;
class tuefnr time1 group;
model log_ins = time1|group / effectsize;
repeated time1 ;
run;
proc glm data = lct_long;
class tuefnr time1 group;
model log_bz = time1|group / effectsize;
repeated time1 ;
run;

proc glm data= lct_long;
class tuefnr group;
where time1 = 0;
model log_BMI=group / residual solution cl;
run;
proc glm data= lct_long;
class tuefnr group;
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
