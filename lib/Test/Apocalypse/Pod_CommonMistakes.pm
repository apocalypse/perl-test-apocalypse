package Test::Apocalypse::Pod_CommonMistakes;

# ABSTRACT: Plugin for Test::Pod::Spelling::CommonMistakes

use Test::Pod::Spelling::CommonMistakes 1.000;

# We don't disable this on automated because it doesn't depend on system binaries or any other whacky stuff :)

sub do_test {
	all_pod_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Pod::Spelling::CommonMistakes> functionality.

=cut
