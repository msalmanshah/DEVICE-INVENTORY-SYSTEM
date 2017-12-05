#!/usr/bin/perl
use PDF::Reuse;
use PDF::Reuse::Barcode;
use LWP::Simple;
use JSON;
use Image::Info qw(image_info dim);
use Data::Dumper;
use strict;
# main begin

my $gy = 745;
my $gch= "";
my @arr =();

my $ac=shift @ARGV;
my $pd=shift @ARGV;
my $ur="localhost";
my $pt="18090";

if (my $xr=shift(@ARGV)) { $ur = $xr; }
if (my $xp=shift(@ARGV)) { $pt = $xp; }
print #STDERR "http://$ur:$pt/pdf/api2/$ac/$pd\n\n";

# get data via JSON
my $jsn = get("http://$ur:$pt/pdf/api2/$ac/$pd");
my $dta = decode_json $jsn;
#my $dta = {};

#start build
push @arr, "prFile();";

#build page 1
my $gpg = 1;

#should be from db as graphics should change each cycle
my $gf = 'tt-p1.jpg';
my $inf = image_info($gf);
my ($wd,$ht) = dim($inf);
my $gn = prJpeg("$gf",$wd,$ht,0);
my $gd="\$gf='tt-p1.jpg';\$inf=image_info(\$gf);(\$wd,\$ht)=dim(\$inf);\$gn = prJpeg(\"\$gf\",\$wd,\$ht,0);prAdd(\"q\\n170 0 0 150 370 275 cm\\n/\$gn Do\\nQ\\n\");";
#my $gd="prAdd(\"q\\n170 0 0 150 370 275 cm\\n/\$gn Do\\nQ\\n\");";
push @arr, $gd;
print #STDERR "$gd\n";

#add on-each-page graphics
#reusable variables here
$gf = 'tt-p3.jpg';
$inf = image_info($gf);
($wd,$ht) = dim($inf);
$gn = prJpeg("$gf",$wd,$ht,0);
$gd ="\$gf='tt-p3.jpg';\$inf=image_info(\$gf);(\$wd,\$ht)=dim(\$inf);\$gn = prJpeg(\"\$gf\",\$wd,\$ht,0);";

#bill message -- at the moment from a file
my $mz = `cat msg-$pd.txt`;
my $ls = 8;
push @arr, "prFont('H');"; push @arr, "prFontSize(7);";
my $ypm = 620;
my $ms = '';
my @ml = split /\n/,$mz;
for my $l (@ml) {
  my @ws = split /\s/,$l;
  for my $w (@ws) {
    if (prStrWidth($ms.' '.$w,'H',7) > 163) {
      push @arr, "prText(370,$ypm,'$ms');";
      $ms = $w; $ypm -= $ls;
    } else {
      $ms = $ms eq '' ? $w : $ms.' '.$w;
    }
  }
  push @arr, "prText(370,$ypm,'$ms');";
  $ypm -= $ls; $ms = '';
}

my @subc = @{$dta->{sub}};
my $sc = @subc;
#print STDERR "subs count= $sc\n";

