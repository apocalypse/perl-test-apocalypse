package Test::Apocalypse::HasVersion;

# ABSTRACT: Plugin for Test::HasVersion

use Test::HasVersion 0.012;

sub do_test {
	all_pm_version_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::HasVersion> functionality.

=cut
