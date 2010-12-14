package Test::Apocalypse::FilePortability;

# ABSTRACT: Plugin for Test::Portability::Files

# TODO oh please don't set plan in import!
#use Test::Portability::Files 0.05;

sub do_test {
	require Test::Portability::Files;
	Test::Portability::Files->import;
	Test::Portability::Files::run_tests();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Portability::Files> functionality.

=cut
