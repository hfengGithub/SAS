%Include "H:\SAS\code\prepayment\properties.sas";
%Include 'H:\SAS\code\prepayment\cprcdr.sas';
/*	PROC TABLES for Chicago all loans */;


OPTIONS ORIENTATION=LANDSCAPE rightmargin=.5in leftmargin=.5in topmargin=.5in bottommargin=.5in nobyline; 

ods _ALL_ close; 
ods rtf FILE='H:\SAS\output\DescriptiveTablesFNMA.rtf' bodytitle startpage=no KEEPN;	


%Let rptType=ChicagoDesc;

%Include "H:\SAS\code\prepayment\macro_prctab.sas";

%Include "H:\SAS\code\prepayment\titlenote.sas";
%Include "H:\SAS\code\prepayment\footnote.sas";

	
/***********************************************************/
/********macro_prctabFN ***************************************/
/***********************************************************/

%macro prctabFN(att=, attribute=, balance=, PctType=, datasource=, outfile=);


	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt "&Month - Percentage of MPF Chicago and FNMA MBS &labl balances by &attribute";
	

	PROC TABULATE DATA=&datasource OUT= &outfile
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
        
		/*Table Options*/
		/ row=float;
	RUN;
%MEND prctabFN;

/***********************************************************/
*\ THE PROGRAM BELOW DEFINES TABLES TO BE RUN SEPARATELY FOR EACH LOAN PROGRAM AND TERM */;
/***********************************************************/


		
	%let across=across Program-Term;

/*	%prctabFN(att=curIncentive, attribute=Current Incentive, balance=cCurBal, PctType=ColPctSum,datasource= a)
	ods rtf startpage=now;
*/;
	DATA a;
	SET	Ddatasas.MPFvsFN (where=((WALArank='all' and WACrank~='all' and lnszrank='all' and LTVrank = 'all' and FICOrank= 'all') or cPFIrankTop='MPF') );
	run;
	%prctabFN(att=WACrank, attribute=WAC, balance=cCurBal, PctType=ColPctSum, datasource= a, outfile=FNWAC)
	ods rtf startpage=now;
	Data FNWAC; 
	SET FNWAC (where=(cCurBal_PctSum_10 <100));
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	Label cCurBal_PctSum_10 ='% of CurBal';
	run;

	DATA a;
	SET	Ddatasas.MPFvsFN (where=((WALArank ~= 'all' and WACrank= 'all' and lnszrank= 'all' and LTVrank = 'all' and FICOrank='all') or cPFIrankTop='MPF') );
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	run;
	%prctabFN(att=WALArank, attribute=WALA, balance=cCurBal, PctType=ColPctSum,datasource= a, outfile=FNWALA)
	ods rtf startpage=now;
	Data FNWALA; SET FNWALA (where=(cCurBal_PctSum_10 <100));
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	Label cCurBal_PctSum_10 ='% of CurBal';
	run;

	DATA a;
	SET	Ddatasas.MPFvsFN (where=((WALArank='all' and WACrank='all' and lnszrank~='all' and LTVrank ='all' and FICOrank='all') or cPFIrankTop='MPF') );
	run;
	%prctabFN(att=lnszrank, attribute=Loan Size, balance=cCurBal, PctType=ColPctSum,datasource= a, outfile=FNlnsz)
	ods rtf startpage=now;
	Data FNlnsz; SET FNlnsz (where=(cCurBal_PctSum_10 <100));
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	Label cCurBal_PctSum_10 ='% of CurBal';
	run;


	DATA a;
	SET	Ddatasas.MPFvsFN (where=((WALArank='all' and WACrank='all' and lnszrank='all' and LTVrank~='all' and FICOrank='all') or cPFIrankTop='MPF') );
	run;
	%prctabFN(att=LTVrank, attribute=Orig LTV, balance=cCurBal, PctType=ColPctSum,datasource= a, outfile=FNoltv)
	ods rtf startpage=now;
	Data FNoltv; SET FNoltv (where=(cCurBal_PctSum_10 <100));
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	Label cCurBal_PctSum_10 ='% of CurBal';
	run;


	
	DATA a;
	SET	Ddatasas.MPFvsFN (where=((WALArank='all' and WACrank='all' and lnszrank='all' and LTVrank='all' and FICOrank~='all') or cPFIrankTop='MPF') );
	run;
	%prctabFN(att=FICOrank, attribute=FICO, balance=cCurBal, PctType=ColPctSum,datasource= a, outfile=FNFICO)
	ods rtf startpage=now;
	Data FNFICO; SET FNFICO (where=(cCurBal_PctSum_10 <100));
	LoanProgram = 'Conventional';
	OrigTerm = '360';
	Label cCurBal_PctSum_10 ='% of CurBal';
	run;
*\******************************************************\;
%macro CPRgraphFN(att=, att2=, attribute=, ax=, minbal=, datasource=);

	
	
				

/*	TITLE "\R/RTF'\s1 '&Month Chicago &labl year loans 1-mon. CPR by &attribute";
		*/;

	TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "&Month - Percentage of MPF Chicago and FNMA MBS \R/RTF'\line' &labl balances by &attribute " 
 				 /*"\R/RTF'\line'(cohorts with balance >= $ &minbal million)";*/;
	
	
		GOPTIONS device=activex	XMAX = 11IN YMAX = 9.0IN  VSIZE=5.5IN HSIZE=9.0IN  HORIGIN=1IN VORIGIN=1IN;
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
				label=("")
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
		PROC GCHART DATA=&datasource;
			VBAR	 cPFIrankTop/
			NOZERO
			SUMVAR=cCurBal_PctSum_10
			GROUP=&att 
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
	RUN;
	QUIT;
	%MEND CPRgraphFN;
/* -------------------------------------------------------------------
   End of MACRO.
 ------------------------------------------------------------------- */


	%CPRgraphFN(att=WaCrank, att2=WaCrank, attribute=GNR, ax=axis3, minbal=0, datasource=FNWAC)
	run;
	%CPRgraphFN(att=Walarank, att2=Walarank, attribute=WALA, ax=axis3, minbal=0, datasource=FNWALA)
	run;
	%CPRgraphFN(att=Lnszrank, att2=Lnszrank, attribute=Loan Size, ax=axis3, minbal=0, datasource=FNlnsz)
	run;
	%CPRgraphFN(att=LTVrank, att2=LTVrank, attribute=LTV, ax=axis3, minbal=0, datasource=FNoltv)
	run;

	%CPRgraphFN(att=FICOrank, att2=FICOrank, attribute=FICO, ax=axis3, minbal=0, datasource=FNFICO)
	run;


	/* End of task code. */

/*ods trace off*/;

ods _ALL_ close; 
ods listing; 
RUN;
