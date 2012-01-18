#!/usr/bin/perl

#----
# Date: 9/7/2005
# $Revision$
#----

use strict;
use Getopt::Std;
use Date::Manip qw/UnixDate ParseDate Date_NextWorkDay
Date_GetNext DateCalc Date_Cmp/;




my $usage =q^
mkdates outputs a list of dates from specified options
ex. mkdates  -s 20050923 -d fri  -q \' -c ","

-e  <end date>          default today
-s  <start date>        default today
-f  <dateformat output> default %Y%m%d
-d  <day of week>       default nothing (ie.  sunday,mon,tue,...)
-w  boolean display workdays only
-c  <delimter>          default linefeed
-q  <quote>             default nothing
-h  usage

^;

my %opts=();
getopts('c:e:s:f:d:q:wh',\%opts) or die $usage;

die $usage if $opts{h};
die $usage unless ($opts{e} || $opts{s});

my $enddate   = $opts{e} || "today";
my $startdate = $opts{s} || "today";
my $format    = $opts{f} || "%Y%m%d";
my $dow       = $opts{d} || 0;
my $delimiter = $opts{c} || "\n";
my $quote     = $opts{q};
my $off =1;



$enddate = UnixDate(ParseDate($enddate),$format );
my $date = UnixDate(ParseDate($startdate),$format );
my $output='';



if( $opts{w} ){
	while( Date_Cmp($date=Date_NextWorkDay($date,$off),$enddate) < 0 ){
		my $d= UnixDate(ParseDate($date),$format );
		$output .= $quote . $d . $quote . $delimiter;
	}
}
elsif( $dow ){
	while( Date_Cmp($date=UnixDate(ParseDate(Date_GetNext($date,$dow)),$format),$enddate) < 0 ){
		my $d= UnixDate(ParseDate($date),$format );
		$output .= $quote . $d . $quote  . $delimiter;
	}
}
else{
	while( Date_Cmp($date=UnixDate(ParseDate(DateCalc($date,"+1 day")),$format),$enddate) < 0 ){
		my $d= UnixDate(ParseDate($date),$format );
		$output .= $quote . $d . $quote . $delimiter;
	}
}




print substr($output,0,-length($delimiter));
print "\n";