push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 38 750 m 340 750 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 38 736 m 340 736 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 38 722 m 340 722 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 38 708 m 340 708 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 38 750 m 38 708 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 113 750 m 113 708 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 189 736 m 189 708 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 263 736 m 263 708 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 340 750 m 340 708 l S Q');";
push @arr, "prFont('HB');prFontSize(7.5);prText(47, 741, 'Account Name');";
push @arr, "prFont('H');prText(47, 727, 'Previous Balance');";
push @arr, "prText(135, 727, 'Payment');";
push @arr, "prText(208, 727, 'Adjustments');";
push @arr, "prText(273, 727, 'Balance Forward');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 263 691 77 14 re S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 263 673 77 14 re S Q');";
push @arr, "prText(260, 695, 'THIS INVOICE', 'right');";
push @arr, "prText(260, 677, 'TOTAL AMOUNT DUE', 'right');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 359 673 191 77 re S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 359 736 m 550 736 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 430 750 m 430 673 l S Q');";
#push @arr, "prFontSize(7);";
push @arr, "prFont('HB');";
push @arr, "prText(365, 740, 'Invoice Number');";
push @arr, "prFont('H');";
push @arr, "prText(365, 727, 'Invoice Date');";
push @arr, "prText(365, 717, 'Account Number');";
push @arr, "prText(365, 707, 'Phone Number');";
push @arr, "prText(365, 697, 'Billing Period');";
push @arr, "prText(365, 687, 'Deposit');";
push @arr, "prText(365, 677, 'DUE DATE');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 38 261 303 380 re S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 359 261 191 380 re S Q');";
push @arr, "prAdd('q 0.4 0.4 0.4 RG 1.3 w 38 245 m 552 245 l S Q');";
push @arr, "prFont('HBO'); prFontSize(9); prText(42, 233, 'PAYMENT SLIP');";
push @arr, "prFont('HB'); prFontSize(7); prText(44, 630, 'SUMMARY OF CHARGES');";
push @arr, "prFont('HB'); prFontSize(7); prText(365, 630, 'BILLING MESSAGES');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 359 200 191 30 re S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 359 215 m 550 215 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 RG 0.2 w 455 200 m 455 230 l S Q');";
push @arr, "prAdd('q 0.1 0.1 0.1 rg 0.2 w 359 140 191 53 re S Q');";
push @arr, "prFont('HB'); prFontSize(7.5); prText(375, 220, 'AMOUNT DUE');";
push @arr, "prFont('HB'); prFontSize(7.5); prText(485, 220, 'DUE DATE');";


#inv headers
push @arr, "prFont('C');";
push @arr, "prText(436,741,'$dta->{inv}[0]{dno}');";
push @arr, "prText(436,728,'$dta->{inv}[0]{ddt}');";
push @arr, "prText(436,718,'$ac');";
#prText(436,708,"Refer to Charges Summary");
push @arr, "prText(436,708,'$sc == 1' ? '$dta->{sub}[0]{sno}' : 'Refer to Charges Summary');";
push @arr, "prText(436,698,'$dta->{inv}[0]{pds}' . ' - '. '$dta->{inv}[0]{pde}');";
push @arr, "prText(436,688,cm5('$dta->{inv}[0]{dep}'));";
push @arr, "prText(436,678,'$dta->{inv}[0]{due}');";

#summary headers
my $nmz = $dta->{acc}[0]{nme};
$nmz =~ s/'/\\'/;
push @arr, "prText(120,741,'$nmz');";
push @arr, "prText(102,714,cm5('$dta->{trx}[0]{bal}'+0.00),'right');";
push @arr, "prText(179,714,cm5('$dta->{trx}[0]{rec}'+0.00),'right');";
push @arr, "prText(254,714,cm5('$dta->{trx}[0]{adj}'+0.00),'right');";
push @arr, "prText(327,714,cm5('$dta->{trx}[0]{fwd}'+0.00),'right');";

#current charges etc
push @arr, "prText(327,696,sprintf('%.2f','$dta->{inv}[0]{ddr}'+0.00),'right');";
push @arr, "prText(327,678,'$dta->{inv}[0]{ddr}' + '$dta->{trx}[0]{fwd}' +0.00, 'right');";
#prText(295,678,$dta->{trx}[0]{tot});

#payment slip info -- Due
push @arr, "prText(380,205,cm5($dta->{inv}[0]{ddr}+  $dta->{trx}[0]{fwd} +0.00));";
push @arr, "prText(470,205,'$dta->{inv}[0]{due}');";

#address
push @arr, "prFont('C');";
push @arr, "prText(81,163,uc('$nmz'));";
push @arr, "prText(81,153,uc('$dta->{acc}[0]{adr}'));";
push @arr, "prText(81,143,uc('$dta->{acc}[0]{ad2}'));";
push @arr, "prText(81,133,uc('$dta->{acc}[0]{ad3}'));";
push @arr, "prText(81,123,uc('$dta->{acc}[0]{zip}'));";
push @arr, "prText(81,113,uc('$dta->{acc}[0]{ads}'));";

