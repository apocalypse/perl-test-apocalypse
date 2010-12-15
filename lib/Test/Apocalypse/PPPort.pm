package Test::Apocalypse::PPPort;

# ABSTRACT: Plugin to test for Devel::PPPort warnings

use Test::More;
use Devel::PPPort 3.19;

sub _is_release { 1 }

sub do_test {
	plan tests => 2;

	# do we have an existing ppport.h file?
	my $haveppport = 0;
	my $needstrip = 0;
	SKIP: {
		if ( ! -f 'ppport.h' ) {
			# generate our own ppport.h file
			Devel::PPPort::WriteFile( 'ppport.h' );

			skip( 'Distro did not come with a ppport.h file', 1 );
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
		unlink( 'ppport.h' ) or die "Unable to unlink 'ppport.h': $!";
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
		die 'Unable to run ppport.h and get the output';
	}

	# remove our generated ppport.h file
	if ( ! $haveppport ) {
		unlink( 'ppport.h' ) or die "Unable to unlink 'ppport.h': $!";
	} else {
		if ( $needstrip ) {
			my @result = `$^X ppport.h --strip 2>&1`;
			if ( scalar @result ) {
				die 'Unable to strip ppport.h file';
			}
		}
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords ppport

=head1 DESCRIPTION

Plugin to test for L<Devel::PPPort> warnings. It automatically updates your bundled F<ppport.h> file to the latest provided by L<Devel::PPPort>!
Also, it will strip the F<ppport.h> file to make it smaller.

=cut
