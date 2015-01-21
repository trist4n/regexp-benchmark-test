#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use RegexTesterRE2;
use Time::HiRes qw(gettimeofday tv_interval);

my ($corpus,$page) = @ARGV;
unless($corpus && $page) {
	croak "need ./script corpus.txt http://pagetoload.com";
}

my $fh = RegexTesterRE2::openPath($corpus);
my @regexs = RegexTesterRE2::fhToRegexpList($fh);
my $pageData = RegexTesterRE2::fetchPage($page);

my ($total,$num);
TESTER: for (my $i = 0; $i < 10; $i++) {
	print STDERR localtime . ": test #$i\n";
	my $start = [gettimeofday];
	MATCHER: for(my $ri=0; $ri <= $#regexs; $ri++) {
		if($pageData =~ $regexs[$ri]) {
			warn "matched $regexs[$ri]";
		}
	}
	my $delt = tv_interval ( $start, [gettimeofday]);
	$total += $delt; $num++;
	print STDERR "#$i took: $delt\n"; 
}
print STDERR "did 10 runs\naverage runtime: " . $total / $num . "\n";