#payment slip -- invoice hdrs
push @arr, "prFontSize(7);";
push @arr, "prFont('H');";
push @arr, "prText(370,182,'Account Number' );";
push @arr, "prText(370,170,'Invoice Number' );";
push @arr, "prText(370,158,'Invoice Date' );";
push @arr, "prText(370,146,'Billing Period' );";	
push @arr, "prFont('C');";
push @arr, "prText(445,182,'$dta->{acc}[0]{acc}');";
push @arr, "prText(445,170,'$dta->{inv}[0]{dno}');";
push @arr, "prText(445,158,'$dta->{inv}[0]{ddt}');";
push @arr, "prText(445,146,'$dta->{inv}[0]{pds}' . ' - '. '$dta->{inv}[0]{pde}');";

#barcode
push @arr, "PDF::Reuse::Barcode::Code128(x     => 33,
                                         y     => 190,
                                         value => '$dta->{acc}[0]{acc}' . '$dta->{inv}[0]{dno}' );";

# build the summary of charges for all subs
push @arr, "prFontSize(8);";
my $yp = 600;
my $smy = $dta->{smy};
for my $chg (@{$smy}) {
  my $des = $chg->{des};
  $des =~ s/^\s+//;
  push @arr, "prText(50,$yp,'$des');"; 
  push @arr, "prText(327,$yp,cm5('$chg->{chg}'+0.00),'right');";
  $yp -= 10;
}
push @arr, "prFontSize(4);";
#push @arr, "prText(50,$yp+7,'_________________________________________________________________                      ________________________________');";
push @arr, "prAdd('q 0.2 w 50 $yp m 206 $yp l S Q');";
push @arr, "prAdd('q 0.2 w 258 $yp m 336 $yp l S Q');";
$yp -=10;
push @arr, "prFontSize(8);";
push @arr, "prFont('CB');";
push @arr, "prText(50,$yp-5,'TOTAL');"; 
push @arr, "prText(327,$yp-5,cm5('$dta->{inv}[0]{ddr}' + '$dta->{trx}[0]{fwd}' +0.00), 'right');";

ftr();
push @arr, "prForm('ttbill-p1.9.pdf');";
push @arr, "prPage();";

#build page 2 onwards
$gpg++;

#2.1 Build summary page
if ($dta->{rec}) {
	my $recs=$dta->{rec};
	ttl1("Payments");
	for my $rec (@{$recs}) {
	  # ... do stuff
	  #$yt = chkpend($yt);
	}
}

ttl1("Charges");
my $subs=$dta->{sub};
my $chgs=$dta->{chg};
my $ivls=$dta->{smy};
my $zt = 0.00;
for my $sub (@{$subs}) {
	ttl2("Service Number : ".$sub->{sno});
	decry(10);
	push @arr, "prFont('C');"; push @arr, "prFontSize(7.5);";
	for my $ivl (@{$ivls}) {
    my $des = $ivl->{des};
    $des =~ s/^\s+//;
    push @arr, "prText(35,$gy,'$des');";
    my @mtch = grep {$_->{st1} eq $ivl->{st1}} @{$chgs};
    my $chgc = @mtch;
    if ($chgc == 1) {
      push @arr, "prText(520,$gy,cm5('$ivl->{chg}'),'right');";
      $zt += $ivl->{chg};
      decry(10);
    } else {
      decry(10);
      my $zst = 0.00; 
      for my $chg (@{$chgs}) {
        my $a =$chg->{sub};
        my $b =$sub->{sno};
        next if ($chg->{st1} ne $ivl->{st1});
        next if ($chg->{ddr} == 0);
        push @arr, "prText(40,$gy,'$chg->{nrr}');";
        #prText(140,$yt,$a);
        #prText(340,$yt,$b);
        push @arr, "prText(450,$gy,cm5('$chg->{ddr}'),'right');";
				decry(10);
				$zst += $chg->{ddr};
      }
      $zt += $zst;
      my $gz = $gy + 5;
      push @arr, "prAdd('q 0.2 w 395 $gz m 452 $gz l S Q');";
      push @arr, "prText(520,$gy,cm5('$zst'),'right');";
      decry(10);
    }
	}
  my $gz = $gy + 5;
  push @arr, "prAdd('q 0.2 w 456 $gz m 522 $gz l S Q');";
  decry(4);
  push @arr, "prFont('CB');";
  push @arr, "prText(520,$gy,cm5('$zt'),'right');";
	decry(10);
}
decry(10);

