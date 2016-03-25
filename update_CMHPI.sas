%Include "H:\SAS\code\prepayment\properties.sas";

 PROC TRANSPOSE DATA=CMHPI.'StIndice$'n Out=TEST;  
	BY YYYYQQ; 
  VAR 	AK  AL  AR  AZ  CA  CO CT  DC  DE  FL  GA  HI  IA  ID  
		IL  IN  KS  KY  LA  MA  MD  ME  MI  MN  MO  MS  MT  
		NC  ND  NE  NH  NJ  NM  NV  NY  OH  OK  OR  PA  RI  SC  
		SD  TN  TX  UT  VA  VT  WA  WI  WV  WY;  
*/;
 run; 

*/TRUNCATE TABLE sas.dbo.sas_valState 
select * from sas.dbo.sas_valState order by state, yearqtr
*/;
DATA TEST2;
	Set TEST;
	yearQtr = YYYYQQ;
	state= _Name_;
	valindex=col1;
	DROP YYYYQQ _Name_ COL1 _Label_;
	run;

 
PROC SQL;
CONNECT TO oledb (Provider=MSDASQL.1 properties = ('Data Source'=&DSSAS ));
EXECUTE (TRUNCATE TABLE sas_valstate) BY oledb;
Insert Into d_sas.sas_valstate
Select * from TEST2;
QUIT;

libname CMHPI;
	
