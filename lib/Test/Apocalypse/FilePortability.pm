package Test::Apocalypse::FilePortability;

# ABSTRACT: Plugin for Test::Portability::Files

use Test::Portability::Files 0.06;

sub do_test {
	options( all_tests => 1 );
	run_tests();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Portability::Files> functionality.

=cut
