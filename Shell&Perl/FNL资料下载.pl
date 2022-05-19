#!/usr/bin/perl -w
#################################################################
# Perl Script to retrieve 2 online Data files of 'ds083.2',
# total 28.65M. This script uses 'wget' to download data.
#
# Highlight this script by Select All, Copy and Paste it into a file;
# make the file executable and run it on command line.
#
# You need pass in your password as a parameter to execute
# this script; or you can set an environment variable RDAPSWD
# if your Operating System supports it.
#
# Contact grace@ucar.edu (Grace Peng) for further assistance.
#################################################################

use strict;
my ($syscmd, $vn, $opt, $i, @filelist);
my $pswd = (@ARGV ? $ARGV[0] : $ENV{RDAPSWD});
if(!$pswd) {
 print "\n Usage: $0 YourPassword\n\n";
 exit 1;
}
open VN, "wget -V |" or die 'cannot find wget';
$vn = (<VN> =~ /^GNU Wget (\d+)\.(\d+)/) ? (100 * $1 + $2) : 109;
close(VN);
$syscmd = ($vn > 109 ? 'wget --no-check-certificate' : 'wget');
$syscmd .= ' -O Authentication.log --save-cookies auth.rda_ucar_edu --post-data' .
"=\"email=qqf14\@mails.tsinghua.edu.cn&passwd=$pswd&action=login\" " .
'https://rda.ucar.edu/cgi-bin/login';
system($syscmd);
$opt = 'wget -N';
$opt .= ' --no-check-certificate' if($vn > 109);
$opt .= ' --load-cookies auth.rda_ucar_edu ' .
'http://rda.ucar.edu/data/ds083.2/';
@filelist = (
  "grib2/2015/2015.01/fnl_20150101_00_00.grib2",
  "grib2/2015/2015.01/fnl_20150101_06_00.grib2",
);
for($i = 0; $i < @filelist; $i++) {
  $syscmd = $opt . $filelist[$i];
  print "$syscmd...\n";
  system($syscmd);
}
system('rm -f auth.rda_ucar_edu Authentication.log');
exit 0;