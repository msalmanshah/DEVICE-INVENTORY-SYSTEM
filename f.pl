#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;

my $msisdn = shift @ARGV;
if ($msisdn) { 

my @DataKey = ('imsi','addr1','addr2','city','countrycode','firstname','lastname','postalcode','statecode','personalidentificationnumber','planname','usedbalance','planvolume','accountid','msisdn','currentbalance','accountstatus','currentvaliditydate','currentgraceperiodoneenddate','currentexpirydate');
my $DataKeyRef = \@DataKey;

my $in = get("http://203.82.85.195/~svc/cgi-bin/Billsubquery.cgi?phonenumber=$msisdn");

my $j = ""; 
my $y = 0;

while($in=~m|(.*?)<br>|sg){

   my $line = $1;

   foreach my $key (@$DataKeyRef){
      if (grep(/$key/,$line)){
         $y=1;
         my (undef,$value) = split(/:\s/,$line,2);
         $j .= "\"$key\":\"$value\",";
      }
   }
}  


if ($y) {
  chop $j;
  print "\[$j\]\n";
}

}
