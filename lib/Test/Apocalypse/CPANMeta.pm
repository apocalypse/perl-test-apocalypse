package Test::Apocalypse::CPANMeta;

# ABSTRACT: Plugin for Test::CPAN::Meta

use Test::CPAN::Meta 0.13;

sub do_test {
	meta_yaml_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Meta> functionality.

=cut
