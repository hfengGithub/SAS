/*
libname D "D:\data\sas\";
data t;
set D.sasmaster;
if portfolioCode~="";
run;
ods listing;
proc means sum;
var portfolioMTM ;
run;
*/
%Include "H:\SAS\code\prepayment\properties.sas";

ods _all_ close;
OPTIONS ORIENTATION=LANDSCAPE rightmargin=.5in leftmargin=.5in topmargin=.5in bottommargin=.5in nobyline; 


/*********** Do NOT change code below! (unless you know what you are doing.) :) ***************/

DATA Ddatasas.ExecSum;
	SET Ddatasas.SASMaster(keep= LoanProgram OrigTerm CurWac cCurBal PremDiscAmt curIncentive curInc cCurBal LnSzRank portfolioMTM portfolioCode);
	GrossInt = CurWAC /100 * cCurBal;
	PremDiscAmt=PremDiscAmt/1000000;
	if      loanprogram='Conventional' and origterm='360' then loantype='Conventional 30-yr';
	else if loanprogram='Government'   and origterm='360' then loantype='Government 30-yr';
	else if loanprogram='Conventional' and origterm='180' then loantype='Conventional 15-yr';
	else if loanprogram='Conventional' and origterm='240' then loantype='Conventional 20-yr';
	else loantype='Other';
   		IF curInc = . 		  then RiskExpo='missing'; 
		else if curInc < 0    then RiskExpo='worse'  ; 
   		else if curInc < 25   then RiskExpo='-50bp'  ; 
   		else if curInc < 37.5 then RiskExpo='-25bp'  ; 
   		else if curInc < 50   then RiskExpo='-12.5bp'  ; 
		else if curInc < 62.5 then RiskExpo='Current'; 
   	 	else if curInc < 75   then RiskExpo='+12.5bp'; 
		else if curInc < 100  then RiskExpo='+25bp'; 
		else  					   RiskExpo='+50bp'  ; 
/*	
if curIncentive ='50-75 '	then RiskExpo='Current';
if curIncentive ='00-25 '   then RiskExpo='-50bp'  ;
if curIncentive ='25-50 '   then RiskExpo='-25bp'  ;
if curIncentive ='>75'      then RiskExpo='+25bp'  ;
*/
RUN;
/*
data tt;
set Ddatasas.execsum;
if portfolioCode~="";
run;
*/	
	%Include "H:\SAS\code\prepayment\titlenote.sas";
	%Include "H:\SAS\code\prepayment\footnote.sas";
	
	%macro exectable(source=, outfile=);

	PROC TABULATE DATA=&source out=&outfile
	    STYLE={JUST=CENTER VJUST=MIDDLE} FORMAT=COMMA11.  ;
	    VAR cCurBal GrossInt PremDiscAmt portfolioMTM; 
		CLASS RiskExpo / ORDER=UNFORMATTED;
	    CLASS loantype / ORDER=UNFORMATTED;
		TABLE 
			/* Row Dimension */
        	(loantype ={LABEL=''} 
			All={LABEL='MPF Total'})*{STYLE={JUST=CENTER VJUST=MIDDLE}}*
	          	(GrossInt ={LABEL='GrossInt'}*F=COMMA8.1 
				cCurBal ={LABEL='cCurBal'}
				PremDiscAmt ={LABEL='PremDiscAmt'}
				portfolioMTM ={LABEL='open Basis'})*sum={LABEL=''} 
					,
			/* Column Dimension */
			RiskExpo={LABEL=''}
			/*Table Options*/
			/ row=float;			
	RUN;
	%mend exectable;

	%exectable(source=Ddatasas.ExecSum, outfile=execGrossInt);
