# Declare our package
package Test::Apocalypse::Strict;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.02';

# setup our tests and etc
use Test::Strict;

# does our stuff!
sub do_test {
	all_perl_files_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Strict - Plugin for Test::Strict

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Strict functionality.

=head1 DESCRIPTION

Encapsulates Test::Strict functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Strict>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
