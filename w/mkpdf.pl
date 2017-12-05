#!/usr/bin/perl
use PDF::Reuse;
use PDF::Reuse::Barcode;
use DBI;
use strict;

my $ac=shift @ARGV;
my $pd=shift @ARGV;
#print "-$fn-\n";
my $fn = "";
#if ($ac eq "") { $fn="su.pdf"; } else { $fn="src/main/groovy/com/disb/su$ac$pd.pdf"; } 
if ($ac eq "") { $fn="su.pdf"; } else { $fn="build/resources/main/su$ac$pd.pdf"; } 

prFile($fn);

prFont('H');
prFontSize(8);

#inv headers
prFont('C');
prText(436,741,"12345678");
prText(436,728,"2016/09/01");
prText(436,718,"0000000001" );
prText(436,708,"0105002003");
prText(436,698,"2016/08/01 - 2016/08/31");
prText(436,688,"500.00");
prText(436,678,"2016/09/15");

prText(120,741,"JOHN P CITZEN");
prText(45,714,"500.00");
prText(125,714,"600.00");
prText(205,714,"700.00");
prText(295,714,"800.00");
prText(295,696,"100.00");
prText(295,678,"900.00");
prText(290,668,"9500.00");

prText(380,205,"500.00");
prText(470,205,"2016/09/15");

prFont('C');
prText(78,163,"ACCOUNT NAME");
prText(78,153,"Address 1");
prText(78,143,"Address 2" );
#prText(505,712,"0105002002");
#prText(505,700," ");

prFontSize(7);
prText(370,182,"Account Number" );	prText(470,182,"0000000001" );
prText(370,170,"Invoice Number" );  prText(470,170,"12345678" );
prText(370,158,"Invoice Date" );	prText(470,158,"2016/09/01" );
prText(370,146,"Billing Period" );	prText(470,146,"2016/08/01 - 2016/08/31");



PDF::Reuse::Barcode::Code128(x     => 33,
                             y     => 190,
                             value => '00000123455555555558');

prDoc('ttbill-tpl0-p1.pdf');
prEnd();

