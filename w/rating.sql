

-- -------------------------------------
-- RATING for free vols
-- -------------------------------------
--reset
drop temporary table if exists xusg;
update susg set fl2=null,unit=null,rt=null, cg0=null;

-- 1. set the block charge and rate
update susg set unit = ceil(uv0/60.00)                    where kls like '%V';
update susg set                           cg0 = unit*0.16 where kls in ("HNV","HSV");
update susg set                           cg0 = cg1       where kls in ("HIV","HIS");
update susg set unit = ceil(uv0/1024.00), cg0 = unit*0.03 where kls = "HND";
update susg set unit = uv0,               cg0 = unit*0.08 where kls in ("HNS","HSS");
update susg set unit = 1,                 cg0 = cg1       where kls in ("%M");

-- rate the records first

-- voice free 100min
-- create the running total for free vol
drop temporary table if exists xusg;
create temporary table xusg
select tid,ano,kls,sdt,uv0,unit,
(select sum(unit) from susg b
 where a.ano = b.ano
 and   b.kls = "HNV"
 and   a.sdt >= b.sdt
 group by a.ano, a.kls, a.sdt
 order by a.ano,a.kls,a.sdt
) rt
from susg a
where a.kls = "HNV"
order by a.ano,a.kls,a.sdt
;

-- sms free 100 msg
insert into xusg
select tid,ano,kls,sdt,uv0,unit,
(select sum(unit) from susg b
 where a.ano = b.ano
 and   a.sdt >= b.sdt
 and   b.kls = "HNS"
 group by a.ano, a.kls
) rt
from susg a
where a.kls = "HNS"
order by a.ano,a.kls,a.sdt
;

-- data free 5GB
insert into xusg
select tid,ano,kls,sdt,uv0,unit,
(select sum(unit) from susg b
 where a.ano = b.ano
 and   a.sdt >= b.sdt
 and   b.kls = "HND"
 group by a.ano, a.kls
) rt
from susg a
where a.kls = "HND"
order by a.ano,a.kls,a.sdt
;

-- set the running totals
update susg a, xusg b set a.rt = b.rt 
where a.tid = b.tid;

-- update is usage
update susg set  fl2 = 1, cg0 = case when rt <= 100 then 0 else cg0 end 
where  kls in ('HNV','HNS') and rt is not null;

update susg set  fl2 = 1, cg0 = case when rt <= 5120 then 0 else cg0 end 
where  kls="HND" and rt is not null;



-- -------------------------------------
-- do recurring
-- -------------------------------------
-- to check seems like will be producing runaway nulti row retrieval on more plans
insert into adocd 
 select 
 null,null
 ,a.acc,a.sno
 ,'1608'
 ,d.chg,0.000
 ,d.des
 ,b.pln,c.cgc,null
 ,null,null,null
 from ssub a 
 inner join spln b on a.sno = b.sno
 inner join rplnchg c on b.pln = c.pln
 inner join rchg d on c.cgc = d.cgc
; 

-- summarize usage

select
null,null
,(select acc from ssub where sno = a.ano), a.ano
,'1608'
,sum(a.cg0)
,case a.kls
 when "HNV" then "Tune Calls"
 when "HSV" then "Other Network Calls"
 when "HIV" then "IDD Calls"
 when "HNS" then "Tune SMS"
 when "HSS" then "Other Network SMS"
 when "HIS" then "International SMS"
 when "HNM" then "MMS"
 when "HND" then "Internet Data"
 when "VIV" then "International Roaming Calls"
 when "VSV" then "International Roaming Received Calls"
 when "VIS" then "International Roaming SMS"
 when "VIM" then "International Roaming MMS"
 when "VID" then "International Roaming Data"
 end
,a.kls,a.kls,null
, null,null,null
from a.susg a group by a.ano,a.kls;
