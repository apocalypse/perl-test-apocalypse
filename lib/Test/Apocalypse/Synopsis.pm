package Test::Apocalypse::Synopsis;

# ABSTRACT: Plugin for Test::Synopsis

use Test::More;

use Test::Synopsis 0.06;

sub do_test {
	all_synopsis_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Synopsis> functionality.

=cut
