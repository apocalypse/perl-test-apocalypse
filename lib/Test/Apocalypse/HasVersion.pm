# Declare our package
package Test::Apocalypse::HasVersion;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::HasVersion;

# does our stuff!
sub do_test {
	all_pm_version_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::HasVersion - Plugin for Test::HasVersion

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::HasVersion functionality.

=head1 DESCRIPTION

Encapsulates Test::HasVersion functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::HasVersion>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