ttl1("Usage Details");
my $usgs = $dta->{usg};

for my $sub (@{$subs}) {
	ttl2("Service Number : ".$sub->{sno});

	for my $chg (@{$chgs}) {
		next if ($chg->{st0} ne '33');
		decry(10);
    $gch = substr($chg->{glc},5,1);
		ttl3($chg->{ds1}.' '.$chg->{ds0}.' - '.$chg->{nrr} . " [" . $gch . "]");
    prch($gch);

    #show the details
    my $ochg = 0.00; my $ocnt = 0; my $ouv = 0;
    my @ott= (0.00,0,0);
    for my $usg (@{$usgs}) {
    	next if ($usg->{kls} ne $chg->{rf2});
    	prdt($usg);
    	$ott[0]+=$usg->{chg}; $ott[1] += $usg->{uv0}; $ott[2]++; $ott[3] = $usg->{kls};
    }
    prtt(\@ott);
	}
}

my $gtp = $gpg;

ftr();
push @arr, "prForm('ttbill-p3.pdf');";
push @arr, "prEnd();";

if (1) {
	print Dumper(@arr);
} else {
	foreach my $cmd (@arr){
	  eval($cmd);
	}
}


# main end
#-------------------------------------
# subs here

sub prtt {
	my @ott = @{$_[0]};
	my $yz = $gy + 4;
	my %kz = (
		 'V','Call'
		,'D','Data Session'
		,'S','Short Message'
		,'M', 'MMS'
	);
	my $kk = substr($ott[3],2,1);
	push @arr, "prAdd('q 0.2 w 30 $yz m 550 $yz l S Q');";
	decry(4);
	push @arr, "prFont('CB');"; push @arr, "prFontSize(7.5);";
	push @arr, "prText(520,$gy,cm5('$ott[0]'),'right');";
	push @arr, "prText(54,$gy,cfy('$ott[2]'),'right');";
	my $udes = $kz{$kk};
	if ($ott[2] > 1 ) { $udes .=  's'; }
	push @arr, "prText(58,$gy,'$udes');";
	my $vt = '';
	   if ($kk eq 'V') { $vt = s2t($ott[1]); }
	elsif ($kk eq 'D') { $vt = cfy($ott[1]); }
	push @arr, "prText(450,$gy,'$vt','right');";
  decry(15);
}

sub ttl3 {
	my $t = shift;
	push @arr, "prFont('C');"; push @arr, "prFontSize(8);";
	push @arr, "prText(30,$gy,'$t');";
	my $yz = $gy - 5;
	push @arr, "prAdd('q 0.2 w 30 $yz m 550 $yz l S Q');";
	decry(15);	
}

sub ttl2 {
	my $t = shift;
	push @arr, "prFont('HB');"; push @arr, "prFontSize(8);";
	push @arr, "prText(30,$gy,'$t');";
	my $yz = $gy - 5;
	push @arr, "prAdd('q 0.2 w 30 $yz m 148 $yz l S Q');";
	decry(10);
}

sub ttl1 {
	#put a bit of a gap before tite
	decry(5);
	my $t = shift;
	push @arr, "prFont('HB');"; push @arr, "prFontSize(12);";
	push @arr, "prText(30,$gy,'$t');";
	my $yz = $gy - 5;
	push @arr, "prAdd('q 0.2 w 30 $yz m 550 $yz l S Q');";
	decry(20);
}

