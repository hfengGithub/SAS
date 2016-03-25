LIBNAME d_sas oledb Provider=SQLOLEDB 
		properties = ( 'Initial Catalog' = SAS 'Data Source' = W2KMSTSYD4  'Integrated Security'=SSPI)
		schema=dbo bulkload= yes; 
libname AF oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "H:\SAS\output\AFtemp.xls") 
		provider_string="Excel 8.0";
/*	OrigTerm=case when sm.OrigTerm<180 then 111 when sm.OrigTerm=180 then 180 
			when sm.OrigTerm=240 then 240 when sm.OrigTerm=360 then 360 else 0 end
	Badj=case when sm.BaseAdjustment<>0 then 'yes'
		else 'no' end,
*/
title 'Chicago MPF Current Investment Balance and Net Coupon';
footnote 'Data as of June 1, 2006';

data loanInfo;
set d_sas.loanInfo;
if openBA=. then openBA=0;
run;

data SM;
set d_sas.sasMaster;
if loanProgram='Conventional' then do;
if OrigTerm=180 then OT=' 180  ';
else if OrigTerm=240 then OT=' 240  ';
else if OrigTerm=360 then OT=' 360  ';
else OT='Other';
end;
if loanProgram='Government' then do;
if OrigTerm=180 then OT='180';
else if OrigTerm=360 then OT='360';
else OT='Other';
end;
Badj='no '; if BaseAdjustment~=0 then Badj='yes';
loanNumber=loanIDnumber*1;
keep OT origTerm loanProgram cCurBal BaseAdjustment unAmortizedAF Badj loannumber;
run;
proc sort data=sm;
by loannumber;
run;

proc sql;
drop table temp1;
drop view temp1;
create table temp1 as
select l.coupon, l.CEfee, l.excessSpread, l.ServFee,
	sm.cCurBal, sm.BaseAdjustment,
	sm.unAmortizedAF/1000000 as unAmortizedAF, sm.LoanProgram, sm.OT, sm.Badj,
	(sm.BaseAdjustment-l.openBA)/1000000 as ClosedBA 
from loanInfo l, SM
where l.loannumber=sm.loannumber;
quit;


proc sql;
*--by OrigTerm;
drop table t1;
drop view t1;
create table t1 as
select  loanProgram, OT as OrigTerm, Badj, sum(cCurBal+ClosedBA) as InvBal, sum(unAmortizedAF) as unAmortizedAF, sum(ClosedBA) as ClosedBA, 
	sum(cCurBal*(coupon - CEfee - ExcessSpread - ServFee))/sum(cCurBal) as Rate
from temp1
group by loanProgram, OT, Badj;
quit;


proc sql;
*--total Conv/Gov w/ or w/o Badj;
drop table t2;
drop view t2;
create table t2 as
select  loanProgram, 'All' as OrigTerm, Badj, sum(cCurBal+ClosedBA) as InvBal, sum(unAmortizedAF) as unAmortizedAF, sum(ClosedBA) as ClosedBA, 
	 sum(cCurBal*(coupon - CEfee - ExcessSpread - ServFee))/sum(cCurBal) as Rate 
from temp1
group by loanProgram, Badj;
quit;

proc sql;
*--total MPF;
drop table t3;
drop view t3;
create table t3 as
select  'All' as loanProgram, 'All' as OrigTerm, 'All' as Badj, sum(cCurBal+ClosedBA) as InvBal, sum(unAmortizedAF) as unAmortizedAF, sum(ClosedBA) as ClosedBA, 
	sum(cCurBal*(coupon - CEfee - ExcessSpread - ServFee))/sum(cCurBal) as Rate 
from temp1;
quit;

data AF.sum;
set t1 t2 t3;
run;
ods _all_ close;
ods rtf file='H:\SAS\output\AF_BA.rtf' bodytitle;
proc tabulate;
var invBal unAmortizedAF ClosedBA;
var rate;
class loanProgram OrigTerm Badj;
table 

LoanProgram={label=''}*OrigTerm={label=''},
Badj={label='Basis Adj.'}*(InvBal*sum={label=''}*F=comma9. 
				unAmortizedAF*sum={label=''}*F=comma9. 
				ClosedBA*sum={label=''}*F=comma9. 
				rate*mean={label=''}*F=percent9.2)
;
run;
title;
footnote;

ods rtf close;
ods listing;
LIBNAME d_sas;
libname AF;
