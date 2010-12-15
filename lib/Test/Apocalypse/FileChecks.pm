package Test::Apocalypse::FileChecks;

# ABSTRACT: Plugin to test for file sanity

use Test::More;
use File::Find::Rule 0.32;
use Test::File 1.29;

sub do_test {
	my @files = qw( Changes Build.PL Makefile.PL LICENSE MANIFEST MANIFEST.SKIP README META.yml );
	my @pmfiles = File::Find::Rule->file()->name( qr/\.pm$/ )->in( 'lib' );

	# check SIGNATURE if it's there
	if ( -e 'SIGNATURE' ) {
		push( @files, 'SIGNATURE' );
	}

	# check META.json if it's there
	if ( -e 'META.json' ) {
		push( @files, 'META.json' );
	}

	plan tests => ( ( scalar @files ) * 4 ) + ( ( scalar @pmfiles ) * 3 );

	# ensure our basic CPAN dist contains everything we need
	foreach my $f ( @files ) {
		file_exists_ok( $f, "file $f exists" );
		file_not_empty_ok( $f, "file $f got data" );
		file_readable_ok( $f, "file $f is readable" );
		file_not_executable_ok( $f, "file $f is not executable" );
	}

	# check all *.pm files for executable too
	foreach my $f ( @pmfiles ) {
		file_not_empty_ok( $f, "file $f got data" );
		file_readable_ok( $f, "file $f is readable" );
		file_not_executable_ok( $f, "file $f is not executable" );
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords dist

=head1 DESCRIPTION

This plugin ensures basic sanity for the files in the dist.

=cut
