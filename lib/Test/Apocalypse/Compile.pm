package Test::Apocalypse::Compile;

# ABSTRACT: Plugin for Test::Compile

use Test::More;

use Test::Compile 0.11;

sub do_test {
	all_pm_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Compile> functionality.

=cut