sub prdt {
	my $usg = shift;
	push @arr, "prFont('C');"; push @arr, "prFontSize(7.5);";
  push @arr, "prText(40,$gy,'$usg->{fdt}');";
  my $k = substr($usg->{kls},2,1);
  if ($k ne 'D') {
  	push @arr, "prText(170,$gy,'$usg->{bno}');";
  }
  if ($k eq "V") {
  	my $uv0= s2t($usg->{uv0});
  	push @arr, "prText(450,$gy,'$uv0','right');";
  }
  if ($k eq "D") {
  	my $uv0 = cfy($usg->{uv0});
  	push @arr, "prText(450,$gy,'$uv0','right');";  	
  }
  push @arr, "prText(520,$gy,cm5('$usg->{chg}'),'right');";
  decry(9);
}


sub decry {
	my $y = shift;
	if ($gy - $y < 55){
    	ftr();
		push @arr, "prForm('ttbill-p3.pdf');";
		push @arr, "prPage();";
		$gpg++;
	  	$gy = 745;
		prch($gch,$gy);
	} else { $gy -= $y; }
}

sub ftr {
    #add the recurring graphics
	#prAdd("q\n190 0 0 15 190 10 cm\n/$gn Do\nQ\n");
	my $cm= $gd . "prAdd(\"q\\n165 0 0 13 230 10 cm\\n/\$gn Do\nQ\n\");";
	push @arr, $cm;
	#print STDERR "$cm\n";
	#then the signature
	push @arr, "prFont('H');"; push @arr, "prFontSize(3.5);";
	push @arr, "prText(590,5,'unv.2.1.1','right');";
	#print the page number, usually uptop and not at the foot
	push @arr, "prAdd('q 0.4 0.4 0.4 RG 1.3 w 93 789 m 552 789 l S Q');";
	if ($gpg>1) {
		push @arr, "prFont('C'); prFontSize(7.5); prText(552,793,\"Page $gpg of \$gtp\",'right');";
		#push @arr,"print STDERR \"gtp=\$gtp\\n\";"
	} else {
		push @arr, "prFont('HB'); prFontSize(15); prText(552,793,'TAX INVOICE','right');";
		push @arr, "prFont('HBO'); prFontSize(9); prText(552,780,'INVOIS CUKAI','right');";
		push @arr, "prFont('H'); prFontSize(4.5); prText(92,782,'19-02-01 LEVEL 2 WISMA TUNE');";
		push @arr, "prFont('H'); prFontSize(4.5); prText(92,777,'19 JALAN DUNGUN, BUKIT DAMASARA');";
		push @arr, "prFont('H'); prFontSize(4.5); prText(92,772,'50490 KUALA LUMPUR');";
		push @arr, "prFont('HB'); prFontSize(4.5); prText(92,767,'GST NO: 000737447936');";
	}
}

#print current page header
sub prch {
	my $ch = shift;
	if ($ch eq "") { return; }
	my $y = $gy;
	my $h = "Duration";
	   if ($ch eq "1") { $h = "Duration"; }
	elsif ($ch eq "2") { $h = "";         }
	elsif ($ch eq "3") { $h = "";         }
	elsif ($ch eq "4") { $h = "MB";       }
	push @arr, "prFont('CO');"; push @arr, "prFontSize(8);";
	push @arr, "prText( 50, $y, 'Date');";
	push @arr, "prText(105, $y, 'Time');";
	push @arr, "prText(450, $y, '$h','right');";
	push @arr, "prText(520, $y, 'Amount','right');";
	#put lines
	$y-=5;
	push @arr, "prAdd('q 0.2 w 30 $y m 550 $y l S Q');";
	$gy -= 20;
}

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

sub cfy {
local $_  = shift;
$_ = sprintf("%d",$_);
1 while s/^([-+]?\d+)(\d{3})/$1,$2/;
return $_;	
}

#print Dumper(@arr);
