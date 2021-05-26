options validvarname=any; /*한글변수명사용 가능*/

data ex;	
input idno  $ name $ team $ strtwght endwght; /*data input method 변수명 뒤에 $로쓰면 문자로 인식*/
cards;	
1023 홍  red 189 165
1049 신 yellow 145 124 
; 
run;

data family3; /*이름, 성별, 나이를 포함하는 family라는 dataset 만들기*/
input idno  name $ sex $ age; 
cards;
1010 민 여 65 
1011 장 남 45
;
run;

libname stat "C:\sa"; /*stat 라는 library 생성*/

data stat.test; /* stat library 에 test 생성*/
input idno  name $ sex $ age; 
cards;
1010 민 여 65 
1011 장 남 45
;
run;


data Kyh.data_txt;   /*실습 data.xlsx 외부데이터 불러와서 자신의 이니셜 라이브러리에 저장*/
infile "C:\Users\OWNER\Downloads\data.txt";
input idno $ name $ team $ strtwght endwght;
run;

proc import datafile="C:\Users\OWNER\Downloads\data.csv"

data ex;  /*ex data 생성 */
input id $ y;
cards; 
1 33.5
2 32
3 52
4 43
5 40
6 45
7 42.5
8 39
9 41
;
run;

proc surveymeans data=ex total= 484; /*total 모집단의수  */
var y; 
run;

data ex1;
input child $ y;
cards;
1 0
2 4
3 2 
4 3
5 2
6 0
7 3
8 4
9 1 
10 1
;
run;

proc surveymeans data=ex1 total=1000; /*평균 충치의 개수를 추정하고, 오차의 한계를 설정 */
var y; 
run;

out=KYH.data_csv dbms=csv replace;
run;

proc import datafile="C:\Users\OWNER\Downloads\실습DATA.xlsx"
out=kyh.data_xlsx replace dbms=xlsx;
sheet="데이터2019";
run;



data smap1;  /*만명중 50명을 뽑는다 seed number 0320*/
do id=1 to 10000;
output; 
end;
run;

proc surveyselect data=smap1 method=srs n=50 out= samp2 seed=0320;
run;

data ex1;
input child $ y w;
cards;
1 0 100
2 4 100
3 2 100 
4 3 100
5 2 100
6 0 100
7 3 100 
8 4 100
9 1 100
10 1 100
;
run;

proc surveymeans data=ex1 total=1000 sum; /*총계 구하기*/
var y; 
weight w;
run;



data ex43; /*모집단 비율추 정*/
input id $ x @@; /*@@ 하면 데이터를 열로 입력가능함*/
cards;
1 1 2 1 
3 1 
4 1
5 1
6 1
7 1
8 1
9 1
10 1
11 1
12 1
13 1
14 1
15 1
16 1
17 1
18 1
19 1
20 1
21 1
22 1
23 1
24 1
25 1
26 0
27 0
28 0
29 0
30 0
;
run; 

proc surveymeans data=ex43 total=300; /*total value 에서 계산*/
var x; 
run;



data pop;  /*가중치는 50,50 */
do id=1 to 1000;
if 1<=id<=500 then group=1;
else if id>=501 then group=2;
output;
end;
run;

proc surveyselect data=pop method=srs n=10 out=strata seed=0409/*각층에서 10개*/
strata group;
run;


proc surveyselect data=pop method=srs n=(10 20) out=strata seed=0409/*그룹1에서 10 2에서 20*/
strata group;
run;
proc surveyselect data=pop method=srs samprate =(0.01 0.02) out=strata seed=0409/*그룹1에서 0.01 그룹2에서 0.02*/
strata group;
run;

data strt1  /*층화추출 모평균 추정 */
input area $ y @@;
cards;
A 35 A 43 A 36 A 39 A 28 A 28 A 29 A 25 A 38 A 27 A 26 A 32 A 29 A 40 A 35 A 41 A 37 A 31 A 45 A 34 B 37 B 15 B 4 B 41 B 49 B 25 B 10 B 30 C 8 C 14 C 12 C 15 C 30 C 32 C 21 C 20 C 34 C 7 C 11 C 24
;
run;

data strt2;
set strt1;
if area ='A' then prob=20/155;
else if area='B' then prob = 8/62;
else if are='C' then prob = 12/93;
w=1/prob;
run;

data strt_total /*모집단 만들기 */
input area $ _total_;
cards;
A 155 
B 62 
C 93
;
run;

proc surveymeans data=strt2  total= strt_total 
var y;
strata area; /*층화변수 주기*/
weight w;/*가중치 주기 */
domain area; /*지역별 변수추가 */
run;


