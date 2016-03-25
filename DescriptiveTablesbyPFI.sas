%Include "H:\SAS\code\prepayment\properties.sas";
/*	PROC TABLES for Chicago all loans */;


OPTIONS ORIENTATION=LANDSCAPE rightmargin=.5in leftmargin=.5in topmargin=.5in bottommargin=.5in nobyline; 

ods _ALL_ close; 
ods rtf FILE='H:\SAS\output\DescriptiveTablesPFI.rtf' bodytitle startpage=no KEEPN;	


%Let datasource=DdataSAS.sasmaster;
%Let rptType=ChicagoDesc;

%Include "H:\SAS\code\prepayment\macro_prctab.sas";
	
	%macro sumtablePFI(stat=);

	PROC TABULATE DATA=&datasource
	    STYLE={JUST=CENTER VJUST=MIDDLE} FORMAT=COMMA11.  ;
	    VAR cCurBal; 
	    CLASS LoanProgram / ORDER=UNFORMATTED;
	    CLASS OrigTerm / ORDER=UNFORMATTED;
		CLASS cPFIrankTop/  ORDER=UNFORMATTED;
	    TABLE 
		/* Row Dimension */
		
			cPFIrankTop={LABEL=''}
			All,
		/* Column Dimension */
		LoanProgram={LABEL=''}*
		OrigTerm={LABEL='Term'}*{STYLE={JUST=CENTER VJUST=MIDDLE}} *
			  	cCurBal={LABEL=''}*
    	        &stat={LABEL=''} 
	        ALL={LABEL='Total'} *
          		cCurBal={LABEL=''}*
            	&stat={LABEL=''}       	
			/*Table Options*/
			/ row=float;
	
	run;
	%mend sumtablePFI;

	
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - portfolio composition by top PFIs'
	               "\R/RTF'\line'   Current Balances ($ million)";
	footnote1 FONT = 'Times New Roman' HEIGHT= 4pt '';
	%Include "H:\SAS\code\prepayment\footnote.sas";

	%sumtablePFI(stat=sum);
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - portfolio composition by top PFIs'
	               "\R/RTF'\line' Percentage of MPF Balance ";
	ods rtf startpage=now;
	%sumtablePFI(stat=PctSum)
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - portfolio composition by top PFIs'
					"\R/RTF'\line'  % of Term Balances across Programs";
	ods rtf startpage=now;
	%sumtablePFI(stat=ColPctSum)
	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt 'MPF Chicago - portfolio composition by top PFIs'
					"\R/RTF'\line'  % of Programs Balances across Terms";
	ods rtf startpage=now;
	%sumtablePFI(stat=RowPctSum)
	ods rtf startpage=now;


/***********************************************************/
/********macro_prctabPFI ***************************************/
/***********************************************************/

%macro prctabPFI(att=, attribute=, balance=, PctType=);

	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt "Percentage of MPF Chicago &labl balance by &attribute &across";
	

	PROC TABULATE DATA=&datasource
	FORMAT=COMMA5.;
    VAR &balance; 
    /*CLASS OrigYear / ORDER=UNFORMATTED MLF;*/;
	CLASS cPFIrankTop/  MISSING ORDER=DATA;
	CLASS &att / MISSING ORDER=UNFORMATTED MLF;
    TABLE 
        /* Row Dimension */ 
       &att={LABEL=''} *
          &balance={LABEL=''}*
            &PctType={LABEL=''} 
        ALL={LABEL='Total (%)'}*
          &balance={LABEL=''}*
			(&PctType={LABEL=''}) 
		ALL={LABEL='Balance ($mil)'}*F=DOLLAR10.*
          &balance={LABEL=''}*(
            Sum={LABEL=''}),
		/* Column Dimension */
		cPFIrankTop={LABEL=''}
        ALL
		/*Table Options*/
		/ row=float;
	RUN;
%MEND prctabPFI;

/***********************************************************/
*\ THE PROGRAM BELOW DEFINES TABLES TO BE RUN SEPARATELY FOR EACH LOAN PROGRAM AND TERM */;
/***********************************************************/
%macro TableSet(labl=);

	%Include "H:\SAS\code\prepayment\titlenote.sas";
	TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "Weighted Average Risk Characteristics - &labl";
	Footnote1  HEIGHT= 12pt  "*Incentive is the spread between GNR and comparable current mortgage rate (30 year:&C30, 15year: &C15).";
	ods escapechar='\';
  	FOOTNOTE2  	FONT = 'Times New Roman' BOLD HEIGHT= 10PT  "The information provided herein is for illustrative purposes only as the results have been created in a research "  
						"\R/RTF'\line'  and development environment and should not be relied upon as being correct for any activity within the Bank."
						"\R/RTF'\line'  The research department makes no representation as to the accuracy and completeness of such information.";
