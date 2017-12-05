package com.disb

import groovy.sql.*
import groovy.json.*
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

import javax.mail.MessagingException
import javax.mail.internet.MimeMessage
import javax.mail.internet.InternetAddress

//import org.springframework.core.io
import org.springframework.core.io.FileSystemResource
import org.springframework.core.io.ByteArrayResource
import org.springframework.mail.MailParseException
import org.springframework.mail.SimpleMailMessage
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.mail.javamail.MimeMessagePreparator
import org.springframework.mail.MailException

@RestController
class SndMail {

  @Autowired
  JavaMailSender javaMailSender;

  @RequestMapping("/api/sendbill")
  def mvsub(@RequestBody String s) {
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
  def mvsub(@PathVariable acc, @PathVariable pdr, @RequestBody String s) {
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

}


