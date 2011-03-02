package Test::Apocalypse::CPANMeta_YAML;

# ABSTRACT: Plugin for Test::CPAN::Meta

use Test::CPAN::Meta::YAML 0.17;

sub do_test {
	meta_yaml_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Meta::YAML> functionality.

=cut
