package Test::Apocalypse::PerlCritic;

# ABSTRACT: Plugin for Test::Perl::Critic

use Test::Perl::Critic 1.02;

sub _is_release { 1 }

sub do_test {
	all_critic_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Perl::Critic> functionality.

=cut
