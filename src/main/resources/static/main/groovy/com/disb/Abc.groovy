package com.disb

import groovy.sql.*
import groovy.json.*
import java.lang.Process
import static groovy.json.JsonParserType.LAX as RELAX
import org.springframework.core.io.*
import org.springframework.http.*

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

import org.springframework.core.io.FileSystemResource
import org.springframework.core.io.ByteArrayResource

import javax.mail.MessagingException
import javax.mail.internet.MimeMessage
import javax.mail.internet.InternetAddress

import org.springframework.mail.MailParseException
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.mail.javamail.MimeMessagePreparator
import org.springframework.mail.MailException

@RestController
class Bisrest {

  @Autowired
  JavaMailSender javaMailSender;

  def db = [url:'jdbc:mysql://localhost:3306/fr0', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
  def sql = Sql.newInstance(db.url, db.user, db.password, db.driver)
  def setprov=0
  def curdb = 'fr0'
  def curpdfdb = curdb
  def log = []

  //SndMail
    @RequestMapping("/api/sendbill")
  def sendbill(@RequestBody String s) {
    def m = new JsonSlurper().setType(RELAX).parseText(s) 
    def f = "pdfs/SUB"+m.acc+"-"+m.pdr+".pdf"

    def p = new ProcessBuilder('./mkp.pl', m.acc, m.pdr)
                  .redirectOutput(new File('./'+f))
                  .start();

    this.javaMailSender.send(new MimeMessagePreparator() {
       public void prepare(MimeMessage mimeMessage) throws MessagingException {
          MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true, "UTF-8");
          message.setFrom("donotreply@tunetalk.com");
          message.setTo(m.edeml);
          message.setSubject("Tunetalk Bill for Account "+m.acc+", Bill Period "+m.pdr);
          message.setText("<p> Your bill is attached as a PDF file. </p>", true);
          FileSystemResource file = new FileSystemResource(f);
          message.addAttachment(file.getFilename(), file);
       }
     });
  }

