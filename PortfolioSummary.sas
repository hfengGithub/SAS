%Include "H:\SAS\code\prepayment\properties.sas";

ods _ALL_ close; 
ods rtf file='H:\SAS\output\PortfolioSummary.rtf' bodytitle startpage=YES KEEPN;

*%Include "H:\SAS\code\prepayment\macro_prctab.sas";
title;
footnote;

%Include "H:\SAS\code\prepayment\titlenote.sas";
*%Include "H:\SAS\code\prepayment\footnote.sas";

%Let datasource=Ddatasas.sasmaster;
%Let rptType=ChicagoDesc;
TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'Weighted Average Risk Characteristics by Product Type for Outstanding Loans';
	Footnote1  HEIGHT= 12pt  "*Incentive is the spread between GNR and comparable current mortgage rates.";

	FOOTNOTE2  	FONT = 'Times New Roman' BOLD HEIGHT= 10PT  "The information provided herein is for illustrative purposes only as the results have been created in a research "  
						"\R/RTF'\line'  and development environment and should not be relied upon as being correct for any activity within the Bank."
						"\R/RTF'\line'  The research department makes no representation as to the accuracy and completeness of such information."
						;

data temp2;
set &datasource(keep=LoanProgram OrigTerm PrepayStatus PDdeflate LoanPurposeCode premdiscflag state PDdeflate
					curWAC BaseSVFee curWACnetSvFee  CurWALA CurWAM FICO OrigLTV curLTV curInc cCurBal cPFIrankTop);
	if premdiscflag='P' 	then premdiscflag2='AgentFee+Basis Adj. ($mil): Premium ';
	if premdiscflag='D' 	then premdiscflag2='AgentFee+Basis Adj. ($mil): Discount';
	if state='CA'			then state2=' Balance ($mil): CA             '; 
		else if state='TX' 	then state2=' Balance ($mil): TX             ';
		else 					 state2= "Balance ($mil): Other States";
	if curInc >= 50 		then incentiveclass = "Balance ($mil): Cur. Incentive >= 50bp";
		else 					 incentiveclass = "Balance ($mil): Cur. Incentive < 50bp ";
		/*	ELSE if curInc >= 0 and curInc < 50 	THEN incentiveclass = "Balance ($mil): Cur Incentive >= 0 and < 50bp";
				ELSE incentiveclass = "Balance: Cur Incentive < 0"*/;

run;

	PROC TABULATE DATA=temp2
		FORMAT=DOLLAR6.
	    ;
	    VAR curWAC  BaseSVFee curWACnetSvFee  CurWALA CurWAM FICO OrigLTV curLTV curInc /weight=cCurBal;
		var PDdeflate cCurBal; 
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED ;
		CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED ;
    	CLASS premdiscflag2 /MISSING ORDER=UNFORMATTED ;
    	CLASS LoanPurposeCode / MISSING ORDER=UNFORMATTED ;
    	CLASS state2 /  MISSING ORDER=UNFORMATTED ;
		CLASS incentiveclass /MISSING  ORDER=UNFORMATTED ;

		TABLE 
        	/* Row Dimension */
        	cCurBal={LABEL='Outstanding Balance ($mil)'}*F=COMMA9.0*
            	Sum={LABEL=''}*{STYLE={VJUST=MIDDLE}} 
        	curWAC = {LABEL='GNR'}*F=COMMA5.3*
          		Mean={LABEL=''}
			BaseSVFee *F=COMMA5.3*
          		Mean={LABEL=''}
			curWACnetSvFee  *F=COMMA5.3*
          		Mean={LABEL=''}
			curInc={LABEL='Incentive (bp)*'}*F=COMMA6.*
          		Mean={LABEL=''}
			CurWALA ={LABEL='WALA (months)'}*F=COMMA6.*
          		Mean={LABEL=''}
        	FICO*F=COMMA6.*
	        	Mean={LABEL=''} 
    	    OrigLTV*F=COMMA6.2*
        		Mean={LABEL=''} 
			curLTV*F=COMMA6.2*
          		Mean={LABEL=''} 
        	LoanPurposeCode={LABEL=''}*cCurBal={LABEL=''}*Sum={LABEL=''} *F=COMMA6.
        	state2={LABEL=''}*cCurBal={LABEL=''}*Sum={LABEL=''} *F=COMMA6.
			incentiveclass ={LABEL=''}*cCurBal={LABEL=''}*Sum={LABEL=''}*F=COMMA7.
			(premDiscFlag2={LABEL=''} all={LABEL='AgentFee+Basis Adj. ($mil): Net '})*
            	PDdeflate={LABEL=''}*sum={LABEL=''}*F=COMMA7.

				,
		/* Column Dimension */
		LoanProgram={LABEL=''}*OrigTerm={LABEL=''}
        	ALL
			
		/*Table Options*/
			/ row=float;
   RUN;
