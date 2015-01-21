#!/usr/bin/perl
use strict;
use warnings;
use re::engine::RE2 -strict => 1;
use Carp;
use RegexTester;
use Time::HiRes qw(gettimeofday tv_interval);

my ($corpus,$page) = @ARGV;
unless($corpus && $page) {
	croak "need ./script corpus.txt http://pagetoload.com";
}

my $fh = RegexTester::openPath($corpus);
my @regexs = RegexTester::fhToRegexpList($fh);
my $pageData = RegexTester::fetchPage($page);

my ($total,$num);
TESTER: for (my $i = 0; $i < 10; $i++) {
	print STDERR localtime . ": test #$i\n";
	my $start = [gettimeofday];
	MATCHER: for(my $ri=0; $ri <= $#regexs; $ri++) {
		if($pageData =~ $regexs[$ri]) {
			warn "matched $regexs[$ri]";
			last MATCHER;
		}
	}
	my $delt = tv_interval ( $start, [gettimeofday]);
	$total += $delt; $num++;
	print STDERR "#$i took: $delt\n"; 
}
print STDERR "did 10 runs\naverage runtime: " . $total / $num . "\n";
