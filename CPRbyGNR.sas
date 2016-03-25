%Include "H:\SAS\code\prepayment\properties.sas";

/*************************************************************/
/*******************   START OF NODE: CPR   *****************/
/*************************************************************/
/* ----------------------------------------
By Catherine Chang
July 2004
-----------------------------------------*/
/*************************************************************/
OPTIONS ORIENTATION=LANDSCAPE rightmargin=1in leftmargin=2in topmargin=.5in bottommargin=.5in nobyline; 
ods _ALL_ close; 
ods rtf file='H:\SAS\output\CPRtables.rtf' bodytitle startpage=no KEEPN wordstyle='(\s1 Table;)' SASDATE;

%Let datasource=DdataSAS.sasMSCPRs;
/*******************************************************/
/************Do not alter the code below!***************/
/*******************************************************/

/*******************************************************/
/***********This part for the summary table*************/
/*******************************************************/
/**/



/* AGGREGATE CPRs FOR MPF */

PROC SQL;
    drop view a7;
    drop table a7;
    create table a7 as
    select 'All' as loanprogram, 'All' as OrigT, 'All' as WacRank,sum(cPrevBal) as cPrevBal,
       (1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
	from   &datasource;
QUIT;

PROC SQL;
    drop view a6;
    drop table a6;
    create table a6 as
    select Loanprogram, 'All' as OrigT, 'All' as WacRank,sum(cPrevBal) as cPrevBal,
       (1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
	from   &datasource
	Group by LoanProgram;

QUIT;
run;

	PROC SQL;
	    drop view a5;
	    drop table a5;
	    create table a5 as
	    select Loanprogram, OrigTerm, 'All' as WacRank,sum(cPrevBal) as cPrevBal,
       		(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
		from   &datasource
		Group by LoanProgram, OrigTerm;

	QUIT;
	run;

	data a5;
    set a5;
    if origterm=360 then Origt='360';
    if origterm=240 then Origt='240';
    if origterm=180 then Origt='180';
    if origterm=120 then Origt='120';
    if origterm=84  then Origt=' 84';
    if origterm=60  then Origt=' 60';
    drop origterm;
	run;



/* AGGREGATE CPRs FOR MPF by OrigTerm only */
PROC SQL;
    drop view a4;
    drop table a4;
    create table a4 as
    select 'All' as loanprogram, OrigTerm, 'All' as WACrank,sum(cPrevBal) as cPrevBal,
       (1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
	from   &datasource
	Group by OrigTerm;
QUIT;

	data a4;
    set a4;
    if origterm=360 then Origt='360';
    if origterm=240 then Origt='240';
    if origterm=180 then Origt='180';
    if origterm=120 then Origt='120';
    if origterm=84  then Origt=' 84';
    if origterm=60  then Origt=' 60';
    drop origterm;
	run;



/* AGGREGATE CPRs FOR MPF by OrigTerm and WACrank; NOT BY LOANPROGRAM */
	PROC SQL;
	    drop view a3;
	    drop table a3;
	    create table a3 as
	    select 'All' as loanprogram, WACrank, OrigTerm, sum(cPrevBal) as cPrevBal,
       		(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
    	from   &datasource
    	Group by OrigTerm, WACrank;
	QUIT;

	data a3;
    set a3;
    if origterm=360 then Origt='360';
    if origterm=240 then Origt='240';
    if origterm=180 then Origt='180';
    if origterm=120 then Origt='120';
    if origterm=84  then Origt=' 84';
    if origterm=60  then Origt=' 60';
    drop origterm;
	run;


/* AGGREGATE CPRs FOR MPF by OrigTerm and WACrank; NOT BY LOANPROGRAM */
	PROC SQL;
	    drop view a2;
	    drop table a2;
	    create table a2 as
	    select LoanProgram, WACrank, 'All' as OrigT, sum(cPrevBal) as cPrevBal,
       		(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
    	from   &datasource
    	Group by LoanProgram, WACrank;
	QUIT;

/* AGGREGATE CPRs FOR MPF by LoanProgram, OrigTerm, WACRank */
	PROC SQL;
	    drop view a1;
	    drop table a1;
	    create table a1 as
	    select LoanProgram, OrigTerm, WACRank, sum(cPrevBal) as cPrevBal,
       	(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
    	from   &datasource
    	Group by LoanProgram, OrigTerm, WACRank
		ORDER BY LoanProgram, OrigTerm DESC, WACRank;
	QUIT;


PROC SQL;
    drop view a1b;
    drop table a1b;
    create table a1b as
    select LoanProgram, OrigTerm, IncentiveRank, sum(cPrevBal) as cPrevBal,
       (1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
    from   &datasource
    Group by LoanProgram, OrigTerm, IncentiveRank
	ORDER BY LoanProgram, OrigTerm DESC, IncentiveRank;
QUIT;

	
	data a1;
    	set a1;
    	if origterm=360 then Origt='360';
    	if origterm=240 then Origt='240';
    	if origterm=180 then Origt='180';
    	if origterm=120 then Origt='120';
    	if origterm=84  then Origt=' 84';
    	if origterm=60  then Origt=' 60';	
    	drop origterm;
	run;

	data a1b;
    	set a1b;
    	if origterm=360 then Origt='360';
    	if origterm=240 then Origt='240';
    	if origterm=180 then Origt='180';
    	if origterm=120 then Origt='120';
    	if origterm=84  then Origt=' 84';
    	if origterm=60  then Origt=' 60';	
    	drop origterm;
	run;


	/* First Table with High-level Aggregated CPRs */;

	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "\R/RTF'\s1 '&Month Chicago 1-Month CPR across products";
	%Include "H:\SAS\code\prepayment\footnote.sas";
	

		data final;
    	set a1 a2 a3 a4 a5 a6 a7;
		run;

		

	PROC TABULATE DATA=final (where=(WACrank='All'));
    	VAR cpr1; 
    	CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
    	CLASS OrigT / MISSING ORDER=UNFORMATTED;
		TABLE /* Page Dimension */
			/* Row Dimension */
        	LoanProgram={LABEL=''},
        	/* Column Dimension */
	            OrigT={LABEL=''}*F=COMMA6.1*
            	cpr1={LABEL=''}*
              	Mean={LABEL=''}
        	/box="";
	RUN;

	ods rtf startpage=now;
TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "\R/RTF'\s1 '&Month Chicago 1-Month CPR across products by WAC";
PROC TABULATE DATA=A1;
    	VAR cpr1; 
    	CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
    	CLASS OrigT / MISSING ORDER=UNFORMATTED;
		CLASS WACrank / MISSING ORDER=UNFORMATTED;
		TABLE /* Page Dimension */
			/* Row Dimension */
        	WACrank={LABEL=''},
        	/* Column Dimension */
	            LoanProgram={LABEL=''}*OrigT={LABEL=''}*F=COMMA6.1*
            	cpr1={LABEL=''}*
              	Mean={LABEL=''}
        	/box="GNR";
	RUN;

	ods rtf startpage=now;
TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "\R/RTF'\s1 '&Month Chicago 1-Month CPR across products by Incentive";
	PROC TABULATE DATA=A1b;
    	VAR cpr1; 
    	CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
    	CLASS OrigT / MISSING ORDER=UNFORMATTED;
		CLASS Incentiverank / MISSING ORDER=DATA;
		TABLE /* Page Dimension */
			/* Row Dimension */
        	Incentiverank ={LABEL=''},
        	/* Column Dimension */
	            LoanProgram={LABEL=''}*OrigT={LABEL=''}*F=COMMA6.1*
            	cpr1={LABEL=''}*
              	Mean={LABEL=''}
        	/box="GNR";
	RUN;
	ods rtf startpage=now;
/**/

/* CPRS for last rows names 'All' */;
	data b1;
	    set a1;
	    ind='All';
	    origterm=origt*1;
	    drop origt;
	run;

	proc sort data= b1 nodupkey;
	    by LoanProgram OrigTerm WACrank;

%Include "H:\SAS\code\prepayment\macro_CPRtable.sas";

/**/
	%let labl=Conventional 30;
	%CPRtable(att=Walarank, att2=Walarank, attribute=WALA, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=CPFIrank, att2=CPFIrank, attribute=PFI, loanprg='Conventional', oterm=360, minbal=100)
	ods rtf startpage=now;
	%CPRtable(att=State, att2=cStateRank as State, attribute=State, loanprg='Conventional', oterm=360, minbal=100)
	ods rtf startpage=now;
/*	%CPRtable(att=Incomerank, att2=Incomerank, attribute=Monthly Income, loanprg='Conventional', oterm=360, minbal=10)*/;
	%CPRtable(att=FICOrank, att2=FICOrank, attribute=FICO Score, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LTVrank, att2=LTVrank, attribute=Original LTV, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
/*	%CPRtable(att=documentationtype, att2=documentationtype, attribute=Documentation Type, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRtable(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;*/;
	%CPRtable(att=PropertyTypeCode, att2=PropertyTypeCode, attribute=PropertyType, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=OriginationYear, att2=OriginationYear, attribute=Origination Year, loanprg='Conventional', oterm=360, minbal=10)
	ods rtf startpage=now;
/**/
	%let labl=Conventional 15;
	%CPRtable(att=Walarank, att2=Walarank, attribute=WALA, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=CPFIrank, att2=CPFIrank, attribute=PFI, loanprg='Conventional', oterm=180, minbal=100)
	ods rtf startpage=now;
	%CPRtable(att=State, att2=cStateRank as State, attribute=State, loanprg='Conventional', oterm=180, minbal=100)
	ods rtf startpage=now;
/*	%CPRtable(att=Incomerank, att2=Incomerank, attribute=Monthly Income, loanprg='Conventional', oterm=180, minbal=10)*/;
	%CPRtable(att=FICOrank, att2=FICOrank, attribute=FICO Score, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LTVrank, att2=LTVrank, attribute=Original LTV, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
/*	%CPRtable(att=documentationtype, att2=documentationtype, attribute=Documentation Type, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRtable(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;*/;
	%CPRtable(att=PropertyTypeCode, att2=PropertyTypeCode, attribute=PropertyType, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=OriginationYear, att2=OriginationYear, attribute=Origination Year, loanprg='Conventional', oterm=180, minbal=10)
	ods rtf startpage=now;
/**/
	%let labl=Conventional 20;
	%CPRtable(att=Walarank, att2=Walarank, attribute=WALA, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=CPFIrank, att2=CPFIrank, attribute=PFI, loanprg='Conventional', oterm=240, minbal=50)
	ods rtf startpage=now;
	%CPRtable(att=State, att2=cStateRank as State, attribute=State, loanprg='Conventional', oterm=240, minbal=50)
	ods rtf startpage=now;
/*	%CPRtable(att=Incomerank, att2=Incomerank, attribute=Monthly Income, loanprg='Conventional', oterm=240, minbal=10)*/;
	%CPRtable(att=FICOrank, att2=FICOrank, attribute=FICO Score, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LTVrank, att2=LTVrank, attribute=Original LTV, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
/*	%CPRtable(att=documentationtype, att2=documentationtype, attribute=Documentation Type, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
		Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRtable(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;*/;
	%CPRtable(att=PropertyTypeCode, att2=PropertyTypeCode, attribute=PropertyType, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=OriginationYear, att2=OriginationYear, attribute=Origination Year, loanprg='Conventional', oterm=240, minbal=10)
	ods rtf startpage=now;
/**/
	%let labl=Government 30;
	%CPRtable(att=Walarank, att2=Walarank, attribute=WALA, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=CPFIrank, att2=CPFIrank, attribute=PFI, loanprg='Government', oterm=360, minbal=50)
	ods rtf startpage=now;
	%CPRtable(att=State, att2=cStateRank as State, attribute=State, loanprg='Government', oterm=360, minbal=50)
	ods rtf startpage=now;
/*	%CPRtable(att=Incomerank, att2=Incomerank, attribute=Monthly Income, loanprg='Government', oterm=360, minbal=10)*/;
	%CPRtable(att=FICOrank, att2=FICOrank, attribute=FICO Score, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=LTVrank, att2=LTVrank, attribute=Original LTV, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
/*	%CPRtable(att=documentationtype, att2=documentationtype, attribute=Documentation Type, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
		Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRtable(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;*/;
	%CPRtable(att=PropertyTypeCode, att2=PropertyTypeCode, attribute=Property Type, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;
	%CPRtable(att=OriginationYear, att2=OriginationYear, attribute=Origination Year, loanprg='Government', oterm=360, minbal=10)
	ods rtf startpage=now;

	ods rtf close;
/**/
/********************************************************/
*ods rtf startpage=now;
/*******************************************************/
/*******************************************************/
/*************This part for all attibutes***************/
/*******************************************************/
OPTIONS ORIENTATION=LANDSCAPE rightmargin=1in leftmargin=1in topmargin=1in bottommargin=1in nobyline ; 
ods rtf file='H:\SAS\output\CPRgraphs.rtf' bodytitle startpage=no KEEPN wordstyle='(\s1 Figure;)' SASDATE;

	AXIS1
	    label=('1-month CPR (%)')
	    MINOR=NONE
	    ;

	%macro CPRgraph(att=, att2=, attribute=, ax=, minbal=);

	
		PROC SQL;
	    	drop view b2;                                                                                                                                                                                                                       
	    	drop table b2;
	    	create table b2 as
	    	select LoanProgram, OrigTerm, WACrank, Sum(cPrevBal), &att2 as &att,
       		(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
    		from   &product
			Group by LoanProgram, OrigTerm, WACrank, &att2
			HAVING Sum(cPrevBal)>=&minbal
			ORDER BY LoanProgram, OrigTerm, WACrank, &att2;
		QUIT;

	%IF &att2='WACRank' %THEN 	%DO; 
				DATA b2; SET B2(DROP= WACRANK);
				%END;
	%IF &att2='Incentiverank' %THEN 	%DO ;
				DATA b2; SET B2(DROP= Incentiverank);
				%END;

				

/*	TITLE "\R/RTF'\s1 '&Month Chicago &labl year loans 1-mon. CPR by &attribute";
		*/;

TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "&Month Chicago &labl year loans 1-mon. CPR by &attribute " 
 			 "\R/RTF'\line'(cohorts with balance >= $ &minbal million)";
	
	
	GOPTIONS device=activex	XMAX = 11IN YMAX = 8.5IN  VSIZE=5.4IN HSIZE=9.0IN  HORIGIN=1IN VORIGIN=1IN;
	PATTERN1 color=CX008080;
	PATTERN2 color=CXFABC46;
	PATTERN3 color=CXCD0367;
	PATTERN4 color=CX3F769A;
	PATTERN5 color=CXFF8600;
	PATTERN6 color=CX45AB90;
	PATTERN7 color=CXCA4DB0;
	PATTERN8 color=CXF6D3A5;
	PATTERN9 color=CX274776;
	PATTERN10 color=CXFF72B0;
	PATTERN11 color=CXB0C1F4;
	PATTERN12 color=CX7DFF88;

		AXIS2
			label=(" &attribute ")
	    	MINOR=NONE
			value=(angle=45)
	    	;
		AXIS3
	    	label=(" &attribute ")
	    	MINOR=NONE
	    	;

		Axis1
			STYLE=1
			WIDTH=1
			MINOR=NONE
			LABEL=(FONT='Microsoft Sans Serif' HEIGHT=10pt JUSTIFY=Right)
			;
	PROC GCHART DATA=b2;
		VBAR	 &att /
		NOZERO
		SUMVAR=CPR1
		GROUP=WACrank
		CLIPREF
		FRAME
		G100
		NOHEADING
		TYPE=SUM
		NOLEGEND
		AUTOREF
		COUTLINE=BLACK
		RAXIS=AXIS1
		MAXIS=&AX
	PATTERNID=MIDPOINT
		LREF=1
		CREF=BLACK
		AUTOREF
	;
		BY LoanProgram OrigTerm;
/* -------------------------------------------------------------------
   End of task code.
   ------------------------------------------------------------------- */
	RUN;
	%MEND CPRgraph;
	
	/**/
	%let product=Ddatasas.conv30;
	%let labl=Conventional 30;
	%let gminbal=50;

	%CPRgraph(att=GNR, att2=WACrank, attribute=GNR, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=Incentive, att2=Incentiverank, attribute=Incentive, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=CPFIrank, att2=CPFIrank, attribute=PFI, ax=axis3, minbal=100)
	%CPRgraph(att=State, att2=cStateRank, attribute=State, ax=axis3, minbal=100)

*/	%CPRgraph(att=Incomerank, att2=Incomerank, attribute=Monthly Income, ax=axis3, minbal=&gminbal)*/;
	%CPRgraph(att=FICOrank, att2=FICOrank, attribute=FICO Score, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LTVrank, att2=LTVrank, attribute=Original LTV, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=documentationtype, att2=documentationtype, attribute=Documentation Type, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, ax=axis3, minbal=&gminbal)
*/	%CPRgraph(att=OrigYear, att2=OrigYear, attribute=Origination Year, ax=axis3, minbal=&gminbal)
	
/********************************************************/
	ods rtf startpage=now;
/********************************************************/
	%let product=Ddatasas.conv15;
	%let labl=Conventional 15;

	%CPRgraph(att=GNR, att2=WACrank, attribute=GNR, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=Incentive, att2=Incentiverank, attribute=Incentive, ax=axis3, minbal=&gminbal);
	%CPRgraph(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=CPFIrank, att2=CPFIrank, attribute=PFI, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=State, att2=cStateRank, attribute=State, ax=axis3, minbal=&gminbal)

*/	%CPRgraph(att=Incomerank, att2=Incomerank, attribute=Monthly Income, ax=axis2, minbal=&gminbal)*/;
	%CPRgraph(att=FICOrank, att2=FICOrank, attribute=FICO Score, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=LTVrank, att2=LTVrank, attribute=Original LTV, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=documentationtype, att2=documentationtype, attribute=Documentation Type, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, ax=axis3, minbal=&gminbal)
*/	%CPRgraph(att=OrigYear, att2=OrigYear, attribute=Origination Year, ax=axis3, minbal=&gminbal)

/********************************************************/
	ods rtf startpage=now;
/********************************************************/
	%let product=Ddatasas.conv20;
	%let labl=Conventional 20;

	%CPRgraph(att=GNR, att2=WACrank, attribute=GNR, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=Incentiverank, att2=Incentiverank, attribute=Incentive, ax=axis3, minbal=&gminbal);
	%CPRgraph(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=CPFIrank, att2=CPFIrank, attribute=PFI, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=State, att2=cStateRank, attribute=State, ax=axis3, minbal=&gminbal)
*/	%CPRgraph(att=Incomerank, att2=Incomerank, attribute=Monthly Income, ax=axis2, minbal=&gminbal)*/;
	%CPRgraph(att=FICOrank, att2=FICOrank, attribute=FICO Score, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=LTVrank, att2=LTVrank, attribute=Original LTV, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=documentationtype, att2=documentationtype, attribute=Documentation Type, ax=axis3, minbal=&gminbal)
	Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRgraph(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, ax=axis3, minbal=&gminbal)
*/
	%CPRgraph(att=OrigYear, att2=OrigYear, attribute=Origination Year, ax=axis3, minbal=&gminbal)
;
/********************************************************/
	ods rtf startpage=now;
/********************************************************/
	%let product=Ddatasas.gov30;
	%let labl=Government 30;

	%CPRgraph(att=GNR, att2=WACrank, attribute=GNR, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=Incentive, att2=Incentiverank, attribute=Incentive, ax=axis3, minbal=&gminbal);
	%CPRgraph(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=CPFIrank, att2=CPFIrank, attribute=PFI, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=State, att2=cStateRank, attribute=State, ax=axis3, minbal=&gminbal)

/*	%CPRgraph(att=Incomerank, att2=Incomerank, attribute=Monthly Income, ax=axis2, minbal=&gminbal)*/;
	%CPRgraph(att=FICOrank, att2=FICOrank, attribute=FICO Score, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=LTVrank, att2=LTVrank, attribute=Original LTV, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=documentationtype, att2=documentationtype, attribute=Documentation Type, ax=axis3, minbal=&gminbal)
	Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRgraph(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, ax=axis3, minbal=&gminbal)
*/
	%CPRgraph(att=OrigYear, att2=OrigYear, attribute=Origination Year, ax=axis3, minbal=&gminbal)
;
/********************************************************/
	ods rtf startpage=now;
/********************************************************/
	%let product=Ddatasas.gov15;
	%let labl=Government 15;
	%CPRgraph(att=Incentive, att2=Incentiverank, attribute=Incentive, ax=axis3, minbal=&gminbal);
	%CPRgraph(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=LoanPurposecode, att2=LoanPurposecode, attribute=Loan Purpose, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=CPFIrank, att2=CPFIrank, attribute=PFI, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=State, att2=cStateRank, attribute=State, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=Incomerank, att2=Incomerank, attribute=Monthly Income, ax=axis2, minbal=&gminbal)*/;
	%CPRgraph(att=FICOrank, att2=FICOrank, attribute=FICO Score, ax=axis2, minbal=&gminbal)
	%CPRgraph(att=LTVrank, att2=LTVrank, attribute=Original LTV, ax=axis3, minbal=&gminbal)
	%CPRgraph(att=curLTVrank, att2=curLTVrank, attribute=Current LTV, ax=axis3, minbal=&gminbal)
/*	%CPRgraph(att=documentationtype, att2=documentationtype, attribute=Documentation Type, ax=axis3, minbal=&gminbal)
	Cannot calculate CPRs for premium/discounts unless previous AgentFee/Basis Adjustment has been added to the tables
	%CPRgraph(att=PremDiscFlag, att2=PremDiscFlag, attribute=Premium/Discount Status, ax=axis3, minbal=&gminbal)
*/
	%CPRgraph(att=OrigYear, att2=OrigYear, attribute=Origination Year, ax=axis3, minbal=&gminbal)

;

	
/**/

	ods _all_ close;
	ods listing;
/* End of task code. */
	RUN;
	QUIT;
OPTIONS ORIENTATION=PORTRAIT; 


