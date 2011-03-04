package Test::Apocalypse::EOL;

# ABSTRACT: Plugin for Test::EOL

use Test::EOL 0.3;

# TODO If a win32 user downloads the tarball, it will have DOS newlines in it?
sub _do_automated { 0 }

sub do_test {
	all_perl_files_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::EOL> functionality.

=cut
