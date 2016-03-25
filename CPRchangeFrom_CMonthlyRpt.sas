libname dData 'D:\data';
libname Report oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "I:\Workspaces\MonthlyReport\week3_flash\dbo_rpt_UV_cMonthlyRpt.xls") 
		provider_string="Excel 8.0";
/**/

libname Report2 oledb
		provider="Microsoft.Jet.OLEDB.4.0"
		preserve_tab_names=Yes
		preserve_col_names=Yes
		properties = ('data source'= "I:\Workspaces\MonthlyReport\week3_flash\temp.xls") 
		provider_string="Excel 8.0";

data temp;
set report.'dbo_rpt_UV_cMonthlyRpt$'n;
run;

data MPF;
SET TEMP;
if mr_servicerName = 'MPF' AND MR_CURRENTBAL>=500;
RUN;

data FNMA;
SET TEMP;
if mr_servicerName = 'FNMA';
RUN;

data GNMA;
SET TEMP;
if mr_servicerName= 'GNMA II';
RUN;

proc sql;
create table query1 as
select fnma.*
from mpf, fnma
where mpf.MR_ORIGTERM=fnma.MR_ORIGTERM
and mpf.MR_GROSSCOUPONINT=fnma.MR_GROSSCOUPONINT
and mpf.MR_ORIGYEAR=fnma.MR_ORIGYEAR
and mpf.mr_loanprogram='Conventional';
quit;
run;

proc sql;
create table query2 as
select gnma.* 
from mpf, gnma
where mpf.MR_ORIGTERM=gnma.MR_ORIGTERM
and mpf.MR_GROSSCOUPONINT=gnma.MR_GROSSCOUPONINT
and mpf.MR_ORIGYEAR=gnma.MR_ORIGYEAR
and mpf.mr_loanprogram='Government';
quit;
run;
data final;
set query1 query2 mpf;
run;
/**/
proc sql;
drop table report2.QUERYdata1;
run;

DATA report2.QUERYdata1;
set final;
CPR1month=mr_cpr1month;
CPR1p1=mr_CPR1p1;
CPR1c1=CPR1month-CPR1p1;
loanprogram=mr_loanprogram;
origterm=mr_origterm;
origyear=mr_origyear;
grossCouponInt=mr_grossCouponInt;
agency=mr_agency;
CURRENTBAL=MR_CURRENTBAL;
keep CPR1month CPR1p1 CPR1c1 loanprogram origterm origyear grossCouponInt agency CURRENTBAL;
*drop 
mr_cpr1month mr_CPR1p1 mr_loanprogram mr_origterm 
mr_origyear mr_grossCouponInt mr_agency;
run;
libname report;
libname report2;