ods rtf FILE='H:\SAS\output\temp.rtf' bodytitle startpage=no KEEPN;	
	
	data execGrossInt;
	set execGrossInt;
        if RiskExpo='missing' then id=1; 
        if RiskExpo='worse'   then id=2; 
        if RiskExpo='-50bp'   then do; id=3; FHLMC30=&c30-50/100;	FHLMC15=&c15-50/100;	Treasury10=&T10-50/100;		end;
        if RiskExpo='-25bp'   then do; id=4; FHLMC30=&c30-25/100;	FHLMC15=&c15-25/100;	Treasury10=&T10-25/100;		end;
        if RiskExpo='-12.5bp' then do; id=5; FHLMC30=&c30-12.5/100; FHLMC15=&c15-12.5/100;	Treasury10=&T10-12.5/100;	end;
        if RiskExpo='Current' then do; id=6; FHLMC30=&c30;			FHLMC15=&c15;			Treasury10=&T10;			end;
        if RiskExpo='+12.5bp' then do; id=7; FHLMC30=&c30+12.5/100; FHLMC15=&c15+12.5/100;	Treasury10=&T10+12.5/100;	end;
        if RiskExpo='+25bp'   then do; id=8; FHLMC30=&c30+25/100;	FHLMC15=&c15+25/100;	Treasury10=&T10+25/100;		end;
        if RiskExpo='+50bp'   then do; id=9; FHLMC30=&c30+50/100;	FHLMC15=&c15+50/100;	Treasury10=&T10+50/100;		end;
	if portfolioMTM_sum=. then portfolioMTM_sum=0;
run;
PROC SORT DATA=execGrossInt;
	BY loantype descending id;
run;
	/* CREATE CUMMULATIVE SUM FOR THE Gross INTEREST RATE BY INCENTIVE */;
		DATA execGNRs;
			SET execGrossInt;
		RETAIN GrossIntCum 0 cCurBalCum 0 PremDiscAmtCum 0 portfolioMTMCum 0;
		If loantype='' THEN 	loantype='MPF Total';
		If loantype=Lag(loantype) 
				Then Do; 
				GrossIntCum  =   GrossIntCum +  GrossInt_Sum;
				cCurBalCum = cCurBalCum + cCurBal_Sum ;
				PremDiscAmtCum =PremDiscAmtCum + PremDiscAmt_Sum;
				portfolioMTMCum=portfolioMTMCum+portfolioMTM_Sum;
				End;
				ELSE DO;
				GrossIntCum  =  GrossInt_Sum;
				cCurBalCum = cCurBal_Sum ;
				PremDiscAmtCum = PremDiscAmt_Sum;
				portfolioMTMCum=portfolioMTM_Sum;
				End;
		waGNR=GrossIntCum/cCurBalCum *100;
		FORMAT waGNR COMMA9.6;
	RUN;
PROC SORT DATA=execGNRs;
	BY loantype id;
run;
data execGNRs;
	set execGNRs;
	if id=2 then delete;
	if loantype='Other' then delete;
run;
%macro execTable(att1=,att2=);
	PROC TABULATE DATA=execGNRs
	    STYLE={JUST=CENTER VJUST=MIDDLE} FORMAT=COMMA11.  ;
	    VAR &att1 FHLMC30 FHLMC15 Treasury10; 
		CLASS RiskExpo / ORDER=data ;
	    CLASS loantype / ORDER=UNFORMATTED ;
		TABLE 
			/* Row Dimension */
				FHLMC30={LABEL='FHLMC 30-year Survey Rate'}*{STYLE={JUST=CENTER VJUST=MIDDLE}}*MEAN={LABEL=''}*F=comma8.2 
				FHLMC15={LABEL='FHLMC 15-year Survey Rate'}*{STYLE={JUST=CENTER VJUST=MIDDLE}}*MEAN={LABEL=''}*F=comma8.2 
				Treasury10={LABEL='10-year Treasury'}*{STYLE={JUST=CENTER VJUST=MIDDLE}}*MEAN={LABEL=''}*F=comma8.2 
				loantype={LABEL=''}*{STYLE={JUST=CENTER VJUST=MIDDLE}}*
	          	&att1={LABEL=''}*F=dollar8. *
    	        &att2={LABEL=''}	,	
			/* Column Dimension */
			RiskExpo={LABEL=''}
			/*Table Options*/
			/ row=float;			
	RUN;
%mend execTable;

ods rtf startpage=now;
TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt "MPF Chicago Balance Prepayment Risk Exposure (>= 50 bps incentive) across Products";
%execTable(att1=cCurBalCum,att2=sum);
ods rtf startpage=now;
TITLE5 	FONT = 'Times New Roman' BOLD HEIGHT= 14pt "MPF Chicago Net Unamortized Agent Fee and Basis Adjustment "
					"\R/RTF'\line' Prepayment Risk Exposure (>= 50 bps incentive) across Products";
%execTable(att1=PremDiscAmtCum,att2=sum);
ods rtf startpage=now;
title5 "Open Basis";
%execTable(att1=portfolioMTMCum,att2=sum);
ods _all_ close;
