#!/usr/bin/perl
use PDF::Reuse;
use PDF::Reuse::Barcode;
use LWP::Simple;
use JSON;
use Image::Info qw(image_info dim);
use strict;

# main begin

my $gy = 745;
my $gch= "";

my $ac=shift @ARGV;
my $pd=shift @ARGV;
my $ur="localhost";
my $pt="18090";

if (my $xp=shift(@ARGV)) { $pt = $xp; }
if (my $xr=shift(@ARGV)) { $ur = $xr; }
print "http://$ur:$pt/pdf/api2/$ac/$pd\n\n";

# get data via JSON
my $jsn = get("http://$ur:$pt/pdf/api2/$ac/$pd");
my $dta = decode_json $jsn;
#my $dta = {};

#start build
prFile();

#build page 1
my $gpg = 1;

#should be from db as graphics should change each cycle
my $gf = 'tt-p1.jpg';
my $inf = image_info($gf);
my ($wd,$ht) = dim($inf);
my $gn = prJpeg("$gf",$wd,$ht,0);
prAdd("q\n170 0 0 150 370 275 cm\n/$gn Do\nQ\n");

#add on-each-page graphics
#reusable variables here
$gf = 'tt-p3.jpg';
$inf = image_info($gf);
($wd,$ht) = dim($inf);
$gn = prJpeg("$gf",$wd,$ht,0);

#bill message -- at the moment from a file
my $mz = `cat msg-$pd.txt`;
my $ls = 8;
prFont('H'); prFontSize(7);
my $ypm = 620;
my $ms = '';
my @ml = split /\n/,$mz;
for my $l (@ml) {
  my @ws = split /\s/,$l;
  for my $w (@ws) {
    if (prStrWidth($ms.' '.$w,'H',7) > 163) {
      prText(370,$ypm,$ms);
      $ms = $w; $ypm -= $ls;
    } else {
      $ms = $ms eq '' ? $w : $ms.' '.$w;
    }
  }
  prText(370,$ypm,$ms);
  $ypm -= $ls; $ms = '';
}

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
  prText(50,$yp,$des); prText(327,$yp,cm5($chg->{chg}+0.00),'right');
  $yp -= 10;
}
prFontSize(4);
prText(50,$yp+7,'_________________________________________________________________                      ________________________________');
prFontSize(8)-
prFont('CB');
prText(50,$yp-5,"TOTAL"); prText(327,$yp-5,cm5($dta->{inv}[0]{ddr} + $dta->{trx}[0]{fwd} +0.00), 'right');


ftr();
prForm('ttbill-p1.pdf');
prPage();

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
	prFont('C'); prFontSize(7.5);
	for my $ivl (@{$ivls}) {
    my $des = $ivl->{des};
    $des =~ s/^\s+//;
    prText(35,$gy,$des);
    my @mtch = grep {$_->{st1} eq $ivl->{st1}} @{$chgs};
    my $chgc = @mtch;
    if ($chgc == 1) {
      prText(520,$gy,cm5($ivl->{chg}),'right');
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
        prText(40,$gy,$chg->{nrr});
        #prText(140,$yt,$a);
        #prText(340,$yt,$b);
        prText(450,$gy,cm5($chg->{ddr}),'right');
				decry(10);
				$zst += $chg->{ddr};
      }
      $zt += $zst;
      my $gz = $gy + 5;
      prAdd("q 0.2 w 395 $gz m 452 $gz l S Q");
      prText(520,$gy,cm5($zst),'right');
      decry(10);
    }
	}
  my $gz = $gy + 5;
  prAdd("q 0.2 w 456 $gz m 522 $gz l S Q");
  decry(4);
  prFont('CB');
	prText(520,$gy,cm5($zt),'right');
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

ftr();
prForm('ttbill-p3.pdf');
prEnd();


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
	prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
	decry(4);
	prFont('CB'); prFontSize(7.5);
	prText(520,$gy,cm5($ott[0]),'right');
	prText(54,$gy,cfy($ott[2]),'right');
	my $udes = $kz{$kk};
	if ($ott[2] > 1 ) { $udes .=  's'; }
	prText(58,$gy,$udes);
	my $vt = '';
	   if ($kk eq 'V') { $vt = s2t($ott[1]); }
	elsif ($kk eq 'D') { $vt = cfy($ott[1]); }
	prText(450,$gy,$vt,'right');
  decry(15);
}

sub ttl3 {
	my $t = shift;
	prFont('C'); prFontSize(8);
	prText(30,$gy,$t);
	my $yz = $gy - 5;
	prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
	decry(15);	
}

sub ttl2 {
	my $t = shift;
	prFont('HB'); prFontSize(8);
	prText(30,$gy,$t);
	my $yz = $gy - 5;
	prAdd("q 0.2 w 30 $yz m 148 $yz l S Q");
	decry(10);
}

sub ttl1 {
	#put a bit of a gap before tite
	decry(5);
	my $t = shift;
	prFont('HB'); prFontSize(12);
	prText(30,$gy,$t);
	my $yz = $gy - 5;
	prAdd("q 0.2 w 30 $yz m 550 $yz l S Q");
	decry(20);
}

sub prdt {
	my $usg = shift;
	prFont('C'); prFontSize(7.5);
  prText(40,$gy,$usg->{fdt});
  my $k = substr($usg->{kls},2,1);
  if ($k ne 'D') {
  	prText(170,$gy,$usg->{bno});
  }
  if ($k eq "V") {
  	my $uv0= s2t($usg->{uv0});
  	prText(450,$gy,$uv0,'right');  	
  }
  if ($k eq "D") {
  	my $uv0 = cfy($usg->{uv0});
  	prText(450,$gy,$uv0,'right');  	
  }
  prText(520,$gy,cm5($usg->{chg}),'right');
  decry(9);
}


sub decry {
	my $y = shift;
	if ($gy - $y < 55){
    ftr();
		prForm('ttbill-p3.pdf');
		prPage();
		$gpg++;
	  $gy = 745;
		prch($gch,$gy);
	} else { $gy -= $y; }
}

sub ftr {
    #add the recurring graphics
		#prAdd("q\n190 0 0 15 190 10 cm\n/$gn Do\nQ\n");
		prAdd("q\n165 0 0 13 230 10 cm\n/$gn Do\nQ\n");
		#then the signature
		prFont('H'); prFontSize(3.5);
		prText(590,5,'unv.2.1.1','right');
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
	prFont('CO'); prFontSize(8);
	prText( 50, $y, 'Date');
	prText(105, $y, 'Time');
	prText(450, $y, $h,'right');
	prText(520, $y, 'Amount','right');
	#put lines
	$y-=5;
	prAdd("q 0.2 w 30 $y m 550 $y l S Q");
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

