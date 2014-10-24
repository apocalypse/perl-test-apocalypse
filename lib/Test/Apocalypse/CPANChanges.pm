package Test::Apocalypse::CPANChanges;

# ABSTRACT: Plugin for Test::CPAN::Changes

use Test::CPAN::Changes 0.30;

sub do_test {
	changes_ok();
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CPAN::Changes> functionality.

=cut
