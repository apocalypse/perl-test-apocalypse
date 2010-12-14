package Test::Apocalypse::CheckChanges;

# ABSTRACT: Plugin for Test::CheckChanges

use Test::More;

use Test::CheckChanges 0.08;

sub do_test {
	ok_changes();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CheckChanges> functionality.

=cut
