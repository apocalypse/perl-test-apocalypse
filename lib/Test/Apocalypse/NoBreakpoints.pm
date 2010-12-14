package Test::Apocalypse::NoBreakpoints;

# ABSTRACT: Plugin for Test::NoBreakpoints

use Test::More;

use Test::NoBreakpoints 0.13;

sub do_test {
	all_files_no_breakpoints_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::NoBreakpoints> functionality.

=cut
