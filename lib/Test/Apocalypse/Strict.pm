# Declare our package
package Test::Apocalypse::Strict;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

sub _load_prereqs {
	return (
		'Test::Strict'	=> '0.14',
	);
}

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
__END__
=head1 NAME

Test::Apocalypse::Strict - Plugin for Test::Strict

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Strict functionality.

=head1 DESCRIPTION

Encapsulates Test::Strict functionality. We also enable the warnings check.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Strict>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
