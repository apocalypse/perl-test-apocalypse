# Declare our package
package Test::Apocalypse::DirChecks;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

sub _load_prereqs {
	return (
		'Test::Dir'	=> '1.006',
	);
}

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
__END__

=for stopwords dist

=head1 NAME

Test::Apocalypse::DirChecks - Plugin to test for directory sanity

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

Encapsulates Test::Dir functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Dir>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
