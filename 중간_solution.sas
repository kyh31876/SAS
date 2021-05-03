
options validvarname=any;

/*7*/
data data7;
input id $ y @@;
p=15/150;
w=1/p;
cards;
1 20 2 30 3 30 4 40 5 50
6 30 7 25 8 15 9 30 10 25
11 25 12 25 13 30 14 30 15 45
;
run;

proc surveymeans data=data7 total=150 sum;
var y;
weight w;
run;

/*8*/
data data8;
input sex $ y @@;
cards;
M 15 M 30 M 30 M 40 M 45 M 30 M 25 M 15 M 30 M 28
F 25 F 25 F 30 F 30 F 40 F 20 F 29 F 28 F 30 F 30
;
run;

data data8_2;
set data8;
if sex='M' then prob=10/70;
else if area='F' then prob=10/80;
w=1/prob;
run;

data strata_total;
input SEX $ _total_;
cards;
M 70
F 80
;
run;

proc surveymeans data=data8_2  total=strata_total;
var y;
strata sex;
weight w;
domain area;
run;

/*9*/
data data9 ;
input sex $ y @@ ;
cards;
M 1 M 1 M 1 M 1 M 1
M 0 M 0 M 0 M 0 M 0
M 0 M 0 M 0 M 0 M 0
F 1 F 1 F 0 F 0 F 0
F 0 F 0 F 0 F 0 F 0
F 0 F 0 F 0 F 0 F 0
F 0 F 0 F 0 F 0 F 0
;
run;

data strata_prop2;
set data9;
if sex='M' then prob=15/70;
else if sex='F' then prob=20/80;
w=1/prob;
run;

data strata_total;
input sex $ _total_;
cards;
M 70
F 80
;
run;

proc surveymeans data=strata_prop2 total=strata_total;
var y;
strata sex;
weight w;
run;

/*10*/
options validvarname=any;
proc import  datafile="D:\강의\표본조사\중간고사\중간고사자료.csv"  
out=pop dbms=csv replace;
run;

proc sort data=pop;
by 성별;
run;

proc surveyselect data=pop out=data10 rate=0.1 seed=20210426;
strata 성별;
run;

proc freq data=pop;
table 성별;
run;

data strata_total;
input 성별 _total_;
cards;
1 1630
2 2112
;
run;

proc surveymeans data=data10 total=strata_total;
var 하루비타민섭취량;
strata 성별;
weight SamplingWeight;
run;
