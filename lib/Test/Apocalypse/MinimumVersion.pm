package Test::Apocalypse::MinimumVersion;

# ABSTRACT: Plugin for Test::MinimumVersion

use Test::MinimumVersion 0.101080;

sub do_test {
	all_minimum_version_from_metayml_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::MinimumVersion> functionality.

=cut
