package com.disb

import groovy.sql.*
import groovy.json.*
import java.lang.Process
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

@RestController
class DoPDFs {
		//def db = [url:'jdbc:mysql://localhost:3306/k7', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
	def db = [url:'jdbc:mysql://localhost:3306/unv', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
	def sql = Sql.newInstance(db.url, db.user, db.password, db.driver)

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

}
