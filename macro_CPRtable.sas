	%macro CPRtable(att=, att2=, attribute=, loanprg=, oterm=, minbal=);
	/*ods rtf prepage = "\R/RTF'\s1 '&Month 1-Month CPR by &attribute across products";*/
		TITLE5 FONT = 'Times New Roman' BOLD HEIGHT= 14pt "&Month Chicago &labl year loans 1-mon. CPR "
						"\R/RTF'\line'  by &attribute (cohort balance >= $ &minbal million)";
		
		data b1;
		    set b1;
	    	&att=ind;
	    	drop ind;
		run;

		PROC SQL;
	    	drop view b2;
	    	drop table b2;
	    	create table b2 as
		select LoanProgram, OrigTerm, WACrank, &att, sum(cPrevBal) as cPrevBal,
	       	(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
	    From   &datasource
		Group by LoanProgram, OrigTerm, WACrank, &att;
		QUIT;
	
			
/*		PROC SQL;
	    	drop view b3;
	    	drop table b3;
	    	create table b3 as
		select LoanProgram, OrigTerm, 'All' as WACrank, sum(cPrevBal) as cPrevBal, &att,
	       	(1-(1-sum(cPrevBal*smm)/sum(cPrevBal)/100)**12)*100 as CPR1
	    From   &datasource
		Group by LoanProgram, OrigTerm, &att;
		QUIT;
*/;
		data fin(where=( OrigTerm=&oterm AND cPrevBal>&minbal AND LoanProgram=&loanprg) );
	    	set b2 b1;
		run;

		PROC TABULATE DATA=fin;
		    VAR cpr1; 
	    	CLASS LoanProgram / MISSING ORDER=UNFORMATTED;
	    	CLASS OrigTerm / MISSING ORDER=UNFORMATTED;
			CLASS WACrank / MISSING ORDER=UNFORMATTED;
	    	CLASS &att / ORDER=DATA;
	
	    TABLE /* Page Dimension */
			/* Row Dimension */
	      WACrank ={LABEL=''},
        	/* Column Dimension */
/*		LoanProgram={LABEL=''}**/
		 	&att={LABEL=''}*
				cpr1={LABEL=''}*
              	Mean={LABEL=''}*F=COMMA5.1
        	/box="&attribute ";
*/;	RUN;
	data b1;
	    set b1;
	    ind = &att;
	    drop &att;
	run;

	%mend CPRtable;
