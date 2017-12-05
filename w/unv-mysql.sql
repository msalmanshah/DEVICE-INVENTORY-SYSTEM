
-- --------------------------------
-- unv mysql schema
-- --------------------------------

-- Plans
-- ---------------
-- id
-- desc
-- kls
-- unit
-- blk
-- rate
-- freecycle
-- freeunits
-- freechg
-- freedays
-- freesvc



create table acc(
 id bigint auto_increment not null
,ac varchar(50)
,nm varchar(100)
,ad varchar(200)
,st tinyint     -- status 
,se datetime    -- effective date
,sx datetime    -- expiry date
,xd datetime    -- time stamp
,xy varchar(50) -- stamped by
,xa varchar(50) -- stmped at
,constraint primary key (id)
);


create table cacc (
 tid bigint auto_increment not null
,acc varchar(50)
,nme varchar(100)
,adr varchar(255)
,ad2 varchar(255)
,ad3 varchar(255)
,ads varchar(255)  
-- allow embedded newlines
,zip varchar(20)
,eml varchar(100)  
-- email
,idt char(3)       
-- KPT, OIC, PPT, COY
,idn varchar(100)
,sta tinyint     
-- status 
,sef datetime    
-- effective date
,sxp datetime    
-- expiry date
,xdt datetime    
-- time stamp
,xby varchar(50) 
-- stamped by
,xat varchar(50) 
-- stamped at
,constraint primary key (tid)
);


create table ssno( 
 tid bigint auto_increment not null
-- service no
,sno varchar(20) 
-- account
,acc varchar(50) 
-- imsi
,sim varchar(20) 
-- stat --------------
-- status 
,sta tinyint     
-- effective date
,sef datetime    
-- expiry date
,sxp datetime    
-- stamps ------------
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);

create table ssub( 
 tid bigint auto_increment not null
-- service no
,sno varchar(20) 
-- subscriber name
,nme varchar(100)
-- account
,acc varchar(50) 
-- imsi
,sim varchar(20) 
-- stat --------------
-- status 
,sta tinyint     
-- effective date
,sef datetime    
-- expiry date
,sxp datetime    
-- stamps ------------
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);

-- status
-- . . . .
-- 0 0 0 0  not active  0
-- 0 0 0 1  active      1
-- 0 1 x x  suspended   >= 4
-- 1 x x x  terminated  >= 8


create table aglt(
 tid bigint auto_increment not null
,txd datetime
-- transaction type
,txp varchar(5)
,tpd varchar(20)
,acc varchar(50)
,rf1 varchar(50)
,rf2 varchar(50)
,rf3 varchar(50)
,nrr varchar(255)
,tdr decimal(12,3)
,tcr decimal(12,3)
,xdr decimal(12,3)
,xcr decimal(12,3)
-- stamps ------------
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);


create table rpln (
 tid bigint auto_increment not null
,pln varchar(50)
,des varchar(100)
-- stat --------------
-- status 
,sta tinyint     
-- effective date
,sef datetime    
-- expiry date
,sxp datetime    
-- stamps ------------
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);

insert into rpln values
 (null,'std01','Standard Plan',1,'2016-09-01',null,now(),'sys','@')
,(null,'vip01','VIP Plan',1,'2016-09-01',null,now(),'sys','@')
;

create table spln (
 tid bigint auto_increment not null
,sno varchar(20) 
,acc varchar(50) 
,pln varchar(50)
-- status 
,sta tinyint     
-- effective date
,sef datetime    
-- expiry date
,sxp datetime    
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);

-- accumulators in z section
create table zacc (i serial not null auto_increment, primary key(i));

-- accserial from zacc
DROP FUNCTION IF EXISTS accserial;
DELIMITER //
CREATE FUNCTION accserial () RETURNS varchar(20)
  BEGIN
    insert into zacc values (null);
    set @i = LAST_INSERT_ID();
    return (select lpad(@i,10,0));
  END //
DELIMITER ;

create table sccr (
 tid bigint auto_increment not null
,sno varchar(20) 
,acc varchar(50)
-- credit class 
,kls tinyint 
,dep decimal(10,3)
,grn decimal(10,3)
,tcl decimal(10,3)
-- status 
,sta tinyint     
-- effective date
,sef datetime    
-- expiry date
,sxp datetime    
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);


create table bctl (
 pdr varchar(20) not null
,grp tinyint not null
,sta tinyint
,pds datetime
,due datetime
,gen datetime
,pst datetime
,inv datetime
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (pdr,grp)
);



