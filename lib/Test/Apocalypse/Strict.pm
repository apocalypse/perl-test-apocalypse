package Test::Apocalypse::Strict;

# ABSTRACT: Plugin for Test::Strict

use Test::More;

use Test::Strict 0.14;

sub do_test {
	# Argh, Test::Strict's TEST_SKIP requires full paths!
	my @files = Test::Strict::_all_perl_files();
	@files = grep { /(?:Build\.PL|Makefile\.PL|Build)$/ } @files;

	# Set some useful stuff
	local $Test::Strict::TEST_WARNINGS = 1;	# to silence "used only once typo warning"
	local $Test::Strict::TEST_SKIP = \@files;

	local $Test::Strict::TEST_WARNINGS = 1;
	local $Test::Strict::TEST_SKIP = \@files;

	# Run the test!
	all_perl_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Strict> functionality. We also enable the warnings check.

=cut
