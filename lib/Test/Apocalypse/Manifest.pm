# Declare our package
package Test::Apocalypse::Manifest;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::CheckManifest;

# does our stuff!
sub do_test {
	ok_manifest( {
		# for now, exclude some annoying stuff
		'filter' => [ qr/\.svn/, qr/\.git/, qr/\.tar\.gz$/,	# RCS systems
			qr/\.project$/,					# Eclipse file
			qr/\.c$/, qr/\.o$/,				# compiled stuff ( XS )
		],
	} );

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Manifest - Plugin for Test::CheckManifest

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::CheckManifest functionality.

=head1 DESCRIPTION

Encapsulates Test::CheckManifest functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::CheckManifest>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