*	%Include "H:\SAS\code\prepayment\footnote.sas";

	PROC TABULATE DATA=&datasource
		FORMAT=DOLLAR6.
	    ;
	    VAR curWAC CurWALA CurWAM FICO OrigLTV curLTV curInc; 
	    CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
	    CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
	    CLASS PrepayStatus / MISSING ORDER=UNFORMATTED;
		CLASS cPFIrankTop / MISSING ORDER=DATA;
	    TABLE 
			/* Row Dimension */
        	curWAC={LABEL='Balance ($mil)'}*
            	SumWgt={LABEL=''}*F=COMMA7.*{STYLE={VJUST=MIDDLE}} 
        	curWAC = {LABEL='GNR'}*F=COMMA4.2*
          		Mean={LABEL=''}
			curInc={LABEL='*Incentive(bp)'}*F=COMMA6.*
          		Mean={LABEL=''}
			CurWALA ={LABEL='Age (month)'}*
          		Mean={LABEL=''}*F=COMMA6.*{STYLE={VJUST=MIDDLE}} 
        	FICO*F=COMMA6.*
	        	Mean={LABEL=''} 
    	    OrigLTV*F=PERCENT6.*
        		Mean={LABEL=''} 
			curLTV*F=PERCENT6.*
          		Mean={LABEL=''} ,
			/* Column Dimension */
			cPFIrankTop={LABEL=''} 
        	ALL={LABEL='MPF'}
		/*Table Options*/
			/ row=float;
    WEIGHT cCurBal; 
	RUN;
	ods rtf startpage=now;
	Title5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "MPF Chicago &labl balance ($ millions) by current incentive as of &month";
	footnote1 FONT = 'Times New Roman' HEIGHT= 4pt '';
	%Include "H:\SAS\code\prepayment\footnote.sas";

PROC TABULATE DATA=&datasource
      FORMAT=COMMA10.;
    VAR cCurBal; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
/*    CLASS OrigYear / ORDER=UNFORMATTED MLF;*/;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
    CLASS curIncentive / MISSING ORDER=UNFORMATTED;
	CLASS cPFIrankTop / MISSING ORDER=DATA;
    TABLE 
		/* Row Dimension */
	     curIncentive={LABEL=''}*
          cCurBal={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          cCurBal={LABEL=''}*
            Sum={LABEL=''},
        /* Column Dimension */
		cPFIrankTop={LABEL=''} 
		ALL
		/* Table Options */
        / INDENT=0 row=float;
		ods rtf startpage=now;
RUN;

	ods rtf startpage=now;
	TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "MPF Chicago &labl premium ($ millions) by current incentive as of &month";
	PROC TABULATE DATA=&datasource
     	FORMAT=COMMA15.;
    	VAR PDdeflate; 
    	CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    	/*CLASS OrigYear / ORDER=UNFORMATTED MLF;*/;
    	CLASS OrigTerm / ORDER=UNFORMATTED MLF;
		CLASS premdiscflag/ ORDER=UNFORMATTED MLF;
    	CLASS curIncentive /  ORDER=UNFORMATTED;
		CLASS cPFIRankTop/  ORDER=DATA;
    TABLE 
		/* Row Dimension */

		premdiscflag={LABEL=''} 
		All={LABEL='Net ($millions)'},
		/* Column Dimension */
		cPFIRankTop*
          PDdeflate={LABEL=''}*
            Sum={LABEL=''} 
        ALL*
          PDdeflate={LABEL=''}*
            Sum={LABEL=''}
		/* Table Options */
        / INDENT=0 row=float;
	RUN;

	ods rtf startpage=now;
	%let across=;
		%prctabPFI(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=PctSum)

	ods rtf startpage=now;

	/*%prctab(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=Sum)*/;

	/*%prctab(att=WACrank, attribute=WAC, balance=cCurBal, PctType=PctSum)*/;
	/*%prctab(att=cStaterank, attribute=State, balance=cCurBal, PctType=PctSum)*/;


	run;
	%let across=across Program-Term;
	
	%prctabPFI(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=WACrank, attribute=WAC, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=WALArank, attribute=WALA, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=lnszrank, attribute=Loan Size, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=loanPurposeCode, attribute=Loan Purpose, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=cStaterank, attribute=State, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=Incomerank, attribute=Monthly Income, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=FICOrank, attribute=FICO Score, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=LTVrank, attribute=Original LTV, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=curLTVrank, attribute=Current LTV, balance=cCurBal, PctType=ColPctSum)
	ods rtf startpage=now;
	%prctabPFI(att=documentationtype, attribute=Documentation Type, balance=cCurBal, PctType=ColPctSum)

	%MEND TableSet;
	
	*\******************************************************\;

	%let across=across Program-Term;
	%Let datasource=Ddatasas.conv30;
	%TableSet(labl=Conventional 30)
	ods rtf startpage=now;		


	%Let datasource=Ddatasas.conv15;
	%TableSet(labl=Conventional 15)
	ods rtf startpage=now;

	%Let datasource=Ddatasas.conv20;
	%TableSet(labl=Conventional 20)
	ods rtf startpage=now;

	%Let datasource=Ddatasas.gov30;
	%TableSet(labl=Government 30)
	

/* End of task code. */

/*ods trace off*/;

ods _ALL_ close; 
ods listing; 
RUN;

