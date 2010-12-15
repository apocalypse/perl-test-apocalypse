package Test::Apocalypse::PerlCritic;

# ABSTRACT: Plugin for Test::Perl::Critic

use Test::More;
use Test::Perl::Critic 1.02;

sub _is_release { 1 }
sub _is_todo { 1 }

sub do_test {
	TODO: {
		local $TODO = "PerlCritic";
		all_critic_ok();
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Perl::Critic> functionality.

=cut
