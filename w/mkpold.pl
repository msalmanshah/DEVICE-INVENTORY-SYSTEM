#!/usr/bin/perl
use PDF::Reuse;
use PDF::Reuse::Barcode;
use LWP::Simple;
use DBI;
use JSON;
use Text::Wrap;
use strict;

sub s2t {
    use integer;
    sprintf("%02d:%02d:%02d", $_[0]/3600, $_[0]/60%60, $_[0]%60);
}

sub cm5 {
  my $n = shift;
  return "-" unless ($n);
  return "-" if ($n==0);
  return commify($n);
}

sub commify {
local $_  = shift;
$_ = sprintf("%.2f",$_);
1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
return $_;
}

my $ac=shift @ARGV;
my $pd=shift @ARGV;

# get the json data from spring (groovy handles db beautifully, better than perl)
# connection to db is saved here
my $json = get("http://localhost:18081/pdf/api/$ac/$pd");
my $dta = decode_json $json;

# build the pdf to STDOUT, hence no fn
# STDOUT to be slurped by spring for presentation on a url
my $fn = "";

#start building;
prFile();
#prForm('ttbill-p1.pdf');
prFont('H');
prFontSize(7);

#prAdd('q 1 0 0 rg 20 650 70 30 re f Q');
#prAdd('q 0.9 0.9 0.9 rg 20 650 70 30 re f Q');

#mark top
#840 is top most pixel hardly visible
#prText(10,835,"^");
#prText(10,745,"--");
#mark bottom
prText(10,50,"==");
#prText(595,835,"|",'right');
#coordinate system is x left to right, y bottom to top
#A4 max x=595, y=835

my @subc = @{$dta->{sub}};
my $sc = @subc;
#print STDERR "subs count= $sc\n";

#inv headers
prFont('C');
prText(436,741,$dta->{inv}[0]{dno});
prText(436,728,$dta->{inv}[0]{ddt});
prText(436,718,$ac);
#prText(436,708,"Refer to Charges Summary");
prText(436,708,$sc == 1 ? $dta->{sub}[0]{sno} : "Refer to Charges Summary");
prText(436,698,$dta->{inv}[0]{pds} . " - ". $dta->{inv}[0]{pde});
prText(436,688,cm5($dta->{inv}[0]{dep}));
prText(436,678,$dta->{inv}[0]{due});

#summary headers
prText(120,741,$dta->{acc}[0]{nme});
prText(102,714,cm5($dta->{trx}[0]{bal}+0.00),'right');
prText(179,714,cm5($dta->{trx}[0]{rec}+0.00),'right');
prText(254,714,cm5($dta->{trx}[0]{adj}+0.00),'right');
prText(327,714,cm5($dta->{trx}[0]{fwd}+0.00),'right');

#current charges etc
prText(327,696,sprintf("%.2f",$dta->{inv}[0]{ddr}+0.00),'right');
prText(327,678,$dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00, 'right');
#prText(295,678,$dta->{trx}[0]{tot});

#payment slip info -- Due
prText(380,205,$dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00);
prText(470,205,$dta->{inv}[0]{due});

#address
prFont('C');
prText(81,163,uc($dta->{acc}[0]{nme}));
prText(81,153,uc($dta->{acc}[0]{adr}));
prText(81,143,uc($dta->{acc}[0]{ad2}));
prText(81,133,uc($dta->{acc}[0]{ad3}));
prText(81,123,uc($dta->{acc}[0]{zip}));
prText(81,113,uc($dta->{acc}[0]{ads}));

#payment slip -- invoice hdrs
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

#barcode
PDF::Reuse::Barcode::Code128(x     => 33,
                             y     => 190,
                             value => $dta->{acc}[0]{acc} . $dta->{inv}[0]{dno}  );

# build the summary of charges for all subs
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