  @RequestMapping("/api/sendbillz/{acc}/{pdr}")
  def sendbillz(@PathVariable acc, @PathVariable pdr, @RequestBody String s) {
    def m = new JsonSlurper().setType(RELAX).parseText(s) 
    def f = "pdfs/SUB"+acc+"-"+pdr+".pdf"

    def p = new ProcessBuilder('./mkp.pl', acc, pdr)
                  .redirectOutput(new File('./'+f))
                  .start();

    this.javaMailSender.send(new MimeMessagePreparator() {
       public void prepare(MimeMessage mimeMessage) throws MessagingException {
          MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true, "UTF-8");
          message.setFrom("donotreply@tunetalk.com");
          message.setTo(m.edeml);
          message.setSubject("Tunetalk Bill for Account "+acc+", Bill Period "+pdr);
          message.setText("<p> Your bill is attached as a PDF file. </p>", true);
          FileSystemResource file = new FileSystemResource(f);
          message.addAttachment(file.getFilename(), file);
       }
     });


  }

  //DailyRcpt

      @RequestMapping(value="/pdf/report/{dt}")
      ResponseEntity<InputStreamResource> doReportPdf(@PathVariable dt)
          throws IOException{

           Process rprt = "./dRprt.pl ${dt}".execute()

           HttpHeaders headers = new HttpHeaders();
           headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
           headers.add("Pragma", "no-cache");
           headers.add("Expires", "0");

           return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.parseMediaType("application/pdf"))
                .body(new InputStreamResource(rprt.getInputStream()));

       }


  //Abc

  @RequestMapping("/apix/yo")
  @ResponseBody
  def yo() {
    sql.rows("select 1")
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

  @RequestMapping("/do")
  def doit(@RequestBody String s) {
    //def o = new JsonSlurper()
    def m = new JsonSlurper().setType(JsonParserType.LAX).parseText(s)
    //sql.execute "insert into z (a,b) values ($m.a, $m.b)"
    //sql.execute "insert into z (a,b) values ($m.a, $m.b)"
    m
  }

  @RequestMapping("/api/getcfg")
  @ResponseBody
  def setprov() {
    //"prov set to "+setprov+", db set to"+curdb
    def r = ["setprov":setprov,"curdb":"$curdb", "log":log]
  }

  @RequestMapping("/api/mvsub")
  def mvsub(@RequestBody String s) {
    def rs = [id:"NONE", name:"NO REFS"]
    //def o = new JsonSlurper()
    def m = new JsonSlurper().setType(RELAX).parseText(s)
    rs = sql.rows("select accserial() as id")
    def id = rs[0].id
    def rs2 = sql.rows("select depserial() as id")
    def depid = rs2[0].id
    /**/
    def dt = new Date()
    def d1 = dt.format('yyMMddHHmmss')
    def d2 = dt.format('yyyy-MM-dd HH:mm:ss')
    def dpln = '79,1109'
    if (m.pln ==~ /(?i).*vip.*/) { 
      dpln = '81,' 
    } 
    def bdl = "$dpln,PostpaidSMSBundle,PostpaidMMSBundle"
    sql.execute "insert into cacc values (null,$id,$m.acn,$m.adr,$m.ad2,$m.ad3,$m.ads,$m.zip,null,null,$m.idn,1,$d2,null,now(),'test','@')"
    sql.execute "insert into ssub values (null,$m.sno,$m.sub,$id,$m.sim,1,$d2,null,now(),'test','@',$m.rf1,null,null)"
    sql.execute "insert into spln values (null,$m.sno,$id,$m.pln,1,$d2,null,now(),'test','@')"
    sql.execute "insert into adep (ddt, dno, acc, dtp, sub, dcr) values ($d2, $depid, $id, 'DEP', $m.sno, $m.dep)"
    sql.execute "insert into sccr (sno, acc, kls, dep, tcl, sef, sta, vdp) values ($m.sno, $id, $m.kls, $m.dep, $m.tcl, null, 1, $m.vdp)"
    
    def h = "http://203.82.85.195/~svc/cgi-bin/switch.cgi?phonenumber="+m.sno+"&txid="+id+d1+"&bundle="+bdl+"&dep="+m.dep

    if (setprov) {
      def t = h.toURL().text
    }
    ["res":1]
  }

  @RequestMapping("/api/cctl/{v}")
  @ResponseBody
  def cctl(@PathVariable v) {
    sql.rows("select *,(select sta from ssub where sno = :crit) as st, (select stp from ssub where sno = :crit) as stp from sccr where sno = :crit", [crit:v])
  }

  @RequestMapping("/api/cctlchk/ovr")
  @ResponseBody
  def cctlchk() {

    def rs = sql.rows("select sno,ost,unb,ost+unb as tos, tcl from sccr where ost+unb > 0.8 * tcl");
    rs.each { zz ->
      def dt = new Date()
      def d1 = dt.format('yyMMddHHmmss')
      def d2 = dt.format('yyyy-MM-dd HH:mm:ss')
      def h = "http://203.82.85.195/~svc/cgi-bin/barr.cgi?txid="+zz.sno+d1+"&phonenumber="+zz.sno+"&stype=0"
      log.push([m:zz.tos])
      log.push([m:zz.tcl])
      if (zz.tos > zz.tcl) {
        h = "http://203.82.85.195/~svc/cgi-bin/barr.cgi?txid="+zz.sno+d1+"&phonenumber="+zz.sno+"&stype=2"
        if (setprov) {
          def t = h.toURL().text
        }
        h = "http://203.82.85.195/~svc/cgi-bin/ccontrolmsg.cgi?txid="+zz.sno+d1+"&phonenumber="+zz.sno+"&param=x&text=Your%20usage+has%20exceeded%20your%20credit%20limit%20and%20your%20service%20is%20now%20suspended."
        if (setprov) {
          def t = h.toURL().text
        } 
        sql.execute "update ssub set sta = sta | 4 where sno = '"+zz.sno+"'" 
      } else {
        h = "http://203.82.85.195/~svc/cgi-bin/ccontrolmsg.cgi?txid="+zz.sno+d1+"&phonenumber="+zz.sno+"&param=x&text=Your%20usage+outstanding%20is%80%25%20of%20credit%20limit." 
        if (setprov) {
          def t = h.toURL().text
        }
        log.push([m:h])
      }

    }
    ["res":1]
  }

  @RequestMapping("/api/bills/{acc}")
  @ResponseBody
  def bills(@PathVariable acc ) {
    sql.rows("select dno,ddt,ddr+dcr as amt,pdr,acc,(select eml from cacc where acc = (select acc from ssub where sno = :crit)) as eml from adoc where dtp='INV' and  acc = (select acc from ssub where sno = :crit) order by ddt desc",[crit: acc])
  }

  @RequestMapping("/api/ubills/{sn}")
  @ResponseBody
  def ubills(@PathVariable sn) {
    sql.rows("select sdt, kls, bno, cg0 from susg where ano = :crit and pdr is null order by sdt desc", [crit: sn])
  }

  @RequestMapping("/api/ttsa/a/{sn}")
  @ResponseBody
  def attsa(@PathVariable sn) {
    def z = [a:"1",b:"2"]
    def t = "./f.pl ${sn}".execute().text
    z = Eval.me(t)
    z
  }

  @RequestMapping("/api/setprov/{prv}")
  @ResponseBody
  def setprov(@PathVariable prv ) {
    setprov = prv
    "prov set to "+prv
  }

  @RequestMapping("/api/ttsa/prov/{prv}/{sn}")
  @ResponseBody
  def ttsap(@PathVariable prv, @PathVariable sn, @RequestBody String s) {
    def m = new JsonSlurper().setType(RELAX).parseText(s)
    def dt = new Date()
    def d1 = dt.format('yyMMddHHmmss')
    def stp = 4;
    if(prv == "barr"){
      if(m.res == "TRM"){
        stp = 1;
      } else if(m.res == "CLB") {
        stp = 2;
      } else if(m.res == "DUB") {
        stp = 3;
      } else {
        stp = 4;
      }
      sql.executeUpdate "update ssub set sta = sta | 4, stp = $stp where sno = $sn"
      sql.execute "insert into cres values (null, $m.sno, $m.acc, 'BAR', $m.res, $m.cmt, $d1, null, null)"
    }
    else{
      def sfr = sql.firstRow("select stp from ssub where sno = $sn")
      sql.executeUpdate "update ssub set sta = sta & 11, stp = 0 where sno = $sn"
      sql.execute "insert into cres values (null, $m.sno, $m.acc, 'UNB', null, $m.cmt, $d1, null, null)"
      stp = sfr.stp
    }
    def h = "http://203.82.85.195/~svc/cgi-bin/"+prv+".cgi?phonenumber="+sn+"&txid="+sn+d1+"&stype="+stp
    if (setprov){
     def t = h.toURL().text
    }
    ["res":1]
    
  }

  @RequestMapping("/api/ttsa/prov/ccmsg/{prv}/{sn}/{txs}")
  @ResponseBody
  def attsc(@PathVariable prv, @PathVariable sn, @PathVariable txs) {
    def h = "http://203.82.85.195/~svc/cgi-bin/ccontrolmsg.cgi?phonenumber="+sn+"&txid="+txs+"param="+prv
    def t = h.toURL().text
    ["res":1]    
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
      qs = "select ssub.sno as ky, ssub.icn as one, ssub.nme as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub where nme like :crit order by tre,sno"
      qh = [one:"IC",two:"Subscriber",tre:"Acc Name"]
    } else if (v=="" || v ==~  /(?i)^all$/ ) {
      qs = "select ssub.sno as ky, ssub.acc as one, ssub.nme as two, (select nme from cacc where ssub.acc=cacc.acc) as tre from ssub"
      qh = [one:"Account",two:"Patient",tre:"Acc Name"]
    } else {
      av = "%" + v + "%";
      qs = "select ssub.sno as ky, cacc.nme as one, ssub.acc as two, ssub.nme as tre from ssub,cacc  where cacc.acc=ssub.acc and cacc.nme like :crit order by tre,sno"
      qh = [one:"Account Name",two:"Account",tre:"Patient"]
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

    sql.rows("select a.acc,a.sno,a.sim,a.nme,b.nme as acn,a.sta,b.idn,b.sta as acs,b.adr,b.ad2,b.ad3,b.zip,b.ads,b.eml,(select des from rpln where rpln.pln in (select pln from spln where spln.sno = a.sno)) as plndes, (select pln from spln where spln.sno = a.sno) as pln, (select sum(ddr - dcr) from adoc where acc = b.acc) as ost from ssub a,cacc b where a.acc=b.acc and a.sno like :crit", [crit:v]);
    //sql.rows("select a.acc,a.sno,a.sim,a.nme,b.nme as acn,a.sta,b.idn,b.sta as acs,b.adr,b.ad2,b.ad3,b.zip,b.ads,b.eml,(select des from rpln where rpln.pln in (select pln from spln where spln.sno = a.sno)) as plndes, (select pln from spln where spln.sno = a.sno) as pln, (select sum(ddr - dcr) from adoc where acc = b.acc) as ost from ssub a,cacc b where a.acc=b.acc and a.sno in (select sno from ssub where acc=:crit)", [crit:v]);
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

    @RequestMapping("api/planshow/{v}")
        @ResponseBody
        def resPlanShow(@PathVariable v) {
          sql.rows("select * from rpln where tid = :crit", [crit:v]);
        }

        @RequestMapping("api/planshows/{v}")
        @ResponseBody
        def resPlanShows(@PathVariable v) {
          sql.rows("SELECT rplnchg.tid, rplnchg.cgc, rchg.des, rchg.ctp, rchg.chg FROM rplnchg INNER JOIN rchg ON rplnchg.tid=rchg.tid AND rchg.tid = :crit", [crit:v]);
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
            sql.execute "insert into adoc (dno, ddt, rf1, f1d, dmd, nrr, dtp, acc, ddr) values ($id, $f1.recDt, $f1.docRf, $f1.docDt    , $f1.docMd, $f1.narr, 'REC',(select acc from ssub where sno = $f2no), 0)";

            f2.each{ zz->
               sql.execute "insert into adocd (dno, sub, rf3, dcr, ddr) values ($id, $zz.sn, $zz.ref, $zz.amt, 0)";
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

        @RequestMapping("/api/testacc")
        @ResponseBody
        def testacc(){
          sql.rows("select sno from ssub");
        }

/*      ------------  LEDGER BY FEIRA ------------      */

        @RequestMapping("/api/ldgrcv/{v}")
        @ResponseBody
        def getledg(@PathVariable v){
          sql.rows("select ddt,dno,acc,dtp,ddr,dcr,@bal:=@bal+ddr-dcr as bal from adoc, (select @bal:=0) as blc where acc = (select acc from ssub where sno = :crit) order by ddt", [crit:v])
        }

        @RequestMapping("/api/ldgdep/{v}")
        @ResponseBody
        def getldgdep(@PathVariable v){
          sql.rows("select ddt,dno,acc,dtp,(ifnull(ddr,0)) as ddr,dcr,@bal:=@bal+(ifnull(ddr,0))-dcr as bal from adep, (select @bal:=0) as blc where acc = (select acc from ssub where sno = :crit) order by ddt", [crit:v])
        }

/*      ------------  CREDIT LIMIT CONTROL BY FEIRA ------------      */

        @RequestMapping("/api/ccrlc")
        def ccrlc(@RequestBody String s){
          def m = new JsonSlurper().setType(RELAX).parseText(s)

          sql.executeUpdate "update sccr set tcl = $m.crl where sno = $m.sno"
        }  
 
/*      ------------  EDIT EMAIL SUBSCRIBER BY FADHILAH ------------      */
        @RequestMapping("/api/ecacc/")
        def svemail(@RequestBody String s){
          def m = new JsonSlurper().setType(RELAX).parseText(s)
          sql.executeUpdate "update cacc set eml = $m.email where acc = $m.acc";
        }

/*      ----------- IMSI DATA -----------    */
        @RequestMapping("/api/ihis/{v}")
        @ResponseBody
        def ihis(@PathVariable v){
          //sql.rows("select sim,sef,sta from ssub where sno = :crit order by sef desc", [crit:v])
          sql.rows("select typ,ser,sta from devr where acc = :crit", [crit:v])
        }

        @RequestMapping("/api/stklst/{v}")
        @ResponseBody
        def stklst(@PathVariable v){
          //sql.rows("select sim,sef,sta from ssub where sno = :crit order by sef desc", [crit:v])
          sql.rows("select nme,typ,sno,alm,sta from srec where acc= :crit", [crit:v])
        }
//DoPDFs

  // need hb for all connections
    @RequestMapping("/pdf/api/hb")
    @ResponseBody
    def pdfhb() {
      sql.rows("select 1 as frompdf")
    }

    @RequestMapping("/pdf/bill/csv/{ac}/{pd}")
    ResponseEntity<InputStreamResource>  pdfcsv(@PathVariable ac, @PathVariable pd) {
      def crit = [acc:ac, pdr:pd]
      String s = ""
      def usg= sql.rows("select trim(ano) as ano,date_format(sdt,'%Y/%m/%d  %H:%i:%s') as cdt, trim(bno) as bno,kls, uv0 as vol, cg0 as chg from susg where trim(ano) in (select sno from ssub where acc = $crit.acc) and sdt >= (select pds from bctl where pdr = $crit.pdr) and sdt < (select pds + interval 1 month from bctl where pdr =$crit.pdr)")
      
      usg.first().each{ k,v ->
      s += "$k,"
    }
    s += "\n"
    for (ln in usg) {
      ln.each { k,v ->
          s = s + "$v,"
      }
      s += "\n"
    }

    String fn = ac + pd + ".csv"
      HttpHeaders headers = new HttpHeaders()
      headers.add("Content-Disposition", "inline; filename=$fn")
      headers.add("Cache-Control", "no-cache, no-store, must-revalidate")
      headers.add("Pragma", "no-cache")
      headers.add("Expires", "0")

      return ResponseEntity
              .ok()
              .headers(headers)
              //.contentLength(pdfFile.contentLength())
              .contentType(MediaType.parseMediaType("application/octet"))
              .body(s)


    }

  @RequestMapping(value="/pdf/bill/{acc}/{pd}")
  ResponseEntity<InputStreamResource> doBillPdf(@PathVariable acc, @PathVariable pd)
          throws IOException {

      Process p = "./mkp.pl ${acc} ${pd}".execute()
      //sleep (500)
      //p.waitfor()

    //URL jarUrl = new File("./").toURI().toURL();
    //URLClassLoader jarLoader = new URLClassLoader(new URL[]{jarUrl}, Thread.currentThread().getContextClassLoader());
    //ClassPathResource sampleResource = new ClassPathResource("PDFS/su${acc}${pd}.pdf",jarLoader);

      //ClassPathResource pdfFile = new ClassPathResource("su${acc}${pd}.pdf");

      HttpHeaders headers = new HttpHeaders();
      headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
      headers.add("Pragma", "no-cache");
      headers.add("Expires", "0");
      
      return ResponseEntity
              .ok()
              .headers(headers)
              //.contentLength(pdfFile.contentLength())
              .contentType(MediaType.parseMediaType("application/pdf"))
              .body(new InputStreamResource(p.getInputStream()));
  }

  @RequestMapping("/pdf/billx/{port}/{acc}/{pd}")
  ResponseEntity<InputStreamResource> doBillPdfx(@PathVariable port,@PathVariable acc, @PathVariable pd) 
          throws IOException {

      Process p = "./mkp.pl ${acc} ${pd} ${port}".execute()
      //sleep (500)
      //p.waitfor()

    //URL jarUrl = new File("./").toURI().toURL();
    //URLClassLoader jarLoader = new URLClassLoader(new URL[]{jarUrl}, Thread.currentThread().getContextClassLoader());
    //ClassPathResource sampleResource = new ClassPathResource("PDFS/su${acc}${pd}.pdf",jarLoader);

      //ClassPathResource pdfFile = new ClassPathResource("su${acc}${pd}.pdf");

      HttpHeaders headers = new HttpHeaders();
      headers.add("Cache-Control", "no-cache, no-store, must-revalidate");
      headers.add("Pragma", "no-cache");
      headers.add("Expires", "0");
    
      return ResponseEntity
              .ok()
              .headers(headers)
              //.contentLength(pdfFile.contentLength())
              .contentType(MediaType.parseMediaType("application/pdf"))
              .body(new InputStreamResource(p.getInputStream()));
  }


    @RequestMapping("/pdf/api/{ac}/{pd}")
    @ResponseBody
    def pdfapi(@PathVariable ac, @PathVariable pd) {
        def crit = [acc:ac, pdr:pd]
        def acc = sql.rows("select * from cacc where acc = $crit.acc");
        //def inv = sql.rows("select * from adoc where acc=$crit.acc and pdr=$crit.pdr and dtp='INV'")
        def inv = sql.rows("select dno,ddr,ddt,date_format(ddt,'%Y/%m/%d') as ddt,(select date_format(pds,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pds ,(select date_format(due,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as due ,(select date_format(pds + interval 1 month - interval 1 day,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pde from adoc where acc=$crit.acc and pdr=$crit.pdr and dtp='INV'")
        def sub = sql.rows("select * from ssub where acc=$crit.acc")
        def smy = sql.rows("select a.dno, b.st1, concat(b.ds1,' ',b.ds0) as des, sum(a.ddr) as chg from adocd a, acgc b where a.dno = (select dno from adoc where acc=$crit.acc and pdr=$crit.pdr) and a.rf2=b.cgc group by a.dno,b.st1;")
        //def sub = sql.rows("select count(*),* from adocd where acc=$crit.acc")
        def chg = sql.rows("select a.*,b.glc,b.st0,b.st1,b.ds0,b.ds1 from adocd a, acgc b where a.acc=$crit.acc and a.pdr=$crit.pdr and a.rf2=b.cgc order by glc")
        def usg = sql.rows("select date_format(sdt,'%Y/%m/%d  %H:%i:%s') as fdt, kls,sdt,trim(ano) as ano,trim(bno) as bno , uv0, cg0 as chg , (select glc from acgc where cgc = susg.kls) as glc from susg where trim(ano) in (select sno from ssub where acc = $crit.acc) and kls like '%V'and sdt >= (select pds from bctl where pdr = $crit.pdr) and sdt < (select pds + interval 1 month from bctl where pdr =$crit.pdr) union select date_format(sdt,'%Y/%m/%d  %H:%i:%s') as fdt, kls,sdt,trim(ano) as ano,'' as bno, sum(floor(uv0)) as uv0, sum(cg0) as chg , (select glc from acgc where cgc = susg.kls) as glc from susg where trim(ano) in (select sno from ssub where acc = $crit.acc) and kls not like '%V'and sdt >= (select pds from bctl where pdr = $crit.pdr) and sdt < (select pds + interval 1 month from bctl where pdr = $crit.pdr) group by kls order by glc,sdt")
        def tle = sql.rows("select 1 as one, now() as now")
        def lmsg = sql.rows("select * from bmsg where pdr=$crit.pdr");
        [acc:acc,sub:sub,inv:inv,smy:smy,chg:chg,usg:usg,tle:tle,lmsg:lmsg]
    }

    @RequestMapping("/apit/b/{ac}/{pd}")
    @ResponseBody
    def apitb(@PathVariable ac, @PathVariable pd) {
      def crit = [acc:ac, pdr:pd]
      def inv = sql.rows("select dno,ddr,ddt,date_format(ddt,'%Y/%m/%d') as ddt,(select date_format(pds,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pds ,(select date_format(due,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as due ,(select date_format(pds + interval 1 month - interval 1 day,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pde from adoc where acc=$crit.acc and     pdr=$crit.pdr and dtp='INV'")
      //def inv = "select dno,ddr,ddt,date_format(ddt,'%Y/%m/%d') as ddt,(select date_format(pds,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pds ,(select date_format(due,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as due ,(select date_format(pds + interval 1 month - interval 1 day,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pde from adoc where acc=$crit.acc and     pdr=$crit.pdr and dtp='INV'"
      // [inv:inv]
    }

    @RequestMapping("/pdf/api2/{ac}/{pd}")
    @ResponseBody
    def pdfapi2(@PathVariable ac, @PathVariable pd) {
        def crit = [acc:ac, pdr:pd]
        def acc = sql.rows("select * from cacc where acc = $crit.acc");
        //def inv = sql.rows("select * from adoc where acc=$crit.acc and pdr=$crit.pdr and dtp='INV'")
        def inv = sql.rows("select dno,ddr,ddt,date_format(ddt,'%Y/%m/%d') as ddt,(select date_format(pds,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pds ,(select date_format(due,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as due ,(select date_format(pds + interval 1 month - interval 1 day,'%Y/%m/%d') from bctl where pdr=adoc.pdr) as pde from adoc where acc=$crit.acc and pdr=$crit.pdr and dtp='INV'")
        def sub = sql.rows("select * from ssub where acc=$crit.acc")
        def smy = sql.rows("select a.dno, b.st1, concat(b.ds1,' ',b.ds0) as des, sum(a.ddr) as chg from adocd a, acgc b where a.dno = (select dno from adoc where acc=$crit.acc and pdr=$crit.pdr) and a.rf2=b.cgc group by a.dno,b.st1;")
        //def sub = sql.rows("select count(*),* from adocd where acc=$crit.acc")
        def chg = sql.rows("select a.*,b.glc,b.st0,b.st1,b.ds0,b.ds1 from adocd a, acgc b where a.acc=$crit.acc and a.pdr=$crit.pdr and a.rf2=b.cgc order by glc")
        def usg = sql.rows("select date_format(sdt,'%Y/%m/%d  %H:%i:%s') as fdt, kls,sdt,trim(ano) as ano,trim(bno) as bno , uv0, cg0 as chg , (select glc from acgc where cgc = susg.kls) as glc from susg where trim(ano) in (select sno from ssub where acc = $crit.acc) and sdt >= (select pds from bctl where pdr = $crit.pdr) and sdt < (select pds + interval 1 month from bctl where pdr =$crit.pdr) order by glc,sdt")
        def tle = sql.rows("select 1 as one, now() as now")
        def lmsg = sql.rows("select * from bmsg where pdr=$crit.pdr");
        [acc:acc,sub:sub,inv:inv,smy:smy,chg:chg,usg:usg,tle:tle,lmsg:lmsg]
    }

//	External Delivery

    @RequestMapping("/iot/del/{loc}")
    def delloc(@PathVariable loc) {
	sql.rows "select sum(sta='HOLD') as qtys,scd from gstrg where loc = $loc group by scd"
    }

    @RequestMapping("/iot/conscd/{sto}/{loc}")
    def conscd(@PathVariable sto,@PathVariable loc) {
	sql.rows "select * from gstrg where sta = 'HOLD' and scd = $sto and loc = $loc order by sno"
    }

    @RequestMapping("/iot/getsta/{sto}")
    def getsta(@PathVariable sto) {
	sql.rows "select * from gstrg where scd = $sto order by sno"
    }

    @RequestMapping("/iot/trans/{qty}/{scd}/{loc}")
    def trans(@PathVariable int qty,@PathVariable scd,@PathVariable loc) {
	sql.rows "(select * from gstrg where scd = $scd and sta = 'HOLD' and loc = $loc order by sno limit $qty) order by sno"
    }

    @RequestMapping("/iot/deliver/")
    def deliver(@RequestBody String s) {
	def m = new JsonSlurper().setType(RELAX).parseText(s)
	sql.execute "update gstrg set loc = $m.loc, ldt = $m.ddt, rf3 = $m.dno where scd = $m.scd and sno = $m.sno"
    }

    @RequestMapping("/iot/dn")
    def dn() {
	sql.rows "select dnser () as dno"
    }

    @RequestMapping("/iot/dnrec/")
    def dnrec(@RequestBody String s) {
	def m = new JsonSlurper().setType(RELAX).parseText(s)
	sql.execute "insert into ggdel (gdn,frm,des,qty,gdt) values ($m.dno,$m.frm,$m.loc,$m.qty,$m.ddt)"
    }

//-----------------------EXTERNAL RECEIVED----------------------------------//

    @RequestMapping("/iot/do/")
    def submit(@RequestBody String s) {
        def m = new JsonSlurper().setType(RELAX).parseText(s)
        sql.execute "insert into ggrnh (grn,vcd,gdt,loc) values ($m.grn,$m.vcd,$m.dts,$m.loc)";
    }

    @RequestMapping("/iot/sto/{sto}/{qty}/{don}")
    def test(@PathVariable sto,@PathVariable qty,@PathVariable don) {
        sql.execute "insert into ggrnd (scd,qty,grn) values ($sto,$qty,$don)";
    }

    @RequestMapping("/iot/serNo/")
    def serNo(@RequestBody String s) {
        def m = new JsonSlurper().setType(RELAX).parseText(s)
        sql.execute "insert into gstrg (sno,scd,rf2) values ($m.ser,$m.sto,$m.don)";
    }

    @RequestMapping("/iot/range/")
    def range(@RequestBody String s) {
        def m = new JsonSlurper().setType(RELAX).parseText(s)
        sql.execute "insert into gstrg (sno,scd,rf2,rdt,ldt) values ($m.ser2,$m.sto,$m.don,$m.rdt,$m.rdt)";
    }

    @RequestMapping("/iot/con/{don}")
    @ResponseBody
    def con(@PathVariable don) {
        sql.rows "select * from gstrg where rf3 = $don order by scd,sno"
    }

    @RequestMapping("/iot/ggdel/{don}")
    @ResponseBody
    def ggdel(@PathVariable don) {
        sql.rows("select * from ggdel where gdn = $don")
    }

    @RequestMapping("/iot/loct")
    @ResponseBody
    def loct() {
        sql.rows("select * from gloct")
    }

    @RequestMapping("/iot/grec/{dno}/{loct}")
    @ResponseBody
    def grec(@PathVariable dno, @PathVariable loct) {
        sql.execute("update gstrg set loc = $loct where rf3 = $dno") 
    }    

    @RequestMapping("/iot/conscd/{scd}")
    @ResponseBody
    def conscd(@PathVariable scd) {
        sql.rows "select * from gstrg where scd = $scd and sta = 'HOLD' order by sno"
    }
 
    @RequestMapping("/iot/calba/{don}")
    def calba(@PathVariable don) {
	sql.rows "select scd as sto,qty from ggrnd where grn = $don"
    }

    @RequestMapping("/iot/item")
    def items() {
        sql.rows "select * from gstrg"
    }

    @RequestMapping("/gdvc")
    @ResponseBody
    def gdvc() {
      sql.rows("select sum(sta='HOLD') as qtys,scd from gstrg group by scd")
    }

    @RequestMapping("/gdvcdts/{x}")
    @ResponseBody
    def gdvcdts(@PathVariable x) {
      sql.rows("select * from gstrg where sno = $x")
    }
 
    @RequestMapping("/iot/choose")
    def choose() {
	sql.rows "select * from gloct"
    }

    @RequestMapping("/iot/stock/{loct}")
    def stock(@PathVariable loct) {
	sql.rows "select * from gstrg where loc = $loct and sta = 'HOLD'"
    }
//-----------------------------DEVICE REGISTERED------------------------------//
 
    @RequestMapping("/getfta")
    @ResponseBody
    def getfta() {
      sql.rows("select * from fta")
    }

    @RequestMapping("/iot/act/{src}")
    @ResponseBody
    def act(@PathVariable src) {
      sql.execute("update fta set sta = 1 where ser = $src")
    }

    @RequestMapping("/iot/deact/{src}")
    @ResponseBody
    def deact(@PathVariable src) {
      sql.execute("update fta set sta = 0 where ser = $src")
    }
    
    @RequestMapping("/iot/adDev/{scd}/{sno}")
    def adDev(@PathVariable scd,@PathVariable sno) {
	sql.execute "insert into fta (typ,ser,sta) values ($scd,$sno,1)"
	sql.execute "update gstrg set sta = 'DISBURSED', loc = 'CLIENT' where sno = $sno"
    }

}
