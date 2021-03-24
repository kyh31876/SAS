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

proc surveymeans data=ex total= 484; /*total */
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
