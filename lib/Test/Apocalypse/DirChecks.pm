package Test::Apocalypse::DirChecks;

# ABSTRACT: Plugin for Test::Dir

use Test::More;
use Test::Dir 1.006;

sub do_test {
	my @dirs = qw( lib t examples );
	plan tests => scalar @dirs * 2;
	foreach my $d ( @dirs ) {
		dir_exists_ok( $d, "Directory '$d' exists" );
		ok( -r $d, "Directory '$d' is readable" );
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Dir> functionality.

=cut
