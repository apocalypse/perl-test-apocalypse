# Declare our package
package Test::Apocalypse::FileChecks;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'File::Find::Rule'	=> '0.32',
		'Test::File'		=> '1.29',
	);

	while (my ($module, $version) = each %MODULES) {
		eval "use $module $version";	## no critic ( ProhibitStringyEval )
		next unless $@;

		if ( $ENV{RELEASE_TESTING} ) {
			die 'Could not load release-testing module ' . $module . " -> $@";
		} else {
			plan skip_all => $module . ' not available for testing';
		}
	}

	# Run the test!
	my @files = qw( Changes Build.PL Makefile.PL LICENSE MANIFEST MANIFEST.SKIP README META.yml );
	my @pmfiles = File::Find::Rule->file()->name( '*.pm' )->in( 'lib' );

	# check SIGNATURE if it's there
	if ( -e 'SIGNATURE' ) {
		push( @files, 'SIGNATURE' );
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
__END__

=for stopwords dist

=head1 NAME

Test::Apocalypse::FileChecks - Plugin to test for file sanity

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

This plugin ensures basic sanity for the files in the dist.

=head1 DESCRIPTION

This plugin ensures basic sanity for the files in the dist.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::File>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
