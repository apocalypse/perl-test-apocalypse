# Declare our package
package Test::Apocalypse::FilePortability;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::Portability::Files;

# does our stuff!
sub do_test {
	run_tests();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::FilePortability - Plugin for Test::Portability::Files

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Portability::Files functionality.

=head1 DESCRIPTION

Encapsulates Test::Portability::Files functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Portability::Files>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
