/*define monthly attributes and program properties*/
%Include "H:\SAS\code\prepayment\properties.sas";


/* Run store procedure to CREATE SASMASTER TABLE */;
/* 	The macro creates paratemers for running the sp by subtracting 
	one month from the macro variable &month_n defined in Properties*/
* the following step is incoporated into SQL;
/*	
PROC SQL;
CONNECT TO oledb  (Provider=MSDASQL.1 properties = ('Data Source'=&DSSAS ));
EXECUTE 
(
	truncate table 	SASMaster
)
BY oledb;
DISCONNECT FROM oledb ;
QUIT;
*/
	%MACRO runSASmaster;
		%Let rptmm=%sysevalf(&month_n-%sysevalf(&month_n/100, floor)*100);
		%Put &rptmm;
		%IF &rptmm =1 %THEN %DO;	
			%LET mm=12;
			%Let yy=%sysevalf(%sysevalf(&month_n/100, floor)-1);	
			%END;
			%ELSE %DO;
			%LET mm=%sysevalf(&rptmm-1);
			%Let yy=%sysevalf(&month_n/100, floor);	
			%END;
		%Put &yy;
		%Put &mm;


	PROC SQL;
	CONNECT TO oledb  (Provider=MSDASQL.1 properties = ('Data Source'=&DSSAS ));
	EXECUTE 
	(
		EXEC usp_sasMaster &yy, &mm
	)
	BY oledb;
	DISCONNECT FROM oledb ;
	QUIT;

	%MEND;
	%runSASmaster;

/*	PROC SQL;
	CONNECT TO oledb(Provider=SQLOLEDB 
		properties = ( 'Data Source' = W2KMSTSYD3  'Initial Catalog' = SAS 'Integrated Security'=SSPI));
	SELECT * FROM CONNECTION TO oledb(usp_sasMaster &yy, &mm);
	DISCONNECT FROM oledb ;
	QUIT;
*/

*/;



	
