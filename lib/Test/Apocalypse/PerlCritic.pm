package Test::Apocalypse::PerlCritic;

# ABSTRACT: Plugin for Test::Perl::Critic

sub _is_release { 1 }

use Test::Perl::Critic 1.02;

sub do_test {
	TODO: {
		local $TODO = $TODO = "This is an 'informational' test and shouldn't FAIL";

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
