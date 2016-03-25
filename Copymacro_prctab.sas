%macro prctab (att=, attribute=, balance=, PctType=);

	TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt "Percentage of MPF Chicago balance by &attribute &across";
	

	PROC TABULATE DATA=&datasource
	FORMAT=COMMA5.2;
    VAR &balance; 
    CLASS LoanProgram / ORDER=UNFORMATTED MLF;
    CLASS OrigYear / ORDER=UNFORMATTED MLF;
    CLASS OrigTerm / ORDER=UNFORMATTED MLF;
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
		LoanProgram={LABEL=''}*(
          OrigTerm={LABEL=''} 
          ALL) 
        ALL
		/*Table Options*/
		/ row=float;
	RUN;
%MEND prctab;
