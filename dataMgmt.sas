
*\ creates the table SAS.dbo.SASMaster by running the stored procedure SAS_CreateSASTables *\;

/*****	last updated: April 13, 2006 by Catherine ******/
/*******************************************************/
/************Dataset Management: SASMASTER!*************/
/*******************************************************/
%Include "H:\SAS\code\prepayment\properties.sas";

PROC SQL;
DROP TABLE Ddatasas.SASdata; 
QUIT;


DATA Ddatasas.SASdata; 
    SET d_sas.sasmaster (WHERE=(Prepayperiod>=&month_n OR Prepayperiod Is Null));   
    OrigDate = DATEPART(OrigDate);
    Format OrigDate MMDDYY8.;
    format IncomeRank $13. PremDiscFlag $3. documentationType $7.;
    *Label lnszRank = 'Loan Size Class';
	IF SUBSTR(LoanProgram,1, 1)="C" THEN BaseSVFee=.25; 
		ELSE  IF SUBSTR(LoanProgram,1, 1)="G" THEN BaseSVFee=.44; 
	curWACnetSvFee = curWAC -BaseSVFee;
    IF documentationtype='' then documentationtype='missing';
	IF cCurBal>0 THEN premDiscPct = (cCurBal + premDiscAmt/1000000)/cCurBal*100;
		ELSE premDiscPct = 0;

	if premdiscflag='P' then premdiscflag2=' Premium ($millions)';
	if premdiscflag='D' then premdiscflag2='Discount ($millions)';

OrigBal2=OrigBal*1000;
	if OrigBal=. 			then LSrank40='  missing  ';
	else if OrigBal2<40 	then LSrank40='  < 40k    ';
	else if OrigBal2<80 	then LSrank40='  40 ~ 80k  ';
	else if OrigBal2<120 	then LSrank40='  80 ~ 120k ';
	else if OrigBal2<160 	then LSrank40=' 120 ~ 160k ';
	else if OrigBal2<200 	then LSrank40=' 160 ~ 200k ';
	else if OrigBal2<240 	then LSrank40=' 200 ~ 240k ';
	else if OrigBal2<280 	then LSrank40=' 240 ~ 280k ';
	else if OrigBal2<320 	then LSrank40=' 280 ~ 320k ';
	else 					  	 LSrank40=' >= 320k ';

    IF FICO = . THEN            FICOrank = 'missing';
        ELSE IF FICO < 500 THEN FICOrank = ' 0 -500';
        ELSE IF FICO < 525 THEN FICOrank = '500-525';
        ELSE IF FICO < 550 THEN FICOrank = '525-550';
        ELSE IF FICO < 575 THEN FICOrank = '550-575';
        ELSE IF FICO < 600 THEN FICOrank = '575-600';
        ELSE IF FICO < 625 THEN FICOrank = '600-625';
        ELSE IF FICO < 650 THEN FICOrank = '625-650';
        ELSE IF FICO < 675 THEN FICOrank = '650-675';
        ELSE IF FICO < 700 THEN FICOrank = '675-700';
        ELSE IF FICO < 725 THEN FICOrank = '700-725';
        ELSE IF FICO < 750 THEN FICOrank = '725-750';
        ELSE IF FICO < 775 THEN FICOrank = '750-775';
        ELSE IF FICO < 800 THEN FICOrank = '775-800';
        ELSE                    FICOrank = '>= 800 ';
    IF origLTV = . THEN            LTVrank = 'missing';
        ELSE IF origLTV < .60 THEN LTVrank = ' 0 - 60';
        ELSE IF origLTV < .70 THEN LTVrank = ' 60- 70';
        ELSE IF origLTV < .80 THEN LTVrank = ' 70- 80';
        ELSE IF origLTV < .8001  THEN LTVrank = ' 80  ';
        ELSE IF origLTV < .90 THEN LTVrank = ' 80- 90';
        ELSE                       LTVrank = '>=  90 ';
    IF curLTV = . THEN             curLTVrank = 'missing';
        ELSE IF curLTV < .60  THEN curLTVrank = ' 0 - 60';
        ELSE IF curLTV < .70  THEN curLTVrank = ' 60- 70';
        ELSE IF curLTV < .80  THEN curLTVrank = ' 70- 80';
        ELSE IF curLTV < .90  THEN curLTVrank = ' 80- 90';
        ELSE                       curLTVrank = '>=  90 ';
    IF curWAC = . THEN             WACrank = 'missing  ';
        ELSE IF curWAC < 4.25 THEN WACrank = '0.0 -4.25';
        ELSE IF curWAC < 4.75 THEN WACrank = '4.25-4.75';
        ELSE IF curWAC < 5.25 THEN WACrank = '4.75-5.25';
        ELSE IF curWAC < 5.75 THEN WACrank = '5.25-5.75';
        ELSE IF curWAC < 6.25 THEN WACrank = '5.75-6.25';
        ELSE IF curWAC < 6.75 THEN WACrank = '6.25-6.75';
        ELSE IF curWAC < 7.25 THEN WACrank = '6.75-7.25';
        ELSE IF curWAC < 7.75 THEN WACrank = '7.25-7.75';
        ELSE IF curWAC < 8.25 THEN WACrank = '7.75-8.25';
        ELSE IF curWAC < 8.75 THEN WACrank = '8.25-8.75';
        ELSE IF curWAC < 9.25 THEN WACrank = '8.75-9.25';
        ELSE                       WACrank = '>= 9.25 ';
    IF curWALA = . THEN            WALArank = 'missing ';
        ELSE IF curWALA < 6  THEN  WALArank = ' 0 - 6  ';
        ELSE IF curWALA < 12 THEN  WALArank = ' 6 - 12 ';
        ELSE IF curWALA < 18 THEN  WALArank = '12-18  ';
        ELSE IF curWALA < 24 THEN  WALArank = '18-24  ';
        ELSE IF curWALA < 30 THEN  WALArank = '24-30  ';
        ELSE IF curWALA < 36 THEN  WALArank = '30-36  ';
        ELSE                       WALArank = '>= 36  ';

	WALArank2='Seasoned';		 
	if curWALA<18 then WALArank2='   New  ';
		else if curWALA<30 then WALArank2='Moderate';				

    IF BorrowerIncome = . THEN              IncomeRank = 'missing  ';
        ELSE IF BorrowerIncome < 3000  THEN IncomeRank = ' <  3k';
        ELSE IF BorrowerIncome < 6000  THEN IncomeRank = ' 3- 6k';
        ELSE IF BorrowerIncome < 9000  THEN IncomeRank = ' 6- 9k';
        ELSE IF BorrowerIncome < 12000 THEN IncomeRank = ' 9-12k';
        ELSE IF BorrowerIncome < 15000 THEN IncomeRank = '12-15k';
        ELSE                                IncomeRank = '>= 15k';