/*평균추정값고 오차한계a*/
data st1; 
input area $ y@@;
cards; 
A 35 A 43 A 39 A 28 A 28 A 29 A 25 A 38 A 27 B 27 B 15 B 4 B 41 B 30 C 8 C 14 C 12 C 15 C 30 C 32 C 21 C 20 C 11 C 24
;
run;

data st2;
set st1;
if area ='A' then prob=10/150;
else if area='B' then prob = 5/60;
else if area='C' then prob = 10/90;
w=1/prob;
run;

data st_total /*모집단 만들기 */
input area $ _total_; /*total 은 __ 를 앞과뒤에 써야됨 */
cards;
A 150
B 60
C 90
;
run;

proc surveymeans data=st2  total=st_total;
var y;
strata area;
weight w;
run;


data s_1;
input area $ y@@;
cards; 
A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A  1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 1 A 0 A 0 A 0 A 0
B 1 B 1 B 0 B 0 B 0 B 0 B 0 B 0
C 1 C 1 C 1 C 1 C 1 C 1 C 1 C 1 C 1 C 0 C 0 C 0 C 0 C 0 C 0
;
run;

data s_2;
set s_1;
if area = 'A' then prob=20/155;
else if area='B' then prob= 8/62;
else if area='C' then prob = 12/93;
w=1/prob;
run;
data st_t 
input area $_total_;
cards;
A 155 
B 62 
C 93
;
run;

proc surveymeans data=s_2 total=st_t sum; 
var y;
*domain area; 
weight w;
strata area;
run;


data a_1; /*5.16문제*/
input people $ y@@;
cards;
A 1 A 1 A 1 A 1 A 1 A 1 A 0 A 0 A 0 A 0 A 0 A 0 A 0 A 0
B 1 B 1 B 1 B 1 B 1 B 1 B 0 B 0 B 0 B 0 B 0 B 0 B 0 B 0 B 0 B 0
;
run;

data a_2;
set a_1;
if people= 'A' then prob=20/800;
else if people='B' then prob=10/200;
w=1/prob;
run;

data a_total;
input people $ _total_;
cards;
A 800
B 200
;
run; 
proc surveymeans data=a_2 total=a_total sum;
var y;
weight w;
strata people;
domain people;
run;

data pop;
do id =1 to 1000;
output;
end;
run; 

proc surveyselect data= pop method=sys  n=100 out=systematic seed=0409; /*100 명중 100명 을 뽑는다*/
run;

proc surveyselect data=pop method=sys n=200 out=systematic seed=0409;
run;

data ex7_1; /* */
input id number @@;
cards; 
1 122.2 2 3.2 3 98.6 4 137.5 5 73.6 6 69.2 7 207.2 8 36.5 9 149.2 10 14.1 
11 0.8 12 60 13 69.1 14 25.4 15 128.5 16 146.4 17 104.8 18 450.5 19 282.4 20 90.7
;
run;

proc sgscatter data=ex7_1;
plot number*id;
run;



data ex7_1;
input year cost @@;
cards;
1 34.9 2 26.9 3 25 4 23 5 29.8 6 32.5 7 32.8 8 33.5 9 37 10 40 11 26 12 32 13 34 15 29 16 29 17 30 18 49 19 46 20 31
;
run;
 
proc sgscatter data=ex_2;
plot=numer;
run;


proc surveymeans data=ex7_1 total=140; /*추정오차 한계*/
var number;
run;


data ex7_2;
set ex7_1;
w=140/20;
run;

proc surveymeans data=ex7_2 total=140 sum; /*총합계 추정*/
var number;
weight w;
run;


data ex7_3;
input id $ y;
cards;
7 1
17 1
27 0
37 0
47 1
57 1
67 0
87 1
97 0
;
run;

data ex7_3_1;
set ex7_3;
w=1/10;
run;

proc surveymeans data=ex7_3_1 total=100;
var y;
weight w;
run;



 data ex7_4;
 input number oz;
 cards;
 1 12 
 2 11.91 
 3 11.87 
 4 12.05
 5 11.75
 6 11.85
 7 11.97
 8 11.98
 9 12.01
10 11.87
11 11.93 
12 11.98
13 12.01
14 12.03
15 11.98
16 11.91
17 11.95
18 11.87
19 12.03
20 11.98
21 11.87
22 11.93
23 11.97
24 12.05
25 12.01
26 12.00
27 11.90
28 11.94
29 11.93
30 12.02 
31 11.80
32 11.83
33 11.88
34 11.89
35 12.05
36 12.04
;
run;