#bill message try here
prFont('C');
my $lmsg = $dta->{lmsg};
#prText(365, 610, $lmsg);
#$Text::Wrap::columns = 30;
#$Text::Wrap::separator = "|||";
for my $bmsg (@{$lmsg}){
  my $msg = $bmsg->{msgtext};
  my @chars = split("", $msg);
  my $sz = @chars;
  my $fry = 610; my $xaxis = 365; my $frcnt = 0;
  for(my $i=0; $i<$sz; $i++){
    #prText($xaxis, $fry, @chars[$i]);
    if (@chars[$i] eq " " && $frcnt >= 25){
     #if($xaxis < 465){
      $xaxis = 365;
      $fry -= 10;
      prText($xaxis, $fry, @chars[$i]);
      $frcnt = 0;
     #}
    }
    elsif(@chars[$i] eq " "){
      $xaxis += 8;
    }
    else{
     $xaxis += 5;
     prText($xaxis, $fry, @chars[$i]); 
    }
    $frcnt++;
  }
}
prForm('ttbill-p1.pdf');

=for comment
# page 2 has bill and payment info
prPage();
prForm('ttbill-p2.pdf');
=cut

# page 3 -- payment and charges details  from invoice lines
prPage();

my $yt = 745; my $yz=0;

#page 2 codes
prFont('HB');
prFontSize(12);
prText(30,$yt,"Payments");
$yz=$yt-5;
prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
$yt -= 20;
my $rec=$dta->{rec};
for my $i (@{$rec}) {
  # ... do stuff
  $yt = chkpend($yt);
}

$yt -= 15;
prFont('HB');
prFontSize(12);
prText(30,$yt,"Charges");
$yz=$yt-5;
prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
$yt -= 20;
prFontSize(8);
my $subs=$dta->{sub};
my $chgs=$dta->{chg};
my $ivls=$dta->{smy};
for my $sub (@{$subs}) {
  prFont('CB');
  prText(30,$yt,'Service Number : '.$sub->{sno});
  $yz = $yt - 5;
  prAdd("q 0.2 w 30 $yz m 160 $yz l S Q");
  $yt -= 15;
  prFont('C');
  for my $ivl (@{$ivls}) {
    my $des = $ivl->{des};
    $des =~ s/^\s+//;
    prText(35,$yt,$des);
    my @mtch = grep {$_->{st1} eq $ivl->{st1}} @{$chgs};
    my $chgc = @mtch;
    if ($chgc == 1) {
      prText(500,$yt,cm5($ivl->{chg}),'right');
      $yt=chkpend($yt);
    } else { 
      #$yz = $yt - 5;
      #prAdd("q 0.2 w 30 $yz m 160 $yz l S Q");
      #$yt -= 15;
      $yt -= 10;
      for my $chg (@{$chgs}) {
        my $a =$chg->{sub};
        my $b =$sub->{sno};
        next if ($chg->{st1} ne $ivl->{st1});
        next if ($chg->{ddr} == 0);
        prText(40,$yt,$chg->{nrr});
        #prText(140,$yt,$a);
        #prText(340,$yt,$b);
        prText(500,$yt,cm5($chg->{ddr}),'right');
        $yt = chkpend($yt);
        #print STDERR "$yp\n";
      }
    }
  }
}

$yt -= 15;
prFont('HB');
prFontSize(12);
prText(30,$yt,"Usage Details");
$yz=$yt-5;
prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
$yt -= 20;

