package Test::Apocalypse::Pod;

# ABSTRACT: Plugin for Test::Pod

use Test::Pod 1.41;

sub _is_release { 1 }

sub do_test {
	all_pod_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Pod> functionality.

=cut
