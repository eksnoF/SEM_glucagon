PROC IMPORT OUT= WORK.LCT 
            DATAFILE= "C:\glucagon_robert\glucagon5_export_Fons.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
