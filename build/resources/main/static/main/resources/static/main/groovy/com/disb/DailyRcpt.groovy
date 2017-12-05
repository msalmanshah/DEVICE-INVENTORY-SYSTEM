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
class DailyRcpt {
      def db = [url:'jdbc:mysql://localhost:3306/unv', user:'root', password:'', driver:'com.mysql.jdbc.Driver']
      def sql = Sql.newInstance(db.url, db.user, db.password, db.driver)
      def curpdfdb = 'unv'


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

     @RequestMapping("/api/getpdfdb")
     @ResponseBody
       def setprov() {
       def r = ["curpdfdb":"$curpdfdb"]
  }


     @RequestMapping("api/setpdfdb/{v}")
     @ResponseBody
       def setdb(@PathVariable v) {
         sql.close();
         curpdfdb = v;
         db = [url:'jdbc:mysql://localhost:3306/'+v, user:'root', password:'', driver:'com.mysql.jdbc.Driver']
         sql = Sql.newInstance(db.url, db.user, db.password, db.driver)
         "set pdfdb to " + v;
    }

     @RequestMapping("/pdf/api/{dt}")
     @ResponseBody
     def pdfapi(@PathVariable dt){
          def crit = [ddt:dt]
          //change dtp INV to REC 
          def rprt = sql.rows("select a.dmd,a.ddt, b.sub, b.dcr, b.rf3 from adoc a, adocd b where a.dno=b.dno and a.dtp='REC' and ddt= $crit.ddt order by a.dmd");
          def md = sql.rows("select distinct a.dmd from adoc a, adocd b where a.dno=b.dno and a.dtp='REC' and a.ddt = $crit.ddt order by a.dmd;");

          [rprt:rprt, md:md] 
     }
}
