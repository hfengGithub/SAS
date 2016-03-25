/* --------------------------------------------------------
   DATE: Monday, July 19, 2004      TIME: 10:11:14 AM
   PROJECT: Monthly Report
   PROJECT PATH: H:\SAS\code\prepayment\
   OUTPUT PATH:  H:\SAS\output\
   By: Catherine Chang and Fabio Zanini
-------------------------------------------------------- */

/*define monthly attributes and program properties*/
%Include "H:\SAS\code\prepayment\properties.sas";

/*creates these datasets:
	sasData		sasmaster	sasmasterNew	sasmsCPRs	sasmsPrepaid
	conv15_j	conv20_j	conv30_j	gov15_j		gov30_j
*/
%Include 'H:\SAS\code\prepayment\datamgmt.sas';

/************ Outstanding Loans by Attribute ***********/
%Include "H:\SAS\code\prepayment\macro_graphs.sas";
%Include "H:\SAS\code\prepayment\DescriptiveGraphs.sas";
/*******************************************************/
%Include "H:\SAS\code\prepayment\macro_prctab.sas";
%Include "H:\SAS\code\prepayment\descriptiveTables.sas"; 

*%Include "H:\SAS\code\prepayment\DescriptiveTablesbyPFI.sas"; 

/*creates these datasets used in DescriptiveTablesFNMA.sas:
	FN30att		MPFvsFN
*/
*Include "H:\SAS\code\prepayment\DescriptiveTablesFNMA.sas"; 

/************** 1-mo. CPR tables/charts ****************/
%Include 'H:\SAS\code\prepayment\CPRbyGNR.sas'; 

/************ Attibute tables for prepaid loans *********/

%Include "H:\SAS\code\prepayment\prepayment.sas";

/************** Summary tables for MPF loans ***********/
%Include "H:\SAS\code\prepayment\PortfolioSummary.sas";
%Include "H:\SAS\code\prepayment\ExecSummary.sas";

QUIT;
GOPTIONS RESET=ALL;
TITLE;FOOTNOTE;RUN;
%LET _EGTASKLABEL =;
ods _all_ close;
ods listing;

