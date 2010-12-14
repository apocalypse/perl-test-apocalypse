package Test::Apocalypse::UseAllModules;

# ABSTRACT: Plugin for Test::UseAllModules

use Test::UseAllModules 0.12;

sub do_test {
	all_uses_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::UseAllModules> functionality.

=cut
