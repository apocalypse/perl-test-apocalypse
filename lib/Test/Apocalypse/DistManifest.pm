package Test::Apocalypse::DistManifest;

# ABSTRACT: Plugin for Test::DistManifest

use Test::More;

use Test::DistManifest 1.005;

sub do_test {
	manifest_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::DistManifest> functionality.

=cut
