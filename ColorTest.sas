LIBNAME Ddrive "H:\SAS\output\";
LIBNAME IDATASAS "I:\DATA\SAS";

proc template;
	define style styles1.test;
		parent=styles.rtf;
		style table from output /
			BACKGROUND=_undef_;
		style header from header /
			BACKGROUND=CXc8ffc8 ;
*			BACKGROUND=CXFCFFC9;
		style rowheader from rowheader /
			BACKGROUND=CXc8ffc8 ;
	end;
run;

	/*	PROC TABLES for Chicago all loans */;

ods rtf close;
ods rtf FILE='H:\SAS\output\test.rtf' bodytitle startpage=no KEEPN style=styles1.test;	

%Let datasource=Ddrive.sasmaster;
%Let rptType=ChicagoDesc;
/*
Title "MPF Chicago loan purpose by Current LTV as of &month";
PROC TABULATE data=Ddrive.sasmaster
     FORMAT=COMMA15.2;
    VAR curLTV; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS loanpurposecode/ ORDER=UNFORMATTED MLF;
    CLASS cCurbal /  ORDER=UNFORMATTED;

    TABLE 
        loanpurposecode={LABEL=''}*
          curLTV={LABEL=''}*
            mean={LABEL=''} 
        ALL*
          curLTV={LABEL=''}*
            mean={LABEL=''},
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        / INDENT=0 row=float;
    WEIGHT cCurbal; 
RUN;


Title "MPF Chicago loan purpose by Current LTV as of &month for Paid-off Loans";
PROC TABULATE data=Ddrive.sasMSprepaid
     FORMAT=COMMA15.2;
    VAR curLTV; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
	CLASS loanpurposecode/ ORDER=UNFORMATTED MLF;
    CLASS cprevbal /  ORDER=UNFORMATTED;

    TABLE 
        loanpurposecode={LABEL=''}*
          curLTV={LABEL=''}*
            mean={LABEL=''} 
        ALL*
          curLTV={LABEL=''}*
            mean={LABEL=''},
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
        / INDENT=0 row=float;
    WEIGHT cprevBal; 
RUN;
*/

/***********************************************************/
/********macro_prctab ***************************************/
/***********************************************************/

	
	%prctab(att=cpfirank, attribute=PFI, balance=cCurBal, PctType=rowPctSum)
	%prctab(att=cStaterank, attribute=State, balance=cCurBal, PctType=rowPctSum)


/* End of task code. */

/*ods trace off*/;
ods rtf close;
ods _ALL_ close; 
ods listing; 
RUN;