title; footnote;
%Include "H:\SAS\code\prepayment\titlenote.sas";
TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'Weighted Average Risk Characteristics by Product Type for Paid-off Loans';
Footnote1  HEIGHT= 12pt  "*Incentive is the spread between GNR and lagged mortgage rates.";
	ods escapechar='\';
  	FOOTNOTE2  	FONT = 'Times New Roman' BOLD HEIGHT= 10PT  "The information provided herein is for illustrative purposes only as the results have been created in a research "  
						"\R/RTF'\line'  and development environment and should not be relied upon as being correct for any activity within the Bank."
						"\R/RTF'\line'  The research department makes no representation as to the accuracy and completeness of such information."
						"\R/RTF'\line'  	"
						"\R/RTF'\line'  	";

%let datasource=Ddatasas.sasMSprepaid;
PROC SQL;
	DROP TABLE temp2;
QUIT;
data temp;
set &datasource(keep=LoanProgram OrigTerm PrepayStatus LoanPurposeCode premdiscflag state
					curWAC BaseSVFee curWACnetSvFee  CurWALA CurWAM FICO OrigLTV curLTV incentiveDiff cPrevBal cPFIrankTop);
	if premdiscflag='P' then premdiscflag2='Premium ($mil)';
	if premdiscflag='D' then premdiscflag2='Discount($mil)';
	if state='CA' 					then state2=' Paid-off  Balance ($mil):  CA        '; 
			else if state='TX' 	then state2=' Paid-off  Balance ($mil):  TX     ';
			else state2= 'Paid-off  Balance ($mil): Other States'; 
	if incentiveDiff >= 50 THEN incentiveclass = " Paid-off  Balance ($mil): Incentive >= 50 bp             ";
	ELSE if incentiveDiff >= 0 THEN incentiveclass = " Paid-off  Balance ($mil): Incentive >= 0 and <50 bp";
	ELSE incentiveclass = " Paid-off  Balance ($mil): Incentive < 0 bp";
run;
	PROC TABULATE DATA=temp
	    FORMAT=DOLLAR6.
	    ;
	    VAR curWAC BaseSVFee curWACnetSvFee  CurWALA CurWAM FICO OrigLTV curLTV incentiveDiff /weight=cPrevBal; 
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
		CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED;
    	CLASS LoanPurposeCode / ORDER=UNFORMATTED;
    	CLASS state2 / ORDER=UNFORMATTED;
    	CLASS incentiveclass / ORDER=UNFORMATTED;
	    TABLE 
        	/* Row Dimension */
        	curWAC={LABEL='Paid-off Balance ($mil)'}*F=COMMA7.*
            	SumWgt={LABEL=''}*{STYLE={VJUST=MIDDLE}} 
        	curWAC={LABEL='GNR'}*F=COMMA5.3 *
          		Mean={LABEL=''}
        	BaseSVFee*F=COMMA5.3 *
          		Mean={LABEL=''}
        	curWACnetSvFee*F=COMMA5.3 *
          		Mean={LABEL=''}
			incentiveDiff={LABEL='Incentive (bp)*'}*F=COMMA6.*
          		Mean={LABEL=''}
			CurWALA={Label='WALA (months)'}*F=3.*
          		Mean={LABEL=''}
        	FICO*F=COMMA6.*
	        	Mean={LABEL=''} 
    	    OrigLTV*F=COMMA6.2*
        		Mean={LABEL=''} 
			curLTV*F=COMMA6.2*
          		Mean={LABEL=''} 
        	LoanPurposeCode={LABEL=''}*F=COMMA6.*
	        	curWAC={LABEL=''}*SumWgt={LABEL=''} 
        	state2={LABEL=''}*F=COMMA6.*
	        	curWAC={LABEL=''}*SumWgt={LABEL=''} 
        	incentiveclass ={LABEL=''}*F=COMMA6.*
	        	curWAC={LABEL=''}*SumWgt={LABEL=''} 

			,
		/* Column Dimension */
		LoanProgram={LABEL=''}*OrigTerm={LABEL=''}
        	ALL
			
		/*Table Options*/
			/ row=float;
RUN;
PROC SQL;
	DROP TABLE temp;
QUIT;

quit;
ods rtf close;
ods _ALL_ close; 
ods listing; 
title;
footnote;
RUN;

