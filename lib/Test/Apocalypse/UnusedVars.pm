package Test::Apocalypse::UnusedVars;

# ABSTRACT: Plugin for Test::Vars

use Test::More;

# TODO Disabled because Test::Vars doesn't like running under a Test::Block :(
# I think I got it to work using Test::More::subtest() but need to test more...
sub _is_disabled { 1 }

sub _is_release { 1 }

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
