package Test::Apocalypse::FilePortability;

# ABSTRACT: Plugin for Test::Portability::Files

use Test::More;

use Test::Portability::Files 0.05;

sub do_test {
	run_tests();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Portability::Files> functionality.

=cut
