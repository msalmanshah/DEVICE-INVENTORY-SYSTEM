package com.disb

import groovy.sql.*
import groovy.json.*
import static groovy.json.JsonParserType.LAX as RELAX
import org.springframework.core.io.*
import org.springframework.http.*
//import org.springframework.http.ResponseEntity<T>
import org.springframework.beans.factory.annotation.Value
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RestController
import org.springframework.jdbc.core.JdbcTemplate;
import java.io.InputStream;
import java.util.Base64;
import java.util.Base64.Decoder;


@RestController
class Abc {

	//def db = [url:'jdbc:mysql://localhost:3306/k7', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
	def db = [url:'jdbc:mysql://localhost:3306/unv', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
	def sql = Sql.newInstance(db.url, db.user, db.password, db.driver)
  def setprov=0
  def curdb = 'unv'

	@RequestMapping("/apix/yo")
	@ResponseBody
	def yo() {
	  sql.rows("select 1")
	}

  @RequestMapping("/api/getcfg")
  @ResponseBody
  def setprov() {
    "prov set to "+setprov+", db set to"+curdb
  }


	@RequestMapping("/do")
	def doit(@RequestBody String s) {
		//def o = new JsonSlurper()
		def m = new JsonSlurper().setType(JsonParserType.LAX).parseText(s)
		//sql.execute "insert into z (a,b) values ($m.a, $m.b)"
		//sql.execute "insert into z (a,b) values ($m.a, $m.b)"
		m
	}

	@RequestMapping("/api/mvsub")
	def mvsub(@RequestBody String s) {
		def rs = [id:"NONE", name:"NO REFS"]
		//def o = new JsonSlurper()
		def m = new JsonSlurper().setType(RELAX).parseText(s)
		rs = sql.rows("select accserial() as id")
		def id = rs[0].id
		/**/
		def dt = new Date()
		def d1 = dt.format('yyMMddHHmmss')
		def d2 = dt.format('yyyy-MM-dd HH:mm:ss')
    def dpln = '79'
    if (m.pln ==~ /(i?)vip/) { 
      dpln = '81' 
    } 
    def bdl = "$dpln,1109,PostpaidSMSBundle,PostpaidMMSBundle"
		sql.execute "insert into cacc values (null,$id,$m.acn,$m.adr,$m.ad2,$m.ad3,$m.ads,$m.zip,null,null,$m.idn,1,$d2,null,now(),'test','@')"
		sql.execute "insert into ssub values (null,$m.sno,$m.sub,$id,$m.sim,1,$d2,null,now(),'test','@',$m.rf1,null,null)"
		sql.execute "insert into spln values (null,$m.sno,$id,$m.pln,1,$d2,null,now(),'test','@')"
    sql.execute "insert into adp (acc, sub, dcr) values ($id, $m.sno, $m.dep)"
    sql.execute "insert into sccr (sno, acc, kls, dep, tcl, sef, sta) values ($m.sno, $id, $m.kls, $m.dep, $m.dep, null, 1)"
		
		def h = "http://203.82.85.195/~svc/cgi-bin/switch.cgi?phonenumber="+m.sno+"&txid="+id+m.sno+"&bundle="+bdl+"&dep="+m.dep

    if (setprov) {
		  def t = h.toURL().text
    }
		["res":1]
	}

  @RequestMapping("/api/cctl/{v}")
  @ResponseBody
  def cctl(@PathVariable v) {
    sql.rows("select *,(select sta from ssub where sno = :crit) as st from sccr where sno = :crit", [crit:v])
   
  }

  @RequestMapping("/api/cctlchk/ovr")
  @ResponseBody
  def cctlchk() {

    def rs = sql.rows("select sno,ost,unb from sccr where ost+unb > tcl");
    rs.each { zz ->
      def dt = new Date()
      def d1 = dt.format('yyMMddHHmmss')
      def d2 = dt.format('yyyy-MM-dd HH:mm:ss')
      def h = "http://203.82.85.195/~svc/cgi-bin/barr.cgi?txid="+zz.ano+d2+"&phonenumber="+zz.ano+"&stype=0"
      sql.execute "update ssub set sta = sta | 4 where sno = '"+zz.ano+"'" 
      if (setprov) {
        def t = h.toURL().text
      }

    }
    ["res":1]
  }

	@RequestMapping("/apiz/yea")
	@ResponseBody
	String yea() {
		"Oh yea!"
	}

	@RequestMapping("/apiz/yeah")
	@ResponseBody
	def yeah() {
		def qh = [a:"1",b:"2"]
		def z = [a:"1", q:qh]
		def y = "[y:\"1\"]"
		z = Eval.me(y)
		z
	}

  @RequestMapping("/api/setprov/{prv}")
  @ResponseBody
  def setprov(@PathVariable prv ) {
    setprov = prv
    "prov set to "+prv
  }

	@RequestMapping("/api/bills/{acc}")
	@ResponseBody
	def bills(@PathVariable acc ) {
	  sql.rows("select dno,ddt,ddr+dcr as amt,pdr,acc from adoc where dtp='INV' and  acc = (select acc from ssub where sno = :crit) order by ddt desc",[crit: acc])
	}

	@RequestMapping("/api/ttsa/a/{sn}")
	@ResponseBody
	def attsa(@PathVariable sn) {
		def z = [a:"1",b:"2"]
		def t = "./f.pl ${sn}".execute().text
		z = Eval.me(t)
		z
	}

	@RequestMapping("/api/ttsa/prov/{prv}/{sn}")
	@ResponseBody
	def ttsap(@PathVariable prv, @PathVariable sn) {
    def dt = new Date()
		def h = "http://203.82.85.195/~svc/cgi-bin/"+prv+".cgi?phonenumber="+sn+"&txid="+sn+dt+"&stype=0"
		//def t = h.toURL().text
		//t

    if (setprov){
      def t = h.toURL().text
    }
	}

	@RequestMapping("/api/ttsa/prov/ccmsg/{prv}/{sn}/{txs}")
	@ResponseBody
	def attsc(@PathVariable prv, @PathVariable sn, @PathVariable txs) {
		def h = "http://203.82.85.195/~svc/cgi-bin/ccontrolmsg.cgi?phonenumber="+sn+"&txid="+txs+"param="+prv
		def t = h.toURL().text
		t
	}

	@RequestMapping("/api/refs/{ref}")
	@ResponseBody
	def refs(@PathVariable ref) {

		//def m = v =~ /^s@([0-9]+)$/;
		def rs = [id:"NONE", name:"NO REFS"]
		def qs = "nil"

		if (ref == "plans") {
			qs = "select pln as id, concat(pln, ' | ', des) as name from rpln where sta = 1"
			rs = sql.rows(qs)
		} 
	}

	// one, two, tre, for, fiv, six, svn, eit, nin, ten
	@RequestMapping("/api/look/{fz}/{v}")
	@ResponseBody
	def res2a(@PathVariable fz, @PathVariable v) {
		def av = "nil"
		def qs = "aa"
		def qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		def rs = [a:1, b:2]

		def m = v =~ /^s@([0-9]+)$/;

		if ((m = v =~ /^s@([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.sib as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where sim like :crit order by sim,sno"
			qh = [one:"IMSI",two:"SNO",tre:"Subscriber"]
		} else if ((m = v =~ /^([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where sno like :crit order by sno"
			qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		} else if ((m = v =~ /^a@([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where acc like :crit order by acc,sno"
			qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		} else if (v=="" || v ==~  /(?i)^all$/ ) {
			qs = "select ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub order by sno,acc"
			qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		} else {
			av = "%" + v + "%";
			qs = "select ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.ac=cacc.acc) as tre from ssub where acc in (select acc from cacc where nme like :crit) order by tre,sno"
			qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		}

		av = av.toUpperCase()

		if (fz == "4") {
			rs = (v.toUpperCase() == 'ALL') ? sql.rows(qs) : sql.rows(qs, [crit: av])
			def sz = rs.size()
			["hd":qh, "rs": rs, "sz": sz]
		} else if (fz == "t") {
			["qs": qs, "av": av]
		} else {
			[rs: "?"]
		}
	}

	@RequestMapping("/api/lk/{v}")
	@ResponseBody
	def resn2z(@PathVariable v) {
		def av = "nil"
		def m = v =~ /^s@([0-9]+)$/;
		if ((m = v =~ /^6?0?(11?[02-9])*([0-9_]{7})$/)) {
			def z = m[0][1] ? m[0][1] :'10'
			av = '0'+z+m[0][2]
		}
		av
	}

	// one, two, tre, for, fiv, six, svn, eit, nin, ten
	@RequestMapping("/api/nlook/{fz}/{v}")
	@ResponseBody
	def resn2a(@PathVariable fz, @PathVariable v) {
		def av = "nil"
		def qs = "aa"
		def qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		def rs = [a:1, b:2]

		def m = v =~ /^s@([0-9]+)$/;

		if ((m = v =~ /^i-([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.sno as ky, ssub.sim as one,ssub.sno as two, (select nme from cacc where cacc.acc=ssub.acc) as tre from ssub where sim like :crit order by sim,sno"
			qh = [one:"IMSI",two:"SNO",tre:"Acc Name"]
			//qs = "select sno.si as one, sno.sn as two, (select nm from acc where sno.ac=acc.ac) as tre from sno where si like :crit order by si,sn"
			//qh = [one:"IMSI",two:"SNO",tre:"Subscriber"]
		} else if ((m = v =~ /^6?0?(11?[02-9])*([0-9_]{7})$/)) {
			def z = m[0][1] ? m[0][1] :'10'
			av = '0'+z+m[0][2]
			qs = "select ssub.sno as ky, ssub.sno as one, ssub.nme as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where sno like :crit order by sno"
			qh = [one:"SNO",two:"Subscriber",tre:"Acc Name"]
/*
		} else if ((m = v =~ /^([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.sno as ky, ssub.sno as one, ssub.nme as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where sno like :crit order by sno"
			qh = [one:"SNO",two:"Subscriber",tre:"Acc Name"]
			//qs = "select sno.ac as one, sno.sn as two, (select nm from acc where sno.ac=acc.ac) as tre from sno where sn like :crit order by sn"
			//qh = [one:"Account",two:"SNO",tre:"Subscriber"]
*/
		} else if ((m = v =~ /^a-([0-9_]+)$/)) {
			av = "%" + m[0][1];
			qs = "select ssub.sno as ky, ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where acc like :crit order by sno"
			qh = [one:"Account",two:"SNO",tre:"Acc Name"]
			//qs = "select sno.ac as one, sno.sn as two, (select nm from acc where sno.ac=acc.ac) as tre from sno where ac like :crit order by ac,sn"
			//qh = [one:"Account",two:"SNO",tre:"Subscriber"]
		} else if ((m = v =~ /^s-([0-9_A-Za-z]+)$/)) {
			av = "%" + m[0][1] + "%";
			qs = "select ssub.sno as ky, ssub.sno as one, ssub.nme as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where nme like :crit order by tre,sno"
			qh = [one:"SNO",two:"Subscriber",tre:"Acc Name"]
		} else if (v=="" || v ==~  /(?i)^all$/ ) {
			qs = "select ssub.sno as ky, ssub.acc as one, ssub.sno as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub"
			qh = [one:"Account",two:"SNO",tre:"Acc Name"]
		} else {
			av = "%" + v + "%";
			qs = "select ssub.sno as ky, cacc.nme as one, ssub.acc as two, ssub.sno as tre from ssub,cacc  where cacc.acc=ssub.acc and cacc.nme like :crit order by tre,sno"
			qh = [one:"Account Name",two:"Account",tre:"SNO"]
		}

		av = av.toUpperCase()

		if (fz == "4") {
			rs = (v.toUpperCase() == 'ALL') ? sql.rows(qs) : sql.rows(qs, [crit: av])
			def sz = rs.size()
			["hd":qh, "rs": rs, "sz": sz]
		} else if (fz == "t") {
			["qs": qs, "av": av]
		} else {
			[rs: "?"]
		}
	}


	@RequestMapping("/api/showsub/{v}")
	@ResponseBody
	def res2b(@PathVariable v) {

		sql.rows("select ac,sn,si,st,(select nm from acc where sno.ac = acc.ac) as nm, (select coalesce(ad,' ') from acc where sno.ac = acc.ac) as ad from sno where sn like :crit", [crit:v]);
	}

	@RequestMapping("/api/nshowsub/{v}")
	@ResponseBody
	def resn2b(@PathVariable v) {

		sql.rows("select a.acc,a.sno,a.sim,a.nme,b.nme as acn,a.sta,b.idn,b.sta as acs,b.adr,b.ad2,b.ad3,b.zip,b.ads,(select des from rpln where rpln.pln in (select pln from spln where spln.sno = a.sno)) as plndes, (select pln from spln where spln.sno = a.sno) as pln, (select sum(ddr - dcr) from adoc where acc = b.acc) as ost from ssub a,cacc b where a.acc=b.acc and a.sno like :crit", [crit:v]);
	}

  @RequestMapping("/api/sublist")
  @ResponseBody
  def sublist() {
    sql.rows("select sno from ssub");
  }

	// by feira

    @RequestMapping("api/billing/{fz}/{v}")
    @ResponseBody
    def resBill(@PathVariable fz, @PathVariable v) {
      def av = "nil"
      def qs = "aa"
      def qh = [one:"PDR", two:"STA", tre:"PDS"]
      def rs = [a:1, b:2]


      qs = "select bctl.pdr as one, bctl.sta as two, bctl.pds as tre from bctl"
      qh = [one:"PERIOD REF", two:"STATUS", tre:"DATE"]


      av = av.toUpperCase()

      if(fz == "4") {
        rs = (v.toUpperCase() == "ALL") ? sql.rows(qs) : sql.rows(qs, [crit: av])
        def sz = rs.size()
        ["hd":qh, "rs":rs, "sz":sz]
      } else {
        [rs:"?"]
      }   
    }   

    @RequestMapping("api/billingshow/{v}")
    @ResponseBody
    def resBillShow(@PathVariable v) {
      sql.rows("select pdr, sta, grp, pds, xdt, due, inv, (select pdr from bmsg where pdr = :crit) as pdrno, (select msgtext from bmsg where bmsg.pdr like :crit) as msgt, (select msgimg from bmsg where pdr = :crit) as msgi from bctl where pdr like :crit", [crit:v]);
    }   

    @RequestMapping("api/plan/{fz}/{v}")
    @ResponseBody
    def resPlan(@PathVariable fz, @PathVariable v) {
      def av = "nil"
      def qs = "aa"
      def qh = [one:"ID", two:"PLN", tre:"DES"]
      def rs = [a:1, b:2]

      qs = "select rpln.tid as one, rpln.pln as two, rpln.des as tre from rpln";
      qh = [one:"ID", two:"PLAN", tre:"PLAN DESCRIPTION"]

      av = av.toUpperCase()

      if(fz == "4") {
        rs = (v.toUpperCase() == "ALL") ? sql.rows(qs) : sql.rows(qs, [crit: av])
        def sz = rs.size()
        ["hd":qh, "rs":rs, "sz":sz]
      } else {
        [rs:"?"]
      }
    }

/*      ------------  CHANGE DATABASE  ------------      */

    @RequestMapping("api/setdb/{v}")
    @ResponseBody
    def setdb(@PathVariable v) {
      sql.close();
      curdb=v
      db = [url:'jdbc:mysql://localhost:3306/'+v, user:'root', password:'', driver:'com.mysql.jdbc.Driver']
      sql = Sql.newInstance(db.url, db.user, db.password, db.driver)
      "set db to " + v;
    }

/*      ------------  BILL MESSAGE BY FEIRA ------------      */

        @RequestMapping("/api/mvmsg")
        def mvmsg(@RequestBody String s) {
          def m = new JsonSlurper().setType(RELAX).parseText(s)
          sql.executeUpdate "update bmsg set msgtext = $m.msg where pdr = $m.pdr";
        }       

        @RequestMapping("/api/inmsg")
        def inmsg(@RequestBody String s) {
          def m = new JsonSlurper().setType(RELAX).parseText(s)
          sql.execute "insert into bmsg (pdr, msgtext) values ($m.pdr, $m.msg)";
        }

        @RequestMapping("/api/getPmsg/{v}")
        @ResponseBody
        def getpmsg(@PathVariable v) {
          sql.rows("select msgtext from bmsg where pdr = (:crit - 1)", [crit:v]);
        }

        @RequestMapping("/api/upimg")
        def inimg(@RequestBody String s) {
          def m = new JsonSlurper().setType(RELAX).parseText(s)
          sql.executeUpdate "update bmsg set msgimg = $m.img where pdr = $m.pdr";
        }

        @RequestMapping("/api/inimgnm")
        def inimgnm(@RequestBody String s) {
          def m = new JsonSlurper().setType(RELAX).parseText(s)
          sql.execute "insert into bmsg (pdr, msgimg) values ($m.pdr, $m.img)";
        }

        @RequestMapping("/api/getPimg/{v}")
        @ResponseBody
        def getpimg(@PathVariable v) {
          sql.rows("select msgimg from bmsg where pdr = (:crit - 1)", [crit:v]);
        }

/*      ------------  ACCOUNTS BY FEIRA ------------      */
 
        @RequestMapping("/api/recserial")
        @ResponseBody
        def recserial(){
          sql.rows("select recserial() as id");
        }

        @RequestMapping("/api/upadoc")
        @ResponseBody
        def upadoc(@RequestBody String s) {
            def m = new JsonSlurper().setType(RELAX).parseText(s)
            def f1 = m.form1;
            def f2 = m.form2;
            def rs = sql.rows("select recserial() as id");
            def id = rs[0].id;
            def f2no = f2[0].sn;
            sql.execute "insert into adoc (dno, ddt, rf1, f1d, dmd, nrr, dtp, acc) values ($id, $f1.recDt, $f1.docRf, $f1.docDt    , $f1.docMd, $f1.narr, 'REC',(select acc from ssub where sno = $f2no))";

            f2.each{ zz->
               sql.execute "insert into adocd (dno, sub, rf3, dcr) values ($id, $zz.sn, $zz.ref, $zz.amt)";
            }

            sql.executeUpdate "update adoc set dcr = (select sum(dcr) from adocd where dno = $id) where dno = $id"
        }

        @RequestMapping("/api/acc/{v}")
        @ResponseBody
        def resacc(@PathVariable v){
          def av = "nil"
          def qs = "select ddt as one, dno as fur, dcr as tre from adoc where dtp = 'REC'"
          def qh = [one: "DATE", tre: "AMOUNT", fur: "REC NO"]
          def rs = [a:1, b:2]

          av = av.toUpperCase();

          if(v == "REC"){
            rs = (v.toUpperCase() == "REC") ? sql.rows(qs) : sql.rows(qs, [crit:av]);
          ["hd":qh, "rs":rs]
          } else {
            [rs:"?"]
          }
        }

/*      ------------  LEDGER BY FEIRA ------------      */

        @RequestMapping("/api/lgr/{v}")
        @ResponseBody
        def getledg(@PathVariable v){
          sql.rows("select ddt,dno,acc,dtp,ddr,dcr,@bal:=@bal+ddr-dcr as bal from adoc, (select @bal:=0) as blc where acc = (select acc from ssub where sno = :crit) order by ddt", [crit:v])
        }

/*      ------------  CREDIT LIMIT CONTROL BY FEIRA ------------      */

        @RequestMapping("/api/ccrlc")
        def ccrlc(@RequestBody String s){
          def m = new JsonSlurper().setType(RELAX).parseText(s)

          sql.executeUpdate "update sccr set tcl = $m.crl where sno = $m.sno"
        }  
 


}
