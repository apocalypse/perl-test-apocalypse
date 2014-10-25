package Test::Apocalypse::CPANMeta_JSON;

# ABSTRACT: Plugin for Test::CPAN::Meta

use Test::More;
use Test::CPAN::Meta::JSON 0.10;

# We need to make sure there's actually a JSON file in the dist!
sub _is_disabled {
	if ( ! -e 'META.json' ) {
		return 'Distro did not come with a META.json file';
	}
}

sub do_test {
	meta_json_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Meta::JSON> functionality.

=cut
