# Declare our package
package Test::Apocalypse::Prereq_Build;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.04';

# setup our tests and etc
use Test::More;
use Test::Prereq::Build;

# does our stuff!
sub do_test {
	if ( not $ENV{PERL_TEST_PREREQ} ) {
		plan skip_all => 'PREREQ test ( warning: LONG! ) Sent $ENV{PERL_TEST_PREREQ} to a true value to run.';
	} else {
		prereq_ok();
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Prereq_Build - Plugin for Test::Prereq::Build

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Prereq::Build functionality.

=head1 DESCRIPTION

Encapsulates Test::Prereq::Build functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Prereq::Build>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
