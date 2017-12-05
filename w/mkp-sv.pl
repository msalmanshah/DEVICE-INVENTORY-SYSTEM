#!/usr/bin/perl
use PDF::Reuse;
use PDF::Reuse::Barcode;
use LWP::Simple;
use DBI;
use JSON;
use strict;

sub commify {
local $_  = shift;
1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
return $_;
}

my $ac=shift @ARGV;
my $pd=shift @ARGV;

#get the data spring (groovy handles db beautifully)
my $json = get("http://localhost:18090/pdf/api/$ac/$pd");

#the data comes in as JSON
my $dta = decode_json $json;

# build the pdf to STDOUT, hence no fn
# to be slurped by spring for presentation on a url
my $fn = "";

#start building;
prFile();
#prForm('ttbill-p1.pdf');
prFont('H');
prFontSize(8);

#mark top
prText(10,745,"--");
#mark bottom
prText(10,20,"--");
prText(10,10,"--");

         my $string = "q\n";         # save graphic state
         $string   .= "4 w\n";       # make line width 4 pixels
         $string   .= "10 600 m\n";  # move to x=10 y=600, starts a new subpath
         $string   .= "40 600 l\n";  # a line to x=40 y=600 ( a horizontal line)
         $string   .= "10 580 m\n";   
         $string   .= "40 580 l\n";   
         $string   .= "10 510 m\n";   
         $string   .= "40 510 l\n";
         $string   .= "s\n";         # close the path and stroke
         $string   .= "Q\n";         # restore graphic state
         prAdd($string);             # the string is added to the content stream

=for comment
prAdd("q 0.2 w 0 95 m 700 95 l S Q");
prAdd("q 0 95 m 700 95 l S Q");       # draw a horizontal lineprText(40,704,"12345678901234");
my $str = "q\n";                      # save the graphic state
  $str   .= "0.9 0.5 0.5 rg\n";       # a fill color
  $str   .= "10 400 440 410 re\n";    # a rectangle
  $str   .= "b\n";                    # fill (and a little more)
  $str   .= "Q\n";                    # restore the graphic state

  prAdd($str);

prText(102,709,"1234.00",'right');
prText(179,709,"1234.00",'right');
prText(254,709,"1234.00",'right');
prText(327,709,"1234.00",'right');
prText(117,704,"12345678901234");
prText(192,704,"12345678901234");
prText(268,704,"12345678901234");
prText(265,704,"______________");
#5678901234567890123456789012345678901234567890");
=cut

#inv headers
prFont('C');
prText(436,741,$dta->{inv}[0]{dno});
prText(436,728,$dta->{inv}[0]{ddt});
prText(436,718,$ac);
prText(436,708,$dta->{sub}[0]{sno});
prText(436,698,$dta->{inv}[0]{pds} . " - ". $dta->{inv}[0]{pde});
prText(436,688,$dta->{inv}[0]{dep});
prText(436,678,$dta->{inv}[0]{due});


prText(120,741,$dta->{acc}[0]{nme});
prText(102,714,$dta->{trx}[0]{bal}+0.00,'right');
prText(179,714,$dta->{trx}[0]{rec}+0.00,'right');
prText(254,714,$dta->{trx}[0]{adj}+0.00,'right');
prText(327,714,$dta->{trx}[0]{fwd}+0.00,'right');

prText(327,696,sprintf("%.2f",$dta->{inv}[0]{ddr}+0.00),'right');
prText(327,678,$dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00, 'right');
#prText(295,678,$dta->{trx}[0]{tot});
#prText(290,668,"9500.00");

prText(380,205,$dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00);
prText(470,205,$dta->{inv}[0]{due}+0.00);

prFont('C');
prText(81,163,uc($dta->{acc}[0]{nme}));
prText(81,153,uc($dta->{acc}[0]{adr}));
prText(81,143,uc($dta->{acc}[0]{ad2}));
prText(81,133,uc($dta->{acc}[0]{ad3}));
prText(81,123,uc($dta->{acc}[0]{zip}));
prText(81,113,uc($dta->{acc}[0]{ads}));
#prText(505,712,"0105002002");
#prText(505,700," ");


prFontSize(7);
prFont('H');
prText(370,182,"Account Number" );	
prText(370,170,"Invoice Number" );  
prText(370,158,"Invoice Date" );	
prText(370,146,"Billing Period" );	
prFont('C');
prText(445,182,$dta->{acc}[0]{acc});
prText(445,170,$dta->{inv}[0]{dno});
prText(445,158,$dta->{inv}[0]{ddt});
prText(445,146,$dta->{inv}[0]{pds} . " - ". $dta->{inv}[0]{pde});


PDF::Reuse::Barcode::Code128(x     => 33,
                             y     => 190,
                             value => $dta->{acc}[0]{acc} . $dta->{inv}[0]{dno}  );

prFontSize(8);
my $yp = 600;
my $smy = $dta->{smy};
for my $chg (@{$smy}) {
  my $des = $chg->{des};
  $des =~ s/^\s+//;
  prText(50,$yp,$des); prText(327,$yp,sprintf("%.2f",$chg->{chg}+0.00),'right');
  $yp -= 10;
}
prFontSize(4);
prText(50,$yp+7,'_________________________________________________________________                      ________________________________');
prFontSize(8)-
prFont('CB');
prText(50,$yp-5,"TOTAL"); prText(327,$yp-5,$dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00, 'right');

#prDoc('ttbill-p1.pdf');
prForm('ttbill-p1.pdf');

prPage();
prForm('ttbill-p2.pdf');


prPage();

prFontSize(7);
prFont('H');
prText(370,182,"Account Number" );  
prText(370,170,"Invoice Number" );  
prText(370,158,"Invoice Date" );  
prText(370,146,"Billing Period" );  
prFont('C');
prText(445,182,$dta->{acc}[0]{acc});
prText(445,170,$dta->{inv}[0]{dno});
prText(445,158,$dta->{inv}[0]{ddt});
prText(445,146,$dta->{inv}[0]{pds} . " - ". $dta->{inv}[0]{pde});

prForm('ttbill-p3.pdf');

=for comment

#prDoc('ttbil-p3.pdf');
=cut

prPage();
prText(500,50,'This is another page');

prEnd();

