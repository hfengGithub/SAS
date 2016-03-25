
/*********** Parameters to change monthly ***************/
/*NOTE: NEED TO CREATE DIRECTORY D:\DATA\SAS (PC hard drive)  */;


/*******************************************************/
/************      Library Definition      *************/
/*******************************************************/
LIBNAME Ddatasas "H:\SAS\output\data\";
LIBNAME Ddrive "H:\SAS\output\";
/*LIBNAME d_sas oledb Provider=MSDASQL.1 properties = ('Data Source'="D3sas");*/
/*LIBNAME d_rpt oledb Provider=MSDASQL.1  BULKLOAD = YES DBCOMMIT=1000  properties = ('Data Source'="D3rpt");*/
/*%Let DSSAS ="D4SAS";*/
/*%Let DSrpt ="D4rpt";*/
/*%Let DSDW  ="D4DW" ;*/

LIBNAME d_mraRpt oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = mraRpt 'Data Source' = FHCDBGENMP04\mrap1  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 
RUN;

/*****************************************************************/
*options mloPFIgic;
*options nodate nonumber;
options rightmargin=.7in leftmargin=1in topmargin=.5in bottommargin=.5in;
options nodate;
options yearcutoff=1940;
Goptions device=activex;
ods _all_ close;
ods escapechar='\';
/*****************************************************************/



LIBNAME Ddatasas "H:\SAS\output\data\";
LIBNAME Ddrive "H:\SAS\output\";

LIBNAME d_mraRpt oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = mraRpt 'Data Source' = "FHCDBGENMP04\mrap1"  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 

PROC SQL;
DROP TABLE Ddatasas.extra; 
QUIT;

DATA Ddatasas.extra; 
    SET d_mraRpt.uv_MPFextraLoan;   
RUN;




    SET d_mraRpt.uv_MPFextraLoan (WHERE=(date_key='2013-10-31'));   
