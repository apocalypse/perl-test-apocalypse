# Declare our package
package Test::Apocalypse::PPPort;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::More;
use version;
use Devel::PPPort qw( WriteFile );

# does our stuff!
sub do_test {
	plan tests => 2;

	# do we have an existing ppport.h file?
	my $haveppport = 0;
	my $needstrip = 0;
	SKIP: {
		if ( ! -f 'ppport.h' ) {
			# generate our own ppport.h file
			Devel::PPPort::WriteFile( 'ppport.h' );

			skip( 'distro did not come with a ppport.h file', 1 );
		}

		$haveppport++;

		# was it already stripped or not?
		my $oldver = `$^X ppport.h --version`;
		if ( $oldver =~ /^This is ppport\.h ([\d\.]+)$/ ) {
			fail( 'ppport.h file needs to be stripped' );
		} else {
			$needstrip++;
			pass( 'ppport.h file was already stripped' );
		}

		# remove it and create a new one so we have the latest one, always
		unlink( 'ppport.h' ) or die "unable to unlink: $!";
		Devel::PPPort::WriteFile( 'ppport.h' );
	}

	# Then, we run it :)
	my @result = `$^X ppport.h 2>&1`;

	if ( scalar @result ) {
		# Did we have any xs files?
		if ( $result[0] =~ /^No input files given/ ) {
			pass( 'No XS files detected' );
		} else {
			# is the last line saying "OK" ?
			if ( $result[-1] =~ /^Looks good/ ) {
				pass( 'ppport.h says you are good to go' );
			} else {
				fail( 'ppport.h caught some errors' );
				diag( @result );
			}
		}
	} else {
		die 'unable to run ppport.h and get the output';
	}

	# remove our generated ppport.h file
	if ( ! $haveppport ) {
		unlink( 'ppport.h' ) or die "Unable to unlink: $!";
	} else {
		if ( $needstrip ) {
			my @result = `$^X ppport.h --strip 2>&1`;
			if ( scalar @result ) {
				die 'unable to strip ppport.h file';
			}
		}
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::PPPort - Plugin to test for Devel::PPPort warnings

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Plugin to test for Devel::PPPort warnings.

=head1 DESCRIPTION

Plugin to test for Devel::PPPort warnings.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Devel::PPPort>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