my $usgs=$dta->{usg};
for my $sub (@{$subs}) {
  prFont('CB');
  prFontSize(8);
  prText(30,$yt,'Service Number : '.$sub->{sno});
  $yz = $yt - 5;
  prAdd("q 0.2 w 30 $yz m 160 $yz l S Q");

  prFont('C');
  for my $chg (@{$chgs}){

   #set top page and bottom page
   my $top= 745; my $btm = 225;my $req = 0;

   #total count line and total amount
   my $cntline = 0;my $tchg = 0;my $total = 0;my $tfinal = 0;

   next if ($chg->{st0} ne '33');
   $yt = chkpend($yt);
   #$yt -= 10;
   if($yt > $btm){
     $req = $yt - $btm;
      if($req > $btm ){
       $yt -=10;
       prText(30,$yt,$chg->{ds1}.' '.$chg->{ds0}.' - '.$chg->{nrr});
       #prText(10, $yt, $yt); 
       rLine();
      }
      else{
      #$yt = chkpend($yt);
       $yt -= 10;
       prText(30, $yt, $chg->{ds1}.' '.$chg->{ds0}.' - '.$chg->{nrr});
       #prText(30, $yt, $yt);
       rLine();
      }
    }
    else{
       #$yt = chkpend($yt);
       #$yt -=10;
       prText(30, $yt, $chg->{ds1}.' '.$chg->{ds0}.' - '.$chg->{nrr});
       rLine();
    }
    #header-------------------- 
    sub rOne{ prText(50, $yt, 'Date');
              prText(105, $yt, 'Time');
              prText(170, $yt, 'Called No.');
              prText(390, $yt, 'Duration');
              prText(475, $yt, 'Amount');
              rLine();}
    sub rTwo{prText(410, $yt, '#SMS');
             prText(480, $yt, 'Amount');
             rLine();}
    sub rThree{prText(410, $yt, '#MMS');
               prText(480, $yt, 'Amount'); 
               rLine();}
    sub rFour{prText(395, $yt, 'Total MB');
              prText(480, $yt, 'Amount');
              rLine();}
    sub rFive{prText(50, $yt, 'Date');
              prText(105, $yt, 'Time');
              prText(170, $yt, 'Received From');
              prText(390, $yt, 'Duration');
              prText(475, $yt, 'Amount');
              rLine();}
    sub rLine{$yz=$yt-5;
              prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
              $yt -=15;}
    
    my $dps=$chg->{nrr};
    if(uc($dps) =~ /SMS/){ rTwo();}
    elsif(uc($dps) =~ /MMS/){ rThree();}
    elsif(uc($dps) =~ /DATA/){rFour();}
    #elsif(uc($dps) =~ /INTERNATIONAL/){rFive();}
    else{ rOne();}
    $yt -=5;    

    #details data--------------------
    my $uv0 = ""; my $dtx = "";
    for my $usg (@{$usgs}){
      next if ($usg->{kls} ne $chg->{rf2});
     # my $uv0 = ""; my $dtx = "";
      if ($usg->{kls} =~ /V$/) {
        $uv0 = s2t($usg->{uv0});
        $dtx = $usg->{fdt};} 
      else {
        $uv0 = sprintf("%d",$usg->{uv0});
        my $k = substr($usg->{kls},2,1);
        if    ($k eq "S") { $dtx = "Total SMS";}
        elsif ($k eq "M") { $dtx = "Total MMS";}
        elsif ($k eq "D") { $dtx = "Total DATA";}}
      
      if($yt == $top) {
        $yz=$yt-5;
        prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
        $yt -= 15;
        rOne();
        $yt -= 10;}

      prText(40,$yt,$dtx);
      prText(170,$yt,$usg->{bno});
      prText(430,$yt,$uv0,'right');
      $tchg = cm5($usg->{chg});
      prText(500,$yt, $tchg ,'right'); 
    
      $cntline = $cntline + 1;
      $total = $total + $tchg;
      #new page if not enough, $cntline
      if(($yt <60) && ($dtx !~ /SMS/)){
       if( ($dtx !~ /MMS/) && ($dtx !~ /DATA/)){
        rLine();
        prText(40, $yt, 'Called number: '.$cntline);
        prText(500, $yt, cm5($total), 'right');
        rLine();
        $tfinal = $tfinal + $total;
        $cntline = 0;
        $tchg = 0;
        $total = 0;}}
      $yt = chkpend($yt);
     }
    next if ($yt == 745);
    if(($dtx !~ /SMS/)){
     if( ($dtx !~ /MMS/) && ($dtx !~ /DATA/)){
       rLine();
       prText(500, $yt, cm5($total), 'right');
       prText(40, $yt, 'Called number: '.$cntline);
       rLine();}}
   }
}
prForm('ttbill-p3.pdf');
prEnd();

sub chkpend {
  my $y = shift;
  #my $cntl = shift;
  #go to next page if not enough space
  if ($y < 55){
    prForm('ttbill-p3.pdf');
    prPage();
    return 745;
  }
  return $y - 10;
}
