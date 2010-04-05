# Declare our package
package Test::Apocalypse::UnusedVars;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

# TODO Disabled because Test::Vars doesn't like running under a Test::Block :(
# I think I got it to work using Test::More::subtest() but need to test more...
sub _is_disabled { 1 }

# RELEASE test only!
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'Test::Vars'	=> '0.001',
	);
}

sub do_test {
	all_vars_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::UnusedVars - Plugin for Test::Vars

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

Encapsulates Test::Vars functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Vars>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
