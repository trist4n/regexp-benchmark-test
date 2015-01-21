package RegexTester;
use strict;
use warnings;
use Carp;
use Regexp::Assemble;
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

sub fhToAsRegexp {
	my $fh = shift;
	warn "assembling into giant or regexp";

	my $ra = Regexp::Assemble->new;
	my $c;
	while(my $line = <$fh>) {
		if( (++$c % 100_000) == 0) {
			print STDERR localtime . " processed: $c\r";
		}
		chomp($line);
		if(!acceptLine($line)) {
			next;
		}
		$ra->add(quotemeta(lc($line)));
	}

	return $ra->re;
} 

sub fhToRegexp {
	my $fh = shift;
	warn "compiling to single OR regex";

	my $str = "(";
	my $c;
	while(my $line = <$fh>) {
		if( (++$c % 100_000) == 0) {
			print STDERR localtime . " processed: $c\r";
		}
		chomp($line);
		if(!acceptLine($line)) {
			next;
		}
		$str .= quotemeta(lc($line))."|";
	}
	chop($str);
	$str .= ")";

	return qr/$str/;
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
	if( (length($line) > 5) && ($line =~ $lineFilterer)) {
		return 1;
	}
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
