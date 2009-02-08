# Declare our package
package Test::Apocalypse::Distribution;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.04';

# setup our tests and etc
require Test::Distribution;

# does our stuff!
sub do_test {
	# skip podcover because it is redundant
	# FIXME is setting distversion too excessive?
	Test::Distribution->import( not => 'podcover', distversion => 1 );

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Distribution - Plugin for Test::Distribution

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Distribution functionality.

=head1 DESCRIPTION

Encapsulates Test::Distribution functionality.

=head1 EXPORT

None.

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
