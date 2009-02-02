# Declare our package
package Test::Apocalypse::Dependencies;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.02';

# setup our tests and etc
require Test::Dependencies;

# build up our exclude list of usual installers that we never use() but T::D is stupid to detect :(
my @exclude = qw( Module::Build Module::Install ExtUtils::MakeMaker );

# Also, add some more stupid deps that T::D fucks up
# FIXME we need to figure out how to exclude 'perl' or pester T::D to ignore it!
push( @exclude, 'Test::More' );

# does our stuff!
sub do_test {
	# FIXME Do we need to add the dist module? ( sometimes we never use() it! )

	# run it!
	Test::Dependencies->import( 'exclude' => \@exclude, 'style' => 'light' );
	ok_dependencies();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Dependencies - Plugin for Test::Dependencies

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Dependencies functionality.

=head1 DESCRIPTION

Encapsulates Test::Dependencies functionality.

=head1 EXPORT

None.

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
