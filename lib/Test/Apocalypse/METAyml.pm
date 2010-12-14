package Test::Apocalypse::METAyml;

# ABSTRACT: Plugin for Test::YAML::Meta

use Test::YAML::Meta 0.14;

sub do_test {
	meta_yaml_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::YAML::Meta> functionality.

=cut