/*	IncentiveDiff=IncentiveDiff + 25;*/
    IF IncentiveDiff = . THEN             IncentiveRank = 'missing';
        ELSE IF IncentiveDiff < -150 THEN IncentiveRank = '< -150';
		ELSE IF IncentiveDiff < -125 THEN IncentiveRank = '< -125 ';
        ELSE IF IncentiveDiff < -100 THEN IncentiveRank = '< -100';
		ELSE IF IncentiveDiff < -75  THEN IncentiveRank = '< -75 ';
        ELSE IF IncentiveDiff < -50  THEN IncentiveRank = '< -50 ';
		ELSE IF IncentiveDiff < -25  THEN IncentiveRank = '< -25 ';
        ELSE IF IncentiveDiff < 0    THEN IncentiveRank = '< 0   ';
        ELSE IF IncentiveDiff < 25   THEN IncentiveRank = '< 25  ';
        ELSE IF IncentiveDiff < 50   THEN IncentiveRank = '< 50  ';
        ELSE IF IncentiveDiff < 75   THEN IncentiveRank = '< 75  ';
        ELSE                             IncentiveRank = '>= 75	 ';
/*As of September 14, 2005, current incentive for 20 year has been calculated using 15-yr rate*/
/*
	IF origterm >= 240 then 
         curInc = 100*(curwac-&c30)-50;
    else curInc = 100*(curwac-&c15)-50;
*/
	IF origterm >= 240 then 
         curInc = 100*(curwac-&c30);
    else curInc = 100*(curwac-&c15);
    IF curInc = . THEN        	   curIncentive = 'missing';
        ELSE IF curInc < -150 THEN curIncentive = '< -150';
        ELSE IF curInc < -125 THEN curIncentive = '< -125';
        ELSE IF curInc < -100 THEN curIncentive = '< -100';
		ELSE IF curInc < -75  THEN curIncentive = '< -75 ';
        ELSE IF curInc < -50  THEN curIncentive = '< -50 ';
    	ELSE IF curInc < -25  then curIncentive = '< -25 ';
    	ELSE IF curInc < 0    then curIncentive = '< 0   ';
   		ELSE IF curInc < 25   then curIncentive = '< 25  ';
   		ELSE IF curInc < 50   then curIncentive = '< 50  ';
   	 	ELSE IF curInc < 75   then curIncentive = '< 75  ';
   	 	ELSE                      curIncentive = '>= 75	 ';
    PDdeflate=PremDiscAmt/1000000;
		IF 	cPFIrank = 'National City Bank Pennsylvania' 				THEN DO; cPFIrankTop = 'National City'; cPFIindex = 1;  END;
		ELSE IF cPFIrank = 'LaSalle National Bank, National Associat' 	THEN DO; cPFIrankTop = 'LaSalle';			cPFIindex = 2;  END;
		ELSE IF cPFIrank = 'Balboa Reinsurance Company' 				THEN DO; cPFIrankTop = 'Balboa';			cPFIindex = 3;  END;
		ELSE IF cPFIrank = 'Superior Guaranty Insurance Company' 		THEN DO; cPFIrankTop = 'Superior';			cPFIindex = 4;  END;
		ELSE IF cPFIrank = 'Associated Bank, National Association' 		THEN DO; cPFIrankTop = 'Associated';		cPFIindex = 5;  END;
		ELSE IF cPFIrank = 'Colonial Savings' 							THEN DO; cPFIrankTop = 'Colonial';			cPFIindex = 6;  END;
		ELSE IF cPFIrank = 'AnchorBank fsb' 							THEN DO; cPFIrankTop = 'AnchorBank';		cPFIindex = 7;  END;
		ELSE IF cPFIrank = 'Washington Mutual Bank' 					THEN DO; cPFIrankTop = 'WaMu';				cPFIindex = 8;  END;
