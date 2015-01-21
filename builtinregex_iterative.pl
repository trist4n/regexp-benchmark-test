#!/usr/bin/perl
use strict;
use warnings;
use Carp;
use RegexTester;

my ($corpus,$page) = @ARGV;
unless($corpus && $page) {
	croak "need ./script corpus.txt http://pagetoload.com";
}

my $fh = RegexTester::openPath($corpus);
my @regexs = RegexTester::fhToRegexpList($fh);
my $pageData = RegexTester::fetchPage($page);

TESTER: for (my $i = 0; $i < 100; $i++) {
	print STDERR localtime . ": test #$i\n";
	MATCHER: for(my $ri=0; $ri <= $#regexs; $ri++) {
		if($pageData =~ $regexs[$ri]) {
			warn "matched $regexs[$ri]";
			last MATCHER;
		}
	}
}
print "\n";
