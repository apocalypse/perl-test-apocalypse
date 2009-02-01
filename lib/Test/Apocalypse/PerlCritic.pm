# Declare our package
package Test::Apocalypse::PerlCritic;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
require Test::Perl::Critic;
use File::Spec;

# does our stuff!
sub do_test {
	# FIXME should we skip this?

	# build our default options
	my %opt = (
		'-severity'	=> 'stern',
		'-verbose'	=> 8,		# "[%p] %m at line %l, column %c.  (Severity: %s)\n",
	);

	# Do we have a custom profile?
	my $profile = File::Spec->catfile( 't', 'perlcriticrc' );
	if ( -f $profile ) {
		$opt{'-profile'} = $profile;
	}

	# did we get a severity level?
	if ( exists $ENV{PERL_TEST_CRITIC} and defined $ENV{PERL_TEST_CRITIC} and length $ENV{PERL_TEST_CRITIC} > 1 ) {
		$opt{'-severity'} = $ENV{PERL_TEST_CRITIC};
	}

	# finally, run it!
	Test::Perl::Critic->import( %opt );
	all_critic_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::PerlCritic - Plugin for Test::Perl::Critic

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Perl::Critic functionality.

=head1 DESCRIPTION

Encapsulates Test::Perl::Critic functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Perl::Critic>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
