package Test::Apocalypse::CPANMeta_JSON;

# ABSTRACT: Plugin for Test::CPAN::Meta

use Test::More;
use Test::CPAN::Meta::JSON 0.10;

sub do_test {
	# We need to make sure there's actually a JSON file in the dist!
	if ( -e 'META.json' ) {
		meta_json_ok();
	} else {
		plan skip_all => 'distro did not come with a META.json file';
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Meta::JSON> functionality.

=cut
