package Test::Apocalypse::Prereq_Build;

# ABSTRACT: Plugin for Test::Prereq::Build

use Test::More;

sub _is_release { 1 }

use Test::Prereq::Build 1.037;

sub do_test {
	if ( not $ENV{PERL_TEST_PREREQ} ) {
		plan skip_all => 'PREREQ test ( warning: LONG! ) Sent $ENV{PERL_TEST_PREREQ} to a true value to run.';
	} else {
		prereq_ok();
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Prereq::Build> functionality.

NOTE: This test normally takes FOREVER to run! Please set $ENV{PERL_TEST_PREREQ} = 1 in order to enable this test.

=cut