-- transaction details
-- create table atrx(
--  tid bigint auto_increment not null
-- 
-- );

-- document table 
create table adoc(
 did bigint auto_increment not null
-- batch number
,bat varchar(50)
-- document number
,dno varchar(50)
-- document date
,ddt datetime
-- document type INV,REC,DRN,CRN,ADJ
,dtp varchar(5)
-- document mode RECs mode -- CSH,CHQ,TTR,IBT,GRO  --- INVs mode = DOC 
,dmd varchar(5)
-- period reference
,pdr varchar(20)
-- debit/credit
,ddr decimal(12,3)
,dcr decimal(12,3)
-- reference accounts and subaccounts
,acc varchar(50)
,sub varchar(50)
,rf1 varchar(50)
,rf2 varchar(50)
,rf3 varchar(50)
-- narration
,nrr varchar(255)
-- flags with stamps
,f0l tinyint
,f0d datetime    
,f0y varchar(50) 
,f0a varchar(50) 
,f1l tinyint
,f1d datetime    
,f1y varchar(50) 
,f1a varchar(50) 
,f2l tinyint
,f2d datetime    
,f2y varchar(50) 
,f2a varchar(50) 
,f3l tinyint
,f3d datetime    
,f3y varchar(50) 
,f3a varchar(50) 
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (did)
);

CREATE INDEX adocx1
ON adoc (dno);

-- document detail 
create table adocd (
 tid bigint auto_increment not null
,dno varchar(50)
,acc varchar(50)
,sub varchar(20)
,pdr varchar(20)
,ddr decimal(12,3)
,dcr decimal(12,3)
,nrr varchar(255)
-- time stamp
,xdt datetime    
-- stamped by
,xby varchar(50) 
-- stamped at
,xat varchar(50) 
,constraint primary key (tid)
);

-- CREATE TABLE rusg (
--  uid varchar(20) 
-- ,aid varchar(20)
-- ,kls varchar(20)
-- ,des varchar(100) 
-- ,zon int(11) 
-- -- zon ident script
-- ,zsc varchar(255) 
-- -- priority to consume within class
-- ,pri tinyint(4) 
-- ,unt char(1) 
-- ,rte decimal(10,3) 
-- ,rsc varchar(255)
-- -- free cycle 
-- ,fcy char(1) 
-- -- free charge
-- ,fcg decimal(12,3)
-- -- free units 
-- ,fut decimal(12,3)
-- -- which services (script) 
-- ,fsv varchar(100) 
-- -- threshold actions (script)
-- ,hsc varchar(255) 
-- ,rll char(1) 
-- ,rmx decimal(10,3) 
-- -- time stamp
-- ,xdt datetime    
-- -- stamped by
-- ,xby varchar(50) 
-- -- stamped at
-- ,xat varchar(50) 
-- );

create table susg (
 tid bigint auto_increment not null
-- usage class  VCE,SMS,MMS,DTA,PCP(Premium content)
--   prefixed by HLR type H, V (roaming)
--   ie HVCE - local voice,  VSMS - roaming sms, HDTA - local data
,kls varchar(20)
-- date time of usage record
,sdt datetime
,edt datetime
-- usage period (P)eak, (O)ff-peak, ...
,upd varchar(20)
-- ,acc varchar(50)
,ano varchar(20)
,bno varchar(20)
,opr varchar(20)
,geo varchar(20)
-- volume is Voice duration, Data Volume, Event counts 
,uv0 decimal(12,3)
-- secondary vols like session duration etc
,uv1 decimal(12,3)
,uv2 decimal(12,3)
-- charged amount postpaid
,cg0 decimal(12,3)
-- secondary charging units like from prepaid pcrf
,cg1 decimal(12,3)
,cg2 decimal(12,3)
-- record status 0-unbilled, 1-billgen, 3-posted
,sta tinyint
-- GL code
,glc varchar(50)
-- vlr id 
,rf0 varchar(20)
-- cell id 
,rf1 varchar(20)
,rf2 varchar(20)
-- onnet flag
,fl0 tinyint
,fl1 tinyint
,fl2 tinyint
,primary key (tid)
);



create table aglc (
 glc varchar(50) not null
,rf1 varchar(50)
,rf2 varchar(50)
,rf3 varchar(50)
,des varchar(100)
,primary key (glc)
); 



