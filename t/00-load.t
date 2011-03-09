#!perl -T

use Test::More;

BEGIN {
    use_ok( 'Net::IP::Flakweb' ) || print "Bail out!";
	use_ok( 'LWP::Simple' )      || print "Bail out!";
}

diag( "Testing Net::IP::Flakweb $Net::IP::Flakweb::VERSION, Perl $], $^X" );
my $ip = Net::IP::Flakweb->new();
ok( defined $ip && $ip->isa("Net::IP::Flakweb"), "new()" );
my @formats = $ip->formats();
ok( @formats, "formats()" );

my $tests = 5 + $#formats;

SKIP: {
	# Very basic check to see if there's a network connection.
	eval { $ip->fetch('txt') };

	skip "No internet connection detected.", $#formats + 1 if $@; 

	foreach (@formats) {
		my $result = $ip->fetch($_);
		ok( defined $result, "fetch($_)" );
	}
}

done_testing( $tests );
