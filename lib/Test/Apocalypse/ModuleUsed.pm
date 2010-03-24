# Declare our package
package Test::Apocalypse::ModuleUsed;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

# RELEASE test only!
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'Test::Module::Used'	=> '0.1.2',
	);
}

sub do_test {
	Test::Module::Used->new->ok;

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::ModuleUsed - Plugin for Test::Module::Used

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Module::Used functionality.

=head1 DESCRIPTION

Encapsulates Test::Module::Used functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Module::Used>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
