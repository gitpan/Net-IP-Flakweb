package Net::IP::Flakweb;

use warnings;
use strict;

use LWP::Simple;
use Carp;

=head1 NAME

Net::IP::Flakweb - A simple interface for ip.flakweb.net to determine your
public IP address.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.02';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Net::IP::Flakweb;

    my $ip = Net::IP::Flakweb->new();
    
    my $address = $ip->fetch();
	my $yaml    = $ip->fetch('yaml');
	my $json    = $ip->fetch('json');
	my $xml     = $ip->fetch('xml');
	
	# Fetch results for all the available formats.
	my @formats = $ip->formats();
	my $content = {};
	foreach (@formats) {
		$content->{$_} = $ip->fetch("$_");
	}

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
	my $class = shift;
	my $self  = {
		'api' => {
			'txt'  => 'http://ip.flakweb.net/?api=txt',
			'yaml' => 'http://ip.flakweb.net/?api=yaml',
			'json' => 'http://ip.flakweb.net/?api=json',
			'xml'  => 'http://ip.flakweb.net/?api=xml',
		},
	};
	
	bless $self, $class;
	return $self;
}

=head2 formats()

=over

Return an array of all the available formats.

=back

=cut

sub formats {
	my $self = shift;
	
	my @formats;
	foreach (keys %{$self->{'api'}}) {
		push @formats, $_;
	}
	
	return @formats;
}

=head2 fetch($format)

=over

Returns the IP in the format specified by the format parameter.

=back

=cut

sub fetch {
	my $self   = shift;
	my $format = shift;
	
	# Make sure it's a valid request type.
	for my $api (keys %{$self->{'api'}}) {
		if ($api eq $format) {
			my $url = $self->{'api'}->{$api};
			my $content = get($url);
			if (! defined $content) {
				croak "ERROR: Unable to fetch content from $url.";
			}
			else {
				return $content;
			}
		}
	}
	
	# If we get here then there was a fatal problem of some sort.
	croak "ERROR: Unable to fetch via format: $format."
}


=head1 AUTHOR

Mark Caudill, C<< <mcaudill at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests at
L<https://bitbucket.org/flakblas/net-ip-flakweb/issues>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::IP::Flakweb


You can also look for information at:

=over 4

=item * Project Wiki

L<https://bitbucket.org/flakblas/net-ip-flakweb/wiki/Home>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mark Caudill.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Net::IP::Flakweb
