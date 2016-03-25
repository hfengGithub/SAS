*\ PREPAYMENT REPORT \*;

/*  DATE: Friday, June 25, 2004  TIME: 07:58:37 AM  */;

ods listing close; 
/*ods trace on*/;
ods rtf file='H:\SAS\output\Prepayment.rtf' bodytitle startpage=no KEEPN;


%let datasource=Ddatasas.sasMSprepaid;
TITLE 'MPF Chicago - previous balance and portfolio composition for paid-off loans';
%macro prev_sumtable(stat=, tit=);
TITLE2 h=3.5 " &tit ";
	PROC TABULATE DATA=&datasource 
	    STYLE={JUST=CENTER VJUST=MIDDLE} FORMAT=COMMA11.  ;
	    VAR cPrevBal; 
	    CLASS LoanProgram / ORDER=UNFORMATTED;
	    CLASS OrigTerm / ORDER=UNFORMATTED;
		
	    TABLE 
			/* Row Dimension */
        	LoanProgram={LABEL=''}*
	          	cPrevBal={LABEL=''}*
    	        &stat={LABEL=''} 
	        ALL={LABEL='Total'} *
          		cPrevBal={LABEL=''}*
            	&stat={LABEL=''} ,
			/* Column Dimension */
        	OrigTerm*{STYLE={JUST=CENTER VJUST=MIDDLE}} 
        	ALL		
			/*Table Options*/
			/ row=float;
		RUN;
%mend prev_sumtable;
%prev_sumtable(stat=sum, tit=Previous Balances ($ million))
	TITLE ;
%prev_sumtable(stat=PctSum, tit=% of MPF Balance)
%prev_sumtable(stat=ColPctSum, tit=% of Term Balances across Programs)
%prev_sumtable(stat=RowPctSum, tit=% of Programs Balances across Terms)

TITLE 'Weighted Average Risk Characteristics by Product Type for Paid-off Loans';
TITLE2;
	PROC TABULATE DATA=&datasource
	    FORMAT=DOLLAR6.
	    ;
	    VAR curWAC CurWALA CurWAM FICO OrigLTV curLTV incentiveDiff; 
	    CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED;

	    TABLE 
        	/* Row Dimension */
        	curWAC={LABEL='Paidoff Balance($)'}*
            	SumWgt={LABEL=''}*F=COMMA7.*{STYLE={JUST=CENTER VJUST=MIDDLE}} 
        	curWAC={LABEL='GNR'}*
          		Mean={LABEL=''}*F=COMMA4.2 
			incentiveDiff={LABEL='Incentive(bp)'}*F=COMMA6.*
          		Mean={LABEL=''}
			CurWALA={Label='Age (month)'}*F=3.*
          		Mean={LABEL=''}*F=COMMA6.*{STYLE={JUST=CENTER VJUST=MIDDLE}} 
        	FICO*F=COMMA6.*
	        	Mean={LABEL=''} 
    	    OrigLTV*F=PERCENT6.*
        		Mean={LABEL=''} 
			curLTV*F=PERCENT6.*
          		Mean={LABEL=''} ,
		/* Column Dimension */
		LoanProgram={LABEL=''}*OrigTerm={LABEL=''} 
        	ALL
		/*Table Options*/
			/ row=float;
    WEIGHT cprevBal; 
RUN;

ods rtf startpage=now;

Title "MPF Chicago premium by incentive as of &month";
PROC TABULATE data=&datasource
     FORMAT=COMMA15.;
    VAR premdiscamt; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS premdiscflag/ ORDER=UNFORMATTED MLF;
    CLASS Incentiverank /  ORDER=UNFORMATTED;

    TABLE 
		/* Page Dimensions */
		premdiscflag={LABEL=''} All={LABEL='Net($millions)'} ,
		/* Row Dimension */
        Incentiverank={LABEL=''}*
          premdiscamt={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          premdiscamt={LABEL=''}*
            Sum={LABEL=''},
		/* Column Dimension */
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        /* Table Options */
        / INDENT=0 row=float;
RUN;


*/ Macro for creating Loan Attributes*/;
/***********************************************************/
/********macro_prctab ***************************************/
/***********************************************************/


	/*	PROC TABLES for Chicago Paidoff loans */;
%Let rptType=ChicagoPaidoff;
%let across=;	
	/*%prctab(att=WACrank, attribute=WAC for paid-off loans, balance=cprevBal, PctType=PctSum)
	%prctab(att=cStaterank, attribute=State for paid-off loans, balance=cprevBal, PctType=PctSum)*/;
	%prctab(att=Incentiverank, attribute=Incentive for paid-off loans, balance=cprevBal, PctType=PctSum)
%let across=across Program-Term;
	%prctab(att=Incentiverank, attribute=Incentive for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=WACrank, attribute=WAC for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=WALArank, attribute=WALA for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=lnszrank, attribute=Loan Size for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=loanPurposeCode, attribute=Loan Purpose for paid-off loans, balance=cprevBal, PctType=ColPctSum)
ods rtf startpage=now;
	%prctab(att=cpfirank, attribute=PFI for paid-off loans, balance=cprevBal, PctType=ColPctSum)
ods rtf startpage=now;
	%prctab(att=cStaterank, attribute=State for paid-off loans, balance=cprevBal, PctType=ColPctSum)
ods rtf startpage=now;
	%prctab(att=Incomerank, attribute=Monthly Income for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=FICOrank, attribute=FICO Score for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=LTVrank, attribute=Original LTV for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=curLTVrank, attribute=Current LTV for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	%prctab(att=documentationtype, attribute=Documentation Type for paid-off loans, balance=cprevBal, PctType=ColPctSum)
	
/* End of task code. */

/*ods trace off*/;
ods rtf close;
ods _ALL_ close; 
ods listing; 
RUN;

