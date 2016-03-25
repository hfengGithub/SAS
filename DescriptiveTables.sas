%Include "H:\SAS\code\prepayment\properties.sas";
/*	PROC TABLES for Chicago all loans */;


OPTIONS ORIENTATION=LANDSCAPE rightmargin=.5in leftmargin=.5in topmargin=.5in bottommargin=.5in nobyline; 
ods _ALL_ close; 
ods rtf FILE='H:\SAS\output\DescriptiveTables.rtf' bodytitle startpage=no KEEPN;	


%Let datasource=DdataSAS.sasmaster;
%Let rptType=ChicagoDesc;

%Include "H:\SAS\code\prepayment\macro_prctab.sas";
	
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - current balance and portfolio composition';
	%Include "H:\SAS\code\prepayment\footnote.sas";
	footnote;
	
	%macro sumtable(stat=);

	PROC TABULATE DATA=&datasource
	    STYLE={JUST=CENTER VJUST=MIDDLE} FORMAT=COMMA11.  ;
	    VAR cCurBal; 
	    CLASS LoanProgram / ORDER=UNFORMATTED;
	    CLASS OrigTerm / ORDER=UNFORMATTED;

	    TABLE 
			/* Row Dimension */
        	LoanProgram={LABEL=''}*
	          	cCurBal={LABEL=''}*
    	        &stat={LABEL=''} 
	        ALL={LABEL='Total'} *
          		cCurBal={LABEL=''}*
            	&stat={LABEL=''} ,
			/* Column Dimension */
        	OrigTerm={LABEL='Term'}*{STYLE={JUST=CENTER VJUST=MIDDLE}} 
        	ALL		
			/*Table Options*/
			/ row=float;
	RUN;
%mend sumtable;

/**/

	TITLE6 FONT = 'Times New Roman' BOLD HEIGHT= 12pt " Current Balances ($million)";
	%sumtable(stat=sum)
	TITLE1 FONT = 'Times New Roman' BOLD HEIGHT= 12pt " % of MPF Balance ";
	%sumtable(stat=PctSum)
	TITLE1 FONT = 'Times New Roman' BOLD HEIGHT= 12pt " % of Term Balances across Programs";
	%sumtable(stat=ColPctSum)
	%Include "H:\SAS\code\prepayment\footnote.sas";
	TITLE1 FONT = 'Times New Roman' BOLD HEIGHT= 12pt " % of Programs Balances across Terms";
	%sumtable(stat=RowPctSum)
	ods rtf startpage=now;
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'Weighted Average Risk Characteristics by Product Type';
	Footnote1  HEIGHT= 12pt  "*Incentive is the spread between GNR and comparable current mortgage rates.";
	ods escapechar='\';
  	FOOTNOTE2  	FONT = 'Times New Roman' BOLD HEIGHT= 10PT  "The information provided herein is for illustrative purposes only as the results have been created in a research "  
						"\R/RTF'\line'  and development environment and should not be relied upon as being correct for any activity within the Bank."
						"\R/RTF'\line'  The research department makes no representation as to the accuracy and completeness of such information.";
	PROC TABULATE DATA=&datasource
		FORMAT=DOLLAR6.
	    ;
	    VAR curWAC CurWALA CurWAM FICO OrigLTV curLTV curInc /weight=cCurBal;
/*		var PDdeflate; */
	    CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED;
/*    	CLASS premdiscflag2 / ORDER=UNFORMATTED;*/

		TABLE 
        	/* Row Dimension */
        	curWAC={LABEL='Balance ($mil)'}*
            	SumWgt={LABEL=''}*F=COMMA7.*{STYLE={VJUST=MIDDLE}} 
        	curWAC = {LABEL='GNR'}*F=COMMA4.2*
          		Mean={LABEL=''}
			curInc={LABEL='*Incentive(bp)'}*F=COMMA6.*
          		Mean={LABEL=''}
			CurWALA ={LABEL='WALA (month)'}*
          		Mean={LABEL=''}*F=COMMA6.*{STYLE={VJUST=MIDDLE}} 
        	FICO*F=COMMA6.*
	        	Mean={LABEL=''} 
    	    OrigLTV*F=PERCENT6.*
        		Mean={LABEL=''} 
			curLTV*F=PERCENT6.*
          		Mean={LABEL=''} 
/*			(premDiscFlag2={LABEL=''} all={LABEL='Net ($mil)'})*
            	PDdeflate={LABEL=''}*sum={LABEL=''}*F=COMMA7.*/
			,
		/* Column Dimension */
		LoanProgram={LABEL=''}*OrigTerm={LABEL=''} 
        	ALL
		/*Table Options*/
			/ row=float;
   RUN;