data ex7_4_1;
set ex7_4;
w=1/50;
run;

proc surveymeans data=ex7_4_1 total=1800;
var oz;
weight w;
run;

data ex7_8;
input student  consume @@;
cards;
1 30 2 22 3 10 4 62 5 28 6 31 7 40 8 29 9 17 10 51 
11 29 12 21 13 13 14 15 15 23 16 32 17 14 18 29 19 48 20 50 
21 9 22 15 23 6 24 93 25 21 26 20 27 13 28 12 29 29 30 38
;
run;

data ex7_8_1;
set ex7_8;
w=1/150;
run; 
proc surveymeans data=ex7_8_1 total=4500 sum;
var consume;
weight w;
run;


data ex7_9;
set Tmp1.Temps;
w=30/88;
run;

proc surveyselect data=ex7_9 method=sys n=30 out=systematic seed=2171915;
run;

proc surveymeans data=ex7_9 total=88 SEED=21719159;
var M_P;
weight w;
run;

proc surveyselect data=ex7_9 method=sys n=10 out=systematic seed=21719159;
run;

data pop;
do id=1 to 960;
output;
end;
run;

proc surveyselect data=pop method=sys n=6 rep=10 out=r_systematic seed=0409;   /*표본 6을 10번반복 */
run;

data pop1;
do id=1 to 2000;
output;
end;
run;

proc surveyselect data=pop1 method=sys n=100 rep=20 seed=20210517 out=r_systematic; /*100개의 표본을 5번마다 추출 */
run;


data ex7_6;
do id=1 to 400;
output;
end; 
run;

proc surveyselect data=ex7_6 method=sys n=8 rep=50 out=r_sys;
run;

proc surveymeans data =ex7_6 rate=0.2;/*반복 계통추출일떄는 weight 값필요*/
cluster number; /*반복번호*/
var y;
weight w;
run;
data r_systematic2;
set r_systematic;
w=88/30;
run;

proc surveymeans data =r_systematic2 rate=0.2;/*반복 계통추출일떄는 weight 값필요*/
cluster Replicate; /*반복번호*/
var M_T M_P;
weight w;
run;

data ex8_2;
input cards $ m y;
cards;
1 8 96000
2 12 121000
3 4 42000
4 5 65000
5 6 52000
6 6 40000
7 7 75000
8 5 65000 
9 8 45000 
10 3 50000
11 2 85000 
12 6 43000
13 5 54000 
14 10 49000
15 9 53000 
16 3 50000
74 6 32000 
18 5 22000
19 5 45000
20 4 37000
21 6 51000
22 8 30000
24 3 47000
25 8 41000
; 
run;


proc surveymeans data=ex8_2 total=500;
ratio y/m;
run;

/*총계 추정 */

data ex8_3;
input cards $ m y;
t=y*2500;
cards;
1 8 96000
2 12 121000
3 4 42000
4 5 65000
5 6 52000
6 6 40000
7 7 75000
8 5 65000 
9 8 45000 
10 3 50000
11 2 85000 
12 6 43000
13 5 54000 
14 10 49000
15 9 53000 
16 3 50000
74 6 32000 
18 5 22000
19 5 45000
20 4 37000
21 6 51000
22 8 30000
24 3 47000
25 8 41000
; 
run;

proc surveymeans data=ex8_3 total=500;
ratio t/m;
run;




data ex8_4;
input cluster $ m y ;
ytotal=500*y;
cards;
1 55 2210
2 60 2390
3 63 2430
4 58 2380
5 71 2760
6 78 3110
7 69 2780
8 58 2370
9 52 1990
10 71 2810
11 73 2930
12 64 2470
13 69 2830
14 58 2370
15 63 2390
16 75 2870
17 78 3210
18 51 2430
19 67 2730
20 70 2880
;
run;

data ex8_4;
input cluster $ m y ;
ytotal=60*y;
cards;
1 55 2210
2 60 2390
3 63 2430
4 58 2380
5 71 2760
6 78 3110
7 69 2780
8 58 2370
9 52 1990
10 71 2810
11 73 2930
12 64 2470
13 69 2830
14 58 2370
15 63 2390
16 75 2870
17 78 3210
18 51 2430
19 67 2730
20 70 2880
;
run;


proc surveymeans data=ex8_4 total =5000;
ratio y/m;
; 
run;

proc surveymeans data=ex8_4 total=60 sum;
ratio ytotal/m;

proc surveymeans data=ex8_5 total=60 sum;
ration ytotal;
; 
run;
