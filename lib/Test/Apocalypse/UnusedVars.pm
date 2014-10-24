package Test::Apocalypse::UnusedVars;

# ABSTRACT: Plugin for Test::Vars

use Test::Vars 0.001;

sub do_test {
	all_vars_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Vars> functionality.

=cut
