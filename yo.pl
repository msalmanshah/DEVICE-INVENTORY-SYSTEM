#!/usr/bin/perl
$p = '18089';
if ($pp = shift @ARGV) { $p = $pp; }
$u = "curl http://127.0.0.1:$p/apix/yo";
$v = "curl http://127.0.0.1:$p/pdf/api/hb";
$|++;
while (1) {
  $a = `$u`;
  $t = localtime; print STDOUT "$t [k7:unv\@$p heartb] $a\n"; 
  $a = `$v`;
  $t = localtime; print STDOUT "$t [k7:unv\@$p heartb] $a\n"; 
  sleep(5000);
}

