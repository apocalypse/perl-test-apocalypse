# Declare our package
package Test::Apocalypse::Pod_Coverage;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::More;
use Test::Pod::Coverage;

# does our stuff!
sub do_test {
	# FIXME not used now
	#all_pod_coverage_ok( 'lib/');
	plan skip_all => 'not done yet';

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Pod_Coverage - Plugin for Test::Pod::Coverage

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Pod::Coverage functionality.

=head1 DESCRIPTION

Encapsulates Test::Pod::Coverage functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Pod::Coverage>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
