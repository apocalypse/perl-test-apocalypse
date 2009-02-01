# Declare our package
package Test::Apocalypse::Fixme;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::Fixme;

# does our stuff!
sub do_test {
	run_tests(
		'where'		=> 'lib',
		'match'		=> qr/[F]IXME|[T]ODO|[X]XX/,
	);

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Fixme - Plugin for Test::Fixme

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Fixme functionality.

=head1 DESCRIPTION

Encapsulates Test::Fixme functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Fixme>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
