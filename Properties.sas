
/*********** Parameters to change monthly ***************/
/*NOTE: NEED TO CREATE DIRECTORY D:\DATA\SAS (PC hard drive)  */;

%let Month=December 2010; 
%let month_n=201012;
%let C30= 4.86; *(12/30/2010)
4.32; *(9/30/2010)
4.69; *(6/24/2010)
4.99; *(3/25/2010)
4.98; *(1/28/2010)
5.14; *(12/31/2009)
5.04; *(9/24/2009)
5.42; *(6/25/2009)
4.85; *(3/26/2009)
5.14; *(12/26/2008)
5.97; *(11/27/2008)
5.4; *(12/2/2008)
6.46; *(10/30/2008)
6.09; *(9/25/2008)
6.40; *(8/28/2008)
6.52; *(7/31/2008)
6.45; *(6/26/2008)
6.08; *(5/29/2008)
6.03; *(4/24/2008)
5.85; *(3/27/2008)
6.24; *(2/28/2008)
5.48; *(1/24/2008) ;
%let C15= 4.20; *(12/30/2010)
3.75; *(9/30/2010)
4.13; *(6/24/2010)
4.34; *(3/25/2010)
4.39; *(1/28/2010)
4.54; *(12/31/2009)
4.46; *(9/24/2009)
4.87; *(6/25/2009)
4.58; *(3/26/2009)
4.91; *(12/26/2008)
5.74; *(11/27/2008)
5.1; *(12/2/2008)
6.19; *(10/30/2008)
5.77; *(9/25/2008)
5.93; *(8/28/2008)
6.07; *(7/31/2008)
6.04; *(6/26/2008)
5.66; *(5/29/2008)
5.62; *(4/24/2008)
5.34; *(3/27/2008)
5.72; *(2/28/2008)
4.95; *(1/24/2008); 	
%let T10= 3.39; *(12/24/2010 Lehman)
2.61; *(9/24/2010 Lehman)
3.22; *(6/18/2010 Lehman)
3.69; *(3/19/2010 Lehman)
3.81; *(12/24/2009 Lehman)
3.47; *(9/18/2009 Lehman)
3.79; *(6/19/2009 Lehman)
2.63; *(3/20/2009 Lehman)
2.13; *(12/19/2008 Lehman)
3.17; *(11/21/2008 Lehman)
3.70; *(10/24/2008 Lehman)
3.84; *(9/19/2008 Lehman)
3.87; *(8/22/2008 Lehman)
4.11; *(7/25/2008 Lehman)
3.83; *(5/23/2008 Lehman)
3.71; *(4/18/2008 Lehman)
3.33; *(3/20/2008 Lehman)
3.79; *(2/22/2008 Lehman)
3.64; *(1/18/2008 Lehman);

/***********Don't stop! Check D3 or D4 server************/

/*******************************************************/
/************      Library Definition      *************/
/*******************************************************/
LIBNAME Ddatasas "H:\SAS\output\data\";
LIBNAME Ddrive "H:\SAS\output\";
/*LIBNAME d_sas oledb Provider=MSDASQL.1 properties = ('Data Source'="D3sas");*/
/*LIBNAME d_rpt oledb Provider=MSDASQL.1  BULKLOAD = YES DBCOMMIT=1000  properties = ('Data Source'="D3rpt");*/
%Let DSSAS ="D4SAS";
%Let DSrpt ="D4rpt";
%Let DSDW  ="D4DW" ;
LIBNAME d_sas oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = SAS 'Data Source' = W2KMSTSYD4  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 
LIBNAME d_rpt oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = Rpt 'Data Source' = W2KMSTSYD4  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 
LIBNAME d_DW oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = DW 'Data Source' = W2KMSTSYD4  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 

libname CMHPI oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "H:\MPF\prepayRpt\data\CMHPIstatesSAS_new.xls") 
		provider_string="Excel 8.0";

libname FHSurvey oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "H:\MPF\prepayRpt\data\CPRCDDR_FHSurveyRates.xls") 
		provider_string="Excel 8.0";

libname inhouse oledb 	
	 	BULKLOAD = YES 
		provider="Microsoft.Jet.OLEDB.4.0"
		properties = ('data source'= "H:\MPF\prepayRpt\data\inhouseData_Access2000.mdb");

libname madcloan oledb 	
	 	BULKLOAD = YES 
		provider="Microsoft.Jet.OLEDB.4.0"
		properties = ('data source'= "H:\MPF\prepayRpt\data\ma_dc_loan_Access2000.mdb");
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
