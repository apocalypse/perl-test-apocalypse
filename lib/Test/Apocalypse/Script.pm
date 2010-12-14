package Test::Apocalypse::Script;

# ABSTRACT: Plugin for Test::Script

use Test::More;

use Test::Script 1.07;
use File::Find::Rule 0.32;

sub do_test {
	# Find the number of tests
	# TODO we need to search more locations/extensions/etc?
	my @files = File::Find::Rule->file->name( qr/\.pl$/ )->in( qw( examples bin scripts ) );

	# Skip if no scripts
	if ( ! scalar @files ) {
		plan tests => 1;
		pass( 'No script files found in the distribution' );
	} else {
		plan tests => scalar @files;
		foreach my $f ( @files ) {
			script_compiles( $f );
		}
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Script> functionality.

=cut
