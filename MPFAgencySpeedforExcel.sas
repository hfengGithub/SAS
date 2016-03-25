LIBNAME  IDATASAS  'I:\workspaces\monthlyreport\history\200505';
libname FH oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "I:\workspaces\monthlyreport\history\200505\temp.xls") 
		provider_string="Excel 8.0";

DATA temp1;
	SET FH.'S1$'n;
		if mr_ServicerName in ('MPF', 'FNMA', 'GNMA II');
		agency		=mr_agency;
		loanProgram	=mr_LoanProgram;
		OrigYear	=mr_OrigYear;
		OrigTerm	=mr_OrigTerm;
		GrossCoupon	=mr_GrossCoupon;
		GrossCouponInt	=mr_GrossCouponInt;
		OrigBal		=mr_OrigBal;
		CurrentBal	=mr_CurrentBal;
		CPR1Month	=mr_CPR1Month;
		cpr1p1		=mr_cpr1p1;
		CPRC1		=(CPR1Month-cpr1p1);
		CPR1C1perc	=100*(CPR1Month-cpr1p1)/cpr1p1;
		CPR3Month	=mr_CPR3Month;
		CPR6Month	=mr_CPR6Month;
		CPR12Month	=mr_CPR12Month;
		keep agency	loanProgram	OrigYear	OrigTerm	GrossCoupon	GrossCouponInt
		OrigBal		CurrentBal	CPR1Month	cpr1p1	CPRC1	CPR1C1perc	
		CPR3Month	CPR6Month	CPR12Month	;

proc sort;
	by loanProgram descending OrigYear descending OrigTerm descending GrossCouponInt descending Agency ;

data temp2;
set temp1;
retain f1 f2 f3 f4;
if CurrentBal<450 then do;
f1= loanProgram ;
f2= OrigYear  ;
f3= OrigTerm  ;
f4= GrossCouponInt;
end;
/**/
if f1= loanProgram and f2= OrigYear  and f3= OrigTerm and f4= GrossCouponInt then delete;
run;

data temp0;
set temp2;
drop f1--f4;
proc sort;
		by loanProgram descending OrigYear descending OrigTerm Agency descending GrossCouponInt ;
