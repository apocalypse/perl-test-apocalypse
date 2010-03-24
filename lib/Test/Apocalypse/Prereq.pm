# Declare our package
package Test::Apocalypse::Prereq;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

# RELEASE test only!
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'Test::Prereq'	=> '1.037',
	);
}

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

Test::Apocalypse::Prereq - Plugin for Test::Prereq

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Prereq functionality.

=head1 DESCRIPTION

Encapsulates Test::Prereq functionality.

NOTE: This test normally takes FOREVER to run! Please set $ENV{PERL_TEST_PREREQ} = 1 in order to enable this test.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Prereq>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
