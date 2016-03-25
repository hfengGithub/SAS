libname Ddatasas "D:\data\sas";

data Ddatasas.Ports;
set Ddatasas.sasmaster;
if portfolioCode~="";
portfolioMTM_D=portfolioMTM/1000000;
run;

ods _all_ close;
ods rtf file="H:\SAS\output\ports.doc" bodytitle startpage=no KEEPN;
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'Weighted Average Characteristics for Ports 31/32 -- August 2006';
	%Include "H:\SAS\code\prepayment\footnote.sas";
	*footnote;

PROC TABULATE DATA=Ddatasas.Ports
		FORMAT=DOLLAR6.
	    ;
	    VAR curWAC CurWALA CurWAM FICO OrigLTV curLTV curInc /weight=cCurBal;
		var PDdeflate; /**/
		var portfolioMTM_D;
		class portfolioCode;
	    CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED;
    	CLASS premdiscflag2 / ORDER=UNFORMATTED;/**/

		TABLE 
        	/* Row Dimension */
        	curWAC={LABEL='Balance ($millions)'}*
            	SumWgt={LABEL=''}*F=COMMA7.*{STYLE={VJUST=MIDDLE}} 
        	curWAC={LABEL='Loan Count'}*
            	N={LABEL=''}*F=COMMA7.*{STYLE={VJUST=MIDDLE}} 
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
			(premDiscFlag2={LABEL=''} all={LABEL='Net ($millions)'})*
            	PDdeflate={LABEL=''}*sum={LABEL=''}*F=COMMA7./**/
			portfolioMTM_D={LABEL='Open Basis ($millions)'}*F=comma6.*
          		sum={LABEL=''} 
			,
		/* Column Dimension */
		portfolioCode={LABEL=''}*OrigTerm={LABEL=''} 
        	ALL
		/*Table Options*/
			/ row=float;
RUN;

title;
footnote;
ods _all_ close;
ods listing;