/*		ELSE IF cPFIrank = 'Chase Bank USA, National Association f/k' 	THEN DO; cPFIrankTop = 'Chase';				cPFIindex = 9;  END;
*/		ELSE IF cPFIrank = 'Mid-America' 								THEN DO; cPFIrankTop = 'Mid-America';		cPFIindex = 10; END;
		ELSE									       						 DO; cPFIrankTop = 'Others';			cPFIindex = 11; END;
*    label 
        curWAC='WAGNR'
		BaseSVFee='Base Servicing Fee'
		curWACnetSvFee = 'GNR net of Base Servicing Fee'
        WACRank='GNR rank'
        curWALA='WALA'
        WALArank='WALA Rank'
        lnszrank='Loan Size Rank'
        loanpurposecode='Loan Purpose'
        cpfirank='PFI'
        borrowerincome='Income'
        Incomerank='Monthly Income Rank'
        FICOrank='FICO Score Rank'
        origLTV='Original LTV'
        LTVrank='Original LTV Rank'
        curLTV='Current LTV'
        curLTVrank='Current LTV Rank'
        documentationtype='Documentation Type'
        curbal='Current Balance'
        Incentivediff='Incentive'
        Incentiverank='Incentive Rank'
        curInc='Current Incentive'
        curIncentive='Current Incentive Rank'
		;
RUN;


PROC SQL;
DROP TABLE Ddatasas.SASMaster;
QUIT;


PROC SORT DATA=Ddatasas.SASdata out=Ddatasas.sasmaster; 
    BY cPFIindex ;
run;
quit;

	data Ddatasas.conv30;
		set Ddatasas.sasmaster;
		if loanprogram='Conventional' and origterm='360';
	data Ddatasas.conv20;
		set Ddatasas.sasmaster;
		if loanprogram='Conventional' and origterm='240';
	data Ddatasas.conv15;
		set Ddatasas.sasmaster;
		if loanprogram='Conventional' and origterm='180';
	data Ddatasas.gov30;
		set Ddatasas.sasmaster;
		if loanprogram='Government'   and origterm='360';
	data Ddatasas.gov15;
		set Ddatasas.sasmaster;
		if loanprogram='Government'   and origterm='180';
run;


DATA Ddatasas.sasmasterNew;
	set Ddatasas.sasmaster (where=(PrepayStatus='Outstanding' or PrepayStatus='New Loan' ));
	premdiscamt=premdiscamt;

DATA Ddatasas.sasMSprepaid;
	set Ddatasas.sasmaster (where=(Prepayperiod=&month_n and PrepayStatus='Prepaid'));

DATA Ddatasas.sasmscprs;
	set Ddatasas.sasmaster (where=(Prepayperiod=&month_n OR Prepayperiod Is Null));
	OriginationYear=put(origyear, 4.);
RUN;

