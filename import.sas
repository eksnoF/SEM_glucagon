PROC IMPORT OUT= WORK.LCT 
            DATAFILE= "C:\glucagon_robert\glucagon_cross_lagged_LCT.xlsx" 
            DBMS=EXCELCS REPLACE;
     RANGE="'Sheet 1$'"; 
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;
