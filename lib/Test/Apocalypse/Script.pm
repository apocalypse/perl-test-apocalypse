package Test::Apocalypse::Script;

# ABSTRACT: Plugin for Test::Script

use Test::More;
use Test::Script 1.07;
use File::Find::Rule 0.32;

# TODO we need to search more locations/extensions/etc?
my @files;
sub _is_disabled {
	# TODO Stupid FFR complains if the dir doesn't exist?!?
	my @dirs;
	foreach my $d ( qw( examples bin scripts ) ) {
		push @dirs, $d if -d $d;
	}
	@files = File::Find::Rule->file->name( qr/\.pl$/ )->in( @dirs );

	# Skip if no scripts
	if ( ! scalar @files ) {
		return 'No script files found in the distribution';
	}
}

sub do_test {
	plan tests => scalar @files;
	foreach my $f ( @files ) {
		script_compiles( $f );
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Script> functionality.

=cut
