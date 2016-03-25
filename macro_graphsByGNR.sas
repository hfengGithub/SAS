
%macro CPRbyGNR(state=, att1=, attribute1=, index1=, mid1=, ax=);
	AXIS2
	    label=(" &attribute1 ")
	    MINOR=NONE
		/*value=(angle=45)*/;
		;
	AXIS3
	    label=(" &attribute1 ")
	    MINOR=NONE
		split=" "
		;
	
	TITLE "\R/RTF'\s1 '&Month Chicago &labl by &attribute1";
	
	%if &state=1 %then %do;
	proc sql;
	create table t_state as
      	select WACrank, state, sum(ccurBal) as cBal
      	from   &product
      	group  by  WACrank, state
      	order  by cBal desc ;

	proc sql;
	create table t_state1 as
	select WACrank, state, cBal
	from   t_state as s
	where  20=(select count(*) from t_state where cBal>s.cBal );
	group  by  WACrank

	proc sql;
	create view v_state as
	select s.state, s.cBal
	from   t_state s, t_state1 s1
	where  s.cBal>s1.cBal
	union
	select 'OTHERS' AS state, sum(s.cBal) as cBal 
	from   t_state s, t_state1 s1
	where  s.cBal<=s1.cBal;
	RUN;QUIT;

PROC gchart DATA=v_state;
    
    vbar3d &att1 /
    SUMVAR=cBal
    RAXIS=AXIS1 
    MAXIS=&ax
    AUTOREF
    noheading
    G100
    SHAPE=Block
    TYPE=sum
    pct
    COUTLINE=BLACK
    FRAME
    ;
	BY WACrank;
    FORMAT cBal COMMA6.;
RUN;
%end;
%else %do;
PROC gchart DATA=&product;
    
    vbar &att1 /
    SUMVAR=&bal
    RAXIS=AXIS1 
    MAXIS=&AX
    %if &index1=1 %then midpoints=&mid1;
    AUTOREF
    noheading
    G100
    SHAPE=Block
    TYPE=sum
	%If &signal=1 	%then outside=sum;
    				%else pct;
    COUTLINE=BLACK
    FRAME
    ;
    FORMAT cCurBal COMMA6.;
RUN;
%end;
%mend graphs;
