data cars_mgp_merged;
merge all_cars Mpg_cars;
by Make Model;
run;

ODS trace on;
proc freq data= cars_mgp_merged;
table Make*origin;
run;
ODS trace on;

ODS output Freq.Table1.CrossTabFreqs =cars_mgp_merged_freqq;
proc freq data= cars_mgp_merged;
table Make*origin;
run;
ODS output off;

Data New_cars;
set cars_mgp_merged_freqq;
where Frequency not = 0 and not(RowPercent is null);
obs_freqq = cat(Frequency, "(" ,round(percent,.01),'%)' );
Drop Table _TYPE_ _TABLE_ Frequency percent RowPercent ColPercent Missing;
run;

proc sort data= New_cars;
by Make;
run;

proc transpose data= New_cars out=T_new_cars;
var obs_freqq;
id Origin;
by Make;
run;

proc print data= T_new_cars(drop=_name_);
Title "Report of Frequency Count And Percentage";
run;
