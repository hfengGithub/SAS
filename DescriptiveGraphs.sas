%Include "H:\SAS\code\prepayment\properties.sas";

/*   START OF NODE: graph   */
/* ----------------------------------------
SAS code: by Catherine Chang
Date: July 2004
-----------------------------------------*/
/***********************************************************/

options nobyline ovp;
OPTIONS ORIENTATION=LANDSCAPE rightmargin=1in leftmargin=2in topmargin=.5in bottommargin=.5in nobyline; 
ods _ALL_ close; 
ods rtf file='H:\SAS\output\DescriptiveGraphs.rtf' bodytitle startpage=no KEEPN wordstyle='(\s1 figure;)';
AXIS1
    label=('Current Balance (mil$)')
    MINOR=NONE
    ;
%Include "H:\SAS\code\prepayment\titlenote.sas";
%Include "H:\SAS\code\prepayment\footnote.sas";
/***********************************************************/
/*************macro_graphs**********************************/
/***********************************************************/
%Include "H:\SAS\code\prepayment\macro_graphs.sas";

%let signal=0;
%let product=Ddatasas.conv30;
%let labl=Conventional 30 year Outstanding Loans;
%let bal=cCurBal;
%graphs(state=0, att1=WACrank, attribute1=WAC, index1=0, ax=axis2)
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
%graphs(state=0, att1=WALArank, attribute1=WALA, index1=0) 
%graphs(state=0, att1=lnszrank, attribute1=Loan Size, index1=0)
%graphs(state=0, att1=loanpurposecode, attribute1=Loan Purpose, index1=0) 
%graphs(state=0, att1=cPFIrank, attribute1=PFI, index1=0)
%graphs(state=1, att1=STATE, attribute1=State, index1=0) 
%graphs(state=0, att1=Incomerank, attribute1=Monthly Income, index1=0, ax=axis2)
%graphs(state=0, att1=FICOrank, attribute1=FICO, index1=0, ax=axis2) 
%graphs(state=0, att1=LTVrank, attribute1=Original LTV, index1=0)
%graphs(state=0, att1=curLTVrank, attribute1=Current LTV, index1=0, mid1=.5 to 1 by .05)
/*%graphs(state=0, att1=documentationtype, attribute1=Documentation Type, index1=0)*/
data temp;
set &product;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);
%let product=temp;
%graphs(state=0, att1=OriginationYear, attribute1=Origination Year, index1=0)
/********************************************************/
ods rtf startpage=now;
/********************************************************/
%let product=Ddatasas.conv15;
%let labl=Conventional 15 year Outstanding Loans;
%graphs(state=0, att1=WACrank, attribute1=WAC, index1=0, ax=axis2)
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
%graphs(state=0, att1=WALArank, attribute1=WALA, index1=0) 
%graphs(state=0, att1=lnszrank, attribute1=Loan Size, index1=0)
%graphs(state=0, att1=loanpurposecode, attribute1=Loan Purpose, index1=0) 
%graphs(state=0, att1=cPFIrank, attribute1=PFI, index1=0)
%graphs(state=1, att1=STATE, attribute1=State, index1=0) 
%graphs(state=0, att1=Incomerank, attribute1=Monthly Income, index1=0, ax=axis2)
%graphs(state=0, att1=FICOrank, attribute1=FICO, index1=0, ax=axis2) 
%graphs(state=0, att1=LTVrank, attribute1=Original LTV, index1=0)
%graphs(state=0, att1=curLTVrank, attribute1=Current LTV, index1=0, mid1=.5 to 1 by .05)
/*%graphs(state=0, att1=documentationtype, attribute1=Documentation Type, index1=0)*/
data temp;
set &product;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);
%let product=temp;
%graphs(state=0, att1=OriginationYear, attribute1=Origination Year, index1=0)
/********************************************************/
ods rtf startpage=now;
/********************************************************/
%let product=Ddatasas.conv20;
%let labl=Conventional 20 year Outstanding Loans;
%graphs(state=0, att1=WACrank, attribute1=WAC, index1=0, ax=axis2)
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
%graphs(state=0, att1=WALArank, attribute1=WALA, index1=0) 
%graphs(state=0, att1=lnszrank, attribute1=Loan Size, index1=0)
%graphs(state=0, att1=loanpurposecode, attribute1=Loan Purpose, index1=0) 
%graphs(state=0, att1=cPFIrank, attribute1=PFI, index1=0)
%graphs(state=1, att1=STATE, attribute1=State, index1=0) 
%graphs(state=0, att1=Incomerank, attribute1=Monthly Income, index1=0, ax=axis2)
%graphs(state=0, att1=FICOrank, attribute1=FICO, index1=0, ax=axis2) 
%graphs(state=0, att1=LTVrank, attribute1=Original LTV, index1=0)
%graphs(state=0, att1=curLTVrank, attribute1=Current LTV, index1=0, mid1=.5 to 1 by .05)
/*%graphs(state=0, att1=documentationtype, attribute1=Documentation Type, index1=0)*/
data temp;
set &product;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);
%let product=temp;
%graphs(state=0, att1=OriginationYear, attribute1=Origination Year, index1=0)
/********************************************************/
ods rtf startpage=now;
/********************************************************/
%let product=Ddatasas.gov30;
%let labl=Government  30 year Outstanding Loans;
%graphs(state=0, att1=WACrank, attribute1=WAC, index1=0, ax=axis2)
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
%graphs(state=0, att1=WALArank, attribute1=WALA, index1=0) 
%graphs(state=0, att1=lnszrank, attribute1=Loan Size, index1=0)
%graphs(state=0, att1=loanpurposecode, attribute1=Loan Purpose, index1=0) 
%graphs(state=0, att1=cPFIrank, attribute1=PFI, index1=0)
%graphs(state=1, att1=STATE, attribute1=State, index1=0) 
%graphs(state=0, att1=Incomerank, attribute1=Monthly Income, index1=0, ax=axis2)
%graphs(state=0, att1=FICOrank, attribute1=FICO, index1=0, ax=axis2) 
%graphs(state=0, att1=LTVrank, attribute1=Original LTV, index1=0)
%graphs(state=0, att1=curLTVrank, attribute1=Current LTV, index1=0, mid1=.5 to 1 by .05)
/*%graphs(state=0, att1=documentationtype, attribute1=Documentation Type, index1=0)*/
data temp;
set &product;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);
%let product=temp;
%graphs(state=0, att1=OriginationYear, attribute1=Origination Year, index1=0)
/********************************************************/
ods rtf startpage=now;
/********************************************************/
%let product=Ddatasas.gov15;
%let labl=Government  15 year Outstanding Loans;
%graphs(state=0, att1=WACrank, attribute1=WAC, index1=0, ax=axis2)
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
%graphs(state=0, att1=WALArank, attribute1=WALA, index1=0) 
%graphs(state=0, att1=lnszrank, attribute1=Loan Size, index1=0)
%graphs(state=0, att1=loanpurposecode, attribute1=Loan Purpose, index1=0) 
%graphs(state=0, att1=cPFIrank, attribute1=PFI, index1=0)
%graphs(state=1, att1=STATE, attribute1=State, index1=0) 
%graphs(state=0, att1=Incomerank, attribute1=Monthly Income, index1=0, ax=axis2)
%graphs(state=0, att1=FICOrank, attribute1=FICO, index1=0, ax=axis2) 
%graphs(state=0, att1=LTVrank, attribute1=Original LTV, index1=0)
%graphs(state=0, att1=curLTVrank, attribute1=Current LTV, index1=0, mid1=.5 to 1 by .05)
/*%graphs(state=0, att1=documentationtype, attribute1=Documentation Type, index1=0)*/
data temp;
set &product;
if OrigYear<2000 then OriginationYear='Pre-2000';
else OriginationYear=put(OrigYear, 4.);
%let product=temp;
%graphs(state=0, att1=OriginationYear, attribute1=Origination Year, index1=0)
/**/

