package Test::Apocalypse::Pod_No404s;

# ABSTRACT: Plugin for Test::Pod::No404s

use Test::More;

sub _is_release { 1 }

use Test::Pod::No404s 0.01;

sub do_test {
	all_pod_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Pod::No404s> functionality.

=cut
