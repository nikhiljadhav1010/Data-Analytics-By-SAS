/*Importing Cars USA File*/
libname source '/home/u62978370/sasuser.v94/';
data Cars_usa;
set source.carsusa;
run;
/*Importing Milege  file*/
proc import out=Mpg_cars datafile='/home/u62978370/sasuser.v94/carsmpg.xlsx' dbms=xlsx;
getnames=Yes;
run;
/*Importing cars asia txt file*/
filename source '/home/u62978370/sasuser.v94/carsasiapipedelimited.txt';
data cars_asia;
length Make $25. Model $50.;
infile source delimiter='|';
input Make $ Model $ Type $ Origin $ MSRP;
format MSRP dollar8.;
run;
/*Importing Cars Europe Data*/
filename careu '/home/u62978370/sasuser.v94/carseu.xlsx';
proc import datafile= careu 
dbms=xlsx
out=work.Cars_EU;
getnames=YES;
run;
/*Stacking data from Asia europe USA */
Data all_cars;
set cars_asia Cars_EU Cars_usa;
run;

data all_cars;
set all_cars;
Make = strip(Make);
Model = strip(Model);
run;

data Mpg_cars;
set Mpg_cars;
Make = strip(Make);
Model = strip(Model);
run;

proc sort data= all_cars;
by Make Model;
run;
proc sort data=Mpg_cars;
by Make Model;
run;
/*Merging Data of cars with milage*/
data cars_mgp_merged;
merge all_cars Mpg_cars;
by Make Model;
run;
/*filtering data*/
proc sort data=cars_mgp_merged out=High_milage;
By MSRP descending MPG_Highway;
where origin ='Europe' and Type ='SUV';
run;

proc print data=High_milage;
run;

