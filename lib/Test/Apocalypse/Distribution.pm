# Declare our package
package Test::Apocalypse::Distribution;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::Distribution'	=> '2.00',
	);

	while (my ($module, $version) = each %MODULES) {
		eval "use $module $version ()";	## no critic ( ProhibitStringyEval )
		next unless $@;

		if ( $ENV{RELEASE_TESTING} ) {
			die 'Could not load release-testing module ' . $module . " -> $@";
		} else {
			plan skip_all => $module . ' not available for testing';
		}
	}

	# Run the test!
	Test::Distribution->import( not => 'podcover', distversion => 1 );

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Distribution - Plugin for Test::Distribution

=head1 SYNOPSIS

	# Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Distribution functionality.

=head1 DESCRIPTION

Encapsulates Test::Distribution functionality.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Distribution>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
