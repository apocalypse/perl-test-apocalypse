package Test::Apocalypse::ConsistentVersion;

# ABSTRACT: Plugin for Test::ConsistentVersion

use Test::More;

use Test::ConsistentVersion 0.2.2;

sub do_test {
	Test::ConsistentVersion::check_consistent_versions(
		no_pod		=> 1,
		no_readme	=> 1,
	);

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::ConsistentVersion> functionality. We disable the pod/readme checks because it's not "common practice" to put
them in POD, I think...

=cut
