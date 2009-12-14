# Declare our package
package Test::Apocalypse::Dependencies;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.05';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::Dependencies'	=> '0.12',
	);

	while (my ($module, $version) = each %MODULES) {
		eval "use $module $version ()";	## no critic ( ProhibitStringyEval )
		next unless $@;

		if ( $ENV{RELEASE_TESTING} ) {
			die 'Could not load release-testing module ' . $module;
		} else {
			plan skip_all => $module . ' not available for testing';
		}
	}

	# build up our exclude list of usual installers that we never use() but T::D is stupid to detect :(
	my @exclude = qw( Module::Build Module::Install ExtUtils::MakeMaker );

	# Also, add some more stupid deps that T::D fucks up
	# FIXME we need to figure out how to exclude 'perl' or pester T::D to ignore it!
	push( @exclude, 'Test::More' );

	# Run the test!
	Test::Dependencies->import( 'exclude' => \@exclude, 'style' => 'light' );
	ok_dependencies();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Dependencies - Plugin for Test::Dependencies

=head1 SYNOPSIS

	# Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Dependencies functionality.

=head1 DESCRIPTION

Encapsulates Test::Dependencies functionality.

We also add some "standard" modules to exclude from the checks.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Dependencies>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