/********************************************************/
ods rtf startpage=now;
/********************************************************/
%let signal=1;
AXIS1
    label=('Premium Amount (mil$)')
    MINOR=NONE
    ;
data prem_c30;
set Ddatasas.conv30;
if premdiscFlag='P';
run;
%let product=prem_c30;
%let labl=Conventional 30 year $Premium;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data prem_c15;
set Ddatasas.conv15;
if premdiscFlag='P';
run;
%let product=prem_c15;
%let labl=Conventional 15 year $Premium;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data prem_c20;
set Ddatasas.conv20;
if premdiscFlag='P';
run;
%let product=prem_c20;
%let labl=Conventional 20 year $Premium;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data prem_g30;
set Ddatasas.gov30;
if premdiscFlag='P';
run;
%let product=prem_g30;
%let labl=Government  30 year $Premium;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data prem_g15;
set Ddatasas.gov15;
if premdiscFlag='P';
run;
%let product=prem_g15;
%let labl=Government  15 year $Premium;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)

/********************************************************/
ods rtf startpage=now;
/********************************************************/
AXIS1
    label=('Discount Amount (mil$)')
    MINOR=NONE
    ;
data disc_c30;
set Ddatasas.conv30;
if premdiscFlag='D';
run;
%let product=disc_c30;
%let labl=Conventional 30 year $Discount;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data disc_c15;
set Ddatasas.conv15;
if premdiscFlag='D';
run;
%let product=disc_c15;
%let labl=Conventional 15 year $Discount;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data disc_c20;
set Ddatasas.conv20;
if premdiscFlag='D';
run;
%let product=disc_c20;
%let labl=Conventional 20 year $Discount;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data disc_g30;
set Ddatasas.gov30;
if premdiscFlag='D';
run;
%let product=disc_g30;
%let labl=Government  30 year $Discount;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)
data disc_g15;
set Ddatasas.gov15;
if premdiscFlag='D';
run;
%let product=disc_g15;
%let labl=Government  15 year $Discount;
%let bal=PDdeflate;
%graphs(state=0, att1=curIncentive, attribute1=Current Incentive, index1=0)

/*************************************************************/
ods _all_ close;
ods listing;
QUIT;

/* End of task code. */
RUN;
%LET _EGTASKLABEL =;



