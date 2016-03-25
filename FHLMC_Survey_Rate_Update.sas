*\ create SAS dataset using SAS.dbo.SASMaster *\;
* LIBNAME  IDATASAS  'I:\DATA\SAS';
*\ creates the table SAS.dbo.SASMaster by running the stored procedure SAS_CreateSASTables *\;
*LIBNAME d_sas oledb Provider=MSDASQL.1 properties = ('Data Source'="D3sas");
*LIBNAME d_rpt oledb Provider=MSDASQL.1 properties = ('Data Source'="D3reports");

/*****************************************************/;
/**** FHSurve RATE SECTION ****/;
%Include "H:\SAS\code\prepayment\properties.sas";

	/* Import FH Survey Rate from CPRCPR Excel file;
	libname FHSurvey oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "H:\MPF\prepayRpt\data\CPRCDDR_FHSurveyRates.xls") 
		provider_string="Excel 8.0";
*/

	DATA dDATASAS.FHSurveyRate;
		SET FHSurvey.'Sheet1$'n;
		Date = DATEPART(Date);
		Month= Month(Date);
		Year = Year(Date);
		YYMM = 01|Month|Year|
		FRM30adj = FRM30 + FRM30pt *0.25;
		FRM15adj = FRM15 + FRM15pt *0.25;
		Format Date MMDDYY8.;
	RUN;

PROC SORT DATA = dDATASAS.FHSurveyRate;	
	By Date;
run;

	/* create SQL table with weekly survey rate*/;
	PROC SQL;
	DROP TABLE d_sas.FHSurveyRate;

	DATA d_sas.FHSurveyRate;
	SET dDATASAS.FHSurveyRate;
	run;
	/* FHSurveyRate FROM WEEKLY TO MONTHLY */
	/* 30 year */;
	PROC MEANS DATA=dDATASAS.fhsurveyrate 
	    FW=12
	    /*PRINTALLTYPES*/
		NOPRINT
		CHARTYPE
	    NWAY
	    VARDEF=DF
	    MEAN
		Min
		Max

	;
	VAR FRM30; 
	CLASS Year / ORDER=UNFORMATTED;
	CLASS Month / ORDER=UNFORMATTED;
	OUTPUT OUT=dDATASAS.FHSurveyRate30yr(LABEL="Summary statistics for ECLIB000.fhsurveyrate")
	    MEAN()=
	/ AUTONAME AUTOLABEL  WAYS INHERIT;
	RUN;

	PROC SORT DATA = dDATASAS.FHSurveyRate30yr;	
	By Year Month;
run;

	/* The INCENTIVE (FRM_Incentive) is defined as the average of the prior two months with no adjustments for points*/;
	DATA dDATASAS.FHSurveyRate30yr;
		SET dDATASAS.FHSurveyRate30yr;
		OrigTerm=360;
		MtgeRate=FRM30_Mean;
		MtgeRateL1=Lag(FRM30_Mean);
		MtgeRateL2=Lag2(FRM30_Mean);
		MtgeRateL3=Lag3(FRM30_Mean);
		FRM_incentive= (Lag(FRM30_Mean)+Lag2(FRM30_Mean))/2;
		AFTincentive= (Lag(FRM30_Mean)*.25+Lag2(FRM30_Mean)*.75);
 	RUN;

	/* 15 year */
	PROC MEANS DATA=dDATASAS.fhsurveyrate 
	    FW=12
	    /*PRINTALLTYPES*/
		NOPRINT
		CHARTYPE
	    NWAY
	    VARDEF=DF
	    MEAN
		Min
		Max
	    ;
	VAR FRM15; 
	CLASS Year / ORDER=UNFORMATTED;
	CLASS Month / ORDER=UNFORMATTED;
	OUTPUT OUT=dDATASAS.FHSurveyRate15yr(LABEL="Summary statistics for ECLIB000.fhsurveyrate")
	    MEAN()=
	    / AUTONAME AUTOLABEL  WAYS INHERIT;
	RUN;

		PROC SORT DATA = dDATASAS.FHSurveyRate15yr;	
		By Year Month;

	/* The INCENTIVE (FRM_Incentive) is defined as the average of the prior two months with no adjustments for points*/;
	DATA dDATASAS.FHSurveyRate15yr;
		SET dDATASAS.FHSurveyRate15yr;
		OrigTerm=180;
		MtgeRate=FRM15_Mean;
		MtgeRateL1=Lag(FRM15_Mean);
		MtgeRateL2=Lag2(FRM15_Mean);
		MtgeRateL3=Lag3(FRM15_Mean);
		FRM_incentive= (Lag(FRM15_Mean)+Lag2(FRM15_Mean))/2;
		AFTincentive= (Lag(FRM15_Mean)*.25+Lag2(FRM15_Mean)*.75);
		
 	RUN;
	
	DATA dDATASAS.FHSurveyRateMO;
		SET dDATASAS.FHSurveyRate15yr dDATASAS.FHSurveyRate30yr;
	RUN;

	/* CREATE SQL TABLE WITH SURVEY RATES */;
	PROC SQL;
		DROP TABLE d_sas.FHSurveyRateMO;
	DATA  d_sas.FHSurveyRateMO;
	 	set dDATASAS.FHSurveyRateMO;
	RUN;

*libname FHSurvey;
