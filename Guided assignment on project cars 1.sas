filename source '/home/u62978370/sasuser.v94/carsasiapipedelimited.txt';
data cars_asia;
length Make $25. Model $50.;
infile source delimiter='|';
input Make $ Model $ Type $ Origin $ MSRP;
format MSRP dollar8.;
run;

filename careu '/home/u62978370/sasuser.v94/carseu.xlsx';
proc import datafile= careu 
dbms=xlsx
out=work.Cars_EU;
getnames=YES;
run;

proc report data=Cars_EU;
where MSRP GT 150000;
format MSRP dollar8.;
run;


