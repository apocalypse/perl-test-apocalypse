# Declare our package
package Test::Apocalypse::NoPlan;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

sub _load_prereqs {
	return (
		'Test::NoPlan'	=> '0.0.2',	# TODO wait for new version that fixes Test::Builder::create() error
	);
}

sub do_test {
	all_plans_ok( {
		'topdir'	=> 't',
		'recurse'	=> 1,
	} );

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::CPANMeta - Plugin for Test::NoPlan

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::NoPlan functionality.

=head1 DESCRIPTION

Encapsulates Test::NoPlan functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::NoPlan>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
