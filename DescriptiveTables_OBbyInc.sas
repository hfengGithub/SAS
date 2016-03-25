%Include "H:\SAS\code\prepayment\properties.sas";
/*	PROC TABLES for Chicago all loans */;


OPTIONS ORIENTATION=LANDSCAPE rightmargin=.5in leftmargin=.5in topmargin=.5in bottommargin=.5in nobyline; 
ods _ALL_ close; 
ods rtf FILE='H:\SAS\output\DescriptiveTables_OBbyInc.rtf' bodytitle startpage=no KEEPN;	


%Let datasource=DdataSAS.sasmaster;
%Let rptType=ChicagoDesc;

%Include "H:\SAS\code\prepayment\macro_prctab.sas";
	
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - current balance and portfolio composition';
	%Include "H:\SAS\code\prepayment\footnote.sas";
	footnote;
/**/

%let across=;
	%prctab(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=PctSum)

ods rtf startpage=now;

TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 12pt "MPF Chicago Agent Fee & Basis Adjustment ($millions) by current incentive as of &month";
PROC TABULATE DATA=&datasource
     FORMAT=COMMA15.;
    VAR PDdeflate; 
	var portfolioMTM;
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag2/ ORDER=UNFORMATTED MLF;
    CLASS curIncentive /  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag2={LABEL=''} All={LABEL='Net ($millions)'} ,
		/* Row Dimension */
        curIncentive={LABEL=''}*
          PDdeflate={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          PDdeflate={LABEL=''}*
            Sum={LABEL=''},
		/* Column Dimension */
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        /* Table Options */
        / INDENT=0 row=float;
RUN;
PROC TABULATE DATA=&datasource
     FORMAT=COMMA15.;
    *VAR PDdeflate; 
	var portfolioMTM;
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag2/ ORDER=UNFORMATTED MLF;
    CLASS curIncentive /  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag2={LABEL=''} All={LABEL='Net ($millions)'} ,
		/* Row Dimension */
        curIncentive={LABEL=''}*
          portfolioMTM={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          portfolioMTM={LABEL=''}*
            Sum={LABEL=''},
		/* Column Dimension */
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        /* Table Options */
        / INDENT=0 row=float;
RUN;
*ods rtf close;
ods rtf startpage=now;
ods _ALL_ close; 
ods listing; 
RUN;


