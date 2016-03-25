%Include "H:\SAS\code\prepayment\properties.sas";

/***************InHouseData*****************/
PROC SQL;
CONNECT TO oledb  (Provider=MSDASQL.1 properties = ('Data Source'=&DSrpt));
EXECUTE 
(
	truncate table 	rpt.dbo.rpt_cprcdr_byWAC
	truncate table 	rpt.dbo.rpt_FHLBtotal
	truncate table 	rpt.dbo.rpt_loanAdjustment
	truncate table 	rpt.dbo.rpt_monthlyReport
	truncate table 	rpt.dbo.rpt_poolData
	truncate table 	rpt.dbo.rpt_top20A
	truncate table 	rpt.dbo.rpt_top20B
	truncate table 	rpt.dbo.UV_portfolioLoan
	truncate table 	rpt.dbo.UV_loan_fact_sum
	truncate table 	rpt.dbo.UV_ma_dc_loan
	truncate table 	rpt.dbo.UV_haus_amortization_info
	truncate table 	rpt.dbo.UV_LoanArchiveForRestatement
)
BY oledb;
DISCONNECT FROM oledb ;
QUIT;


PROC SQL;
INSERT INTO D_rpt.UV_ma_dc_loan SELECT mdl_MANumber, mdl_PFINumber, mdl_DCNumber, mdl_LoanNumber, mdl_ChicagoParticipation 
FROM inhouse.UV_ma_dc_loan;
QUIT;

PROC SQL;
INSERT INTO d_rpt.rpt_top20A SELECT * FROM inhouse.rpt_top20A;
QUIT;

PROC SQL;
INSERT INTO D_rpt.rpt_top20B SELECT * FROM inhouse.rpt_top20B;
QUIT;

PROC SQL;
INSERT INTO D_rpt.UV_portfolioLoan SELECT * FROM inhouse.UV_portfolioLoan;
QUIT;


PROC SQL;
INSERT INTO D_rpt.rpt_FHLBtotal SELECT * FROM inhouse.rpt_FHLBtotal;
QUIT;

PROC SQL;
INSERT INTO D_rpt.UV_loan_fact_sum SELECT * FROM inhouse.UV_loan_fact_sum;
QUIT;

PROC SQL;
INSERT INTO D_rpt.UV_haus_amortization_info SELECT * FROM inhouse.UV_haus_amortization_info;
QUIT;

PROC SQL;
INSERT INTO D_rpt.UV_LoanArchiveForRestatement SELECT * FROM inhouse.UV_LoanArchiveForRestatement;
QUIT;

PROC SQL;
INSERT INTO D_rpt.rpt_poolData SELECT * FROM inhouse.rpt_poolData;
QUIT;

PROC SQL;
INSERT INTO D_rpt.rpt_monthlyReport SELECT * FROM inhouse.rpt_monthlyReport;
QUIT;

/* need extra data step la_loanNumber datatype in access is text */;
DATA rpt_loanAdjustment;
	SET inhouse.rpt_loanAdjustment;
	la_loanNumber2 =la_loanNumber/1 ;
RUN;
	
PROC SQL;
INSERT INTO D_rpt.rpt_loanAdjustment 
	SELECT la_loanNumber2, la_asOfDate, la_adjustment, la_nonChAgentFee, la_rptType 
	FROM rpt_loanAdjustment;
QUIT;
Libname inhouse;
run;
quit;


/*******************madcloan**************************/
PROC SQL;
CONNECT TO oledb  (Provider=MSDASQL.1 properties = ('Data Source'=&DSDW));
EXECUTE 
(
	truncate table ma_dc_loan
 	truncate table levelPayment
)
BY oledb;
DISCONNECT FROM oledb ;
QUIT;


PROC SQL;
	INSERT INTO d_DW.ma_dc_loan SELECT * FROM madcloan.ma_dc_loan ;
QUIT;

PROC SQL;
	INSERT INTO d_DW.levelPayment SELECT * FROM madcloan.levelPayment;
QUIT;
libname madcloan;

RUN;
QUIT;
