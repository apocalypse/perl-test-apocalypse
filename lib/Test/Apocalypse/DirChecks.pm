# Declare our package
package Test::Apocalypse::DirChecks;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.04';

# setup our tests and etc
use Test::More;
use Test::Dir;

# our list of directories to check
my @dirs = qw( lib t examples );

# does our stuff!
sub do_test {
	plan tests => scalar @dirs;

	# ensure our basic CPAN dist contains everything we need
	foreach my $d ( @dirs ) {
		# scripts is
		dir_exists_ok( $d, "directory $d exists" );
	}

	return;
}

1;
__END__

=for stopwords dist

=head1 NAME

Test::Apocalypse::DirChecks - Plugin to test for directory sanity

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

This plugin ensures basic sanity for the directories in the dist.

=head1 DESCRIPTION

This plugin ensures basic sanity for the directories in the dist.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Dir>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
