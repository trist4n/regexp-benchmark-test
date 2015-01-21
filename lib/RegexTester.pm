package RegexTester;
use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use PerlIO::gzip;
use feature 'state';

my $ua = LWP::UserAgent->new;

sub openPath {
	my $path = shift;
	warn "opening $path";
	open(my $fh, "<:gzip", $path) || croak($!);
	return $fh;
}

## compile each line into separate regex
sub fhToRegexpList {
	my $fh = shift;
	warn "compiling to list of regexps";

	my $c;
	my @l;
	while(my $line = <$fh>) {
		if( (++$c % 100_000) == 0) {
			print STDERR localtime . " processed: $c\r";
		}
		chomp($line);
		if(!acceptLine($line)) {
			next;
		}
		push(@l,regexCompiler($line));
	}
	print "\n";

	return @l;
}

## only consider corpus thats pretty wordlike to start with
## cba doing proper cleaning of input data
sub acceptLine {
	my $line = shift;

	## allow alphanum words and combinations thereof
	state $lineFilterer ||= qr/(\w+(\s+)?)+/;
	if($line =~ $lineFilterer) {
		return 1;
	}
	warn "nope: $line";
	return;
}

## introduce a minimal amount of regex compilication
sub regexCompiler {
	my $string = shift;

	## normalise to lowercase
	$string = lc($string);

	return qr/\Q$string\E/;
}

sub fetchPage {
	my $page = shift;
	warn "fetching $page";

	if(my $res = $ua->get($page)) {
		if ($res->is_success) {
			return ($res->decoded_content || $res->content);
		} else {
			croak $res->status_line;
		}
	} else {
		croak "no response";
	}
}

1;
