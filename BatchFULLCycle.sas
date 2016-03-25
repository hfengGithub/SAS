/* --------------------------------------------------------
   DATE: Wednesday, April 26, 2006      
   PROJECT: Monthly Report
   PROJECT PATH: H:\SAS\code\prepayment\
   OUTPUT PATH:  H:\SAS\output\
   By: Catherine Chang and Fabio Zanini
-------------------------------------------------------- */

/************************************************/
/**************    Section I    *****************/
/*************    sql database    ***************/
/************************************************/

/*	Define monthly macro variables, mortgage rates and libnames*/
%Include "H:\SAS\code\prepayment\properties.sas";

/* 	DATA Stamp START */ 
DATA DDATASAS.START;run;

******* IMPORTANT ******* IMPORTANT ******* IMPORTANT ******* 
	THE FOLLOWING FILE MUST BE UPDATED Quartely:
	H:\MPF\prepayRpt\data\CMHPIstatesSAS.xls 
*/;
%Include 'H:\SAS\code\prepayment\update_CMHPI.sas';

******* IMPORTANT ******* IMPORTANT ******* IMPORTANT ******* 
	THE FOLLOWING FILES MUST BE UPDATED:
	H:\MPF\prepayRpt\data\pmm.xls
	H:\MPF\prepayRpt\data\CPRCDDR_FHSurveyRates.xls
*/;
%Include 'H:\SAS\code\prepayment\FHLMC_Survey_Rate_Update.sas';

/* 	Transfer data from productoin to TDEV.  

	******* IMPORTANT ******* IMPORTANT ******* IMPORTANT ******* 
	THE FOLLOWING FILES MUST BE UPDATED:
	H:\MPF\prepayRpt\data\inhouseData_Access2000.mdb
	H:\MPF\prepayRpt\data\ma_dc_loan_Acess2000.mdb
*/;
%Include 'H:\SAS\code\prepayment\ImportProdData.sas';

/* Run store procedure to CREATE SASMASTER TABLE */;
%Include 'H:\SAS\code\prepayment\usp_SASmaster.SAS';

/************************************************/
/**************    Section II    ****************/
/**************    sas reports    ***************/
/************************************************/
/*creates these datasets:
	sasData		sasmaster	sasmasterNew	sasmsCPRs	sasmsPrepaid
	conv15	conv20	conv30	gov15	gov30
*/
%Include 'H:\SAS\code\prepayment\dataMgmt.sas';

/************ Outstanding Loans by Attribute ***********/
%Include "H:\SAS\code\prepayment\macro_prctab.sas";
%Include "H:\SAS\code\prepayment\descriptiveTables.sas"; 
*%Include "H:\SAS\code\prepayment\DescriptiveTablesbyPFI.sas"; 
%Include "H:\SAS\code\prepayment\macro_graphs.sas";
%Include "H:\SAS\code\prepayment\DescriptiveGraphs.sas";

/************** 1-mo. CPR tables/charts ****************/
%Include 'H:\SAS\code\prepayment\CPRbyGNR.sas'; 

/*creates these datasets used in DescriptiveTablesFNMA.sas:
	FN30att		MPFvsFN

cannot run the code below, because it calls cprcdr.sas
%Include "H:\SAS\code\prepayment\DescriptiveTablesFNMA.sas"; 
*/

/************ Attibute tables for prepaid loans *********/
%Include "H:\SAS\code\prepayment\prepayment.sas";


/************** Summary tables for MPF reports ***********/
%Include "H:\SAS\code\prepayment\PortfolioSummary.sas";
%Include "H:\SAS\code\prepayment\ExecSummary.sas";


/* DATA Stamp END */ 
DATA DDATASAS.END; RUN;

QUIT;
GOPTIONS RESET=ALL;
TITLE;FOOTNOTE;RUN;
%LET _EGTASKLABEL =;
ods _all_ close;
ods listing;

libname  madcloan;
