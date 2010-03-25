# Declare our package
package Test::Apocalypse::Dependencies;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

# RELEASE test only!
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'Test::Dependencies'	=> '0.12 ()',
	);
}

sub do_test {
	# build up our exclude list of usual installers that we never use() but T::D is stupid to detect :(
	my @exclude = qw( Module::Build Module::Install ExtUtils::MakeMaker );

	# Also, add some more stupid deps that T::D fucks up
	push( @exclude, 'Test::More' );

	Test::Dependencies->import( exclude => \@exclude, style => 'light' );
	ok_dependencies();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Dependencies - Plugin for Test::Dependencies

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Dependencies functionality.

=head1 DESCRIPTION

Encapsulates Test::Dependencies functionality. We enable the "light" style of parsing. We also add some "standard" modules to exclude from the checks.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Dependencies>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
