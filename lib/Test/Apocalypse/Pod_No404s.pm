package Test::Apocalypse::Pod_No404s;

# ABSTRACT: Plugin for Test::Pod::No404s

use Test::More;
use Test::Pod::No404s 0.01;

# Don't hammer the internet on smokers' machines :)
sub _do_automated { 0 }
sub _is_disabled { 'I give up on the internet...' }

sub do_test {
	TODO: {
		local $TODO = "Pod_No404s";
		all_pod_files_ok();
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Pod::No404s> functionality.

=cut
