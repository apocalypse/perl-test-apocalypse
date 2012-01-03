package Test::Apocalypse::Mojibake;

# ABSTRACT: Plugin for Test::Mojibake

use Test::Mojibake 0.3;

sub do_test {
	all_files_encoding_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Mojibake> functionality.

=cut