Title5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "MPF Chicago balance ($millions) by current incentive as of &month";
footnote1;
%Include "H:\SAS\code\prepayment\footnote.sas";


PROC TABULATE DATA=&datasource
      FORMAT=COMMA10.;
    VAR cCurBal; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
    CLASS curIncentive / MISSING ORDER=UNFORMATTED;
	

    TABLE /* Row Dimension */
	
        curIncentive={LABEL=''}*
          cCurBal={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          cCurBal={LABEL=''}*
            Sum={LABEL=''},
        /* Column Dimension */
        LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
		/* Table Options */
        / INDENT=0 row=float;

RUN;
%Include "H:\SAS\code\prepayment\footnote.sas";

%let across=;
	%prctab(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=PctSum)

ods rtf startpage=now;

TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 12pt "MPF Chicago Agent Fee & Basis Adjustment ($millions) by current incentive as of &month";
PROC TABULATE DATA=&datasource
     FORMAT=COMMA15.;
    VAR PDdeflate; 
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
*ods rtf close;
ods rtf startpage=now;


TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 12pt "MPF Chicago Agent Fee & Basis Adjustment ($millions) by GNR as of &month";
PROC TABULATE DATA=&datasource
     FORMAT=COMMA15.;
    VAR PDdeflate; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag2/ ORDER=UNFORMATTED MLF;
    CLASS WACrank		/  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag2={LABEL=''} All={LABEL='Net ($millions)'} ,
		/* Row Dimension */
        WACrank={LABEL=''}*
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
ods rtf startpage=now;
/*	
data temp;
set DdataSAS.sasmaster;

if premdiscflag='P' then premdiscflag2=' Premium ($millions)';
if premdiscflag='D' then premdiscflag2='Discount ($millions)';
		 if curWALA<18 then WALArank='   New  ';
	else if curWALA<30 then WALArank='Moderate';
	else 					WALArank='Seasoned';
run;
*/

TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 12pt "MPF Chicago Agent Fee & Basis Adjustment ($millions) by Age as of &month";
PROC TABULATE DATA=&datasource
     FORMAT=COMMA15.;
    VAR PDdeflate; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag2/ ORDER=UNFORMATTED MLF;
    CLASS WALArank2		/  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag2={LABEL=''} All={LABEL='Net ($millions)'} ,
		/* Row Dimension */
        WALArank2={LABEL=''}*
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
ods rtf startpage=now;
*ods rtf close;


TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 12pt "MPF Chicago Agent Fee & Basis Adjustment/$100 by GNR as of &month";
PROC TABULATE DATA=&datasource
     FORMAT=COMMA10.3;
    VAR premDiscPct / weight=cCurBal; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag2/ ORDER=UNFORMATTED MLF;
    CLASS WACrank		/  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag2={LABEL=''} All={LABEL='Net ($/$100)'} ,
		/* Row Dimension */
        WACrank={LABEL=''}*
          premDiscPct={LABEL=''}*
            Mean={LABEL=''} 
        ALL*
          premDiscPct={LABEL=''}*
            Mean={LABEL=''},
		/* Column Dimension */
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        /* Table Options */
        / INDENT=0 row=float;
RUN;
ods rtf startpage=now;

/***********************************************************/
/********macro_prctab ***************************************/
/***********************************************************/


	/*%prctab(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=Sum)*/;

	/*%prctab(att=WACrank, attribute=WAC, balance=cCurBal, PctType=PctSum)*/;
	/*%prctab(att=cStaterank, attribute=State, balance=cCurBal, PctType=PctSum)*/;
	%let across=across Program-Term;

	%prctab(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=WACrank, attribute=WAC, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=WALArank, attribute=WALA, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=lnszrank, attribute=Loan Size, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=loanPurposeCode, attribute=Loan Purpose, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=cpfirank, attribute=PFI, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=cStaterank, attribute=State, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=Incomerank, attribute=Monthly Income, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=FICOrank, attribute=FICO Score, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=LTVrank, attribute=Original LTV, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctab(att=curLTVrank, attribute=Current LTV, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
/*	%prctab(att=documentationtype, attribute=Documentation Type, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;

data temp;
set &datasource;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);

%let datasource=temp;
%prctab(att=OriginationYear, attribute=Origination Year, balance=cCurBal, PctType=ColPctSum)
*/	
/*
*/
/* End of task code. */

/*ods trace off*/;

ods _ALL_ close; 
ods listing; 
RUN;


