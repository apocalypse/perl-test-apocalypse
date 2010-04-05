# Declare our package
package Test::Apocalypse::Script;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

sub _load_prereqs {
	return (
		'Test::Script'		=> '1.07',
		'File::Find::Rule'	=> '0.32',
	);
}

sub do_test {
	# Find the number of tests
	# TODO we need to search more locations/extensions/etc?
	my @files = File::Find::Rule->file->name( '*.pl' )->in( qw( examples bin scripts ) );

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
__END__
=head1 NAME

Test::Apocalypse::Script - Plugin for Test::Script

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

Encapsulates Test::Script functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Script>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
