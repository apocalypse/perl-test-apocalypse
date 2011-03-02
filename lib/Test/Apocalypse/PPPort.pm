package Test::Apocalypse::PPPort;

# ABSTRACT: Plugin to test for Devel::PPPort warnings

use Test::More;
use Devel::PPPort 3.19;
use Capture::Tiny 0.10 qw( capture_merged );

sub do_test {
	plan tests => 2;

	# do we have an existing ppport.h file?
	my $haveppport = 0;
	my $needstrip = 0;
	my $ppp = 'ppport.h';
	SKIP: {
		if ( ! -f $ppp ) {
			# generate our own ppport.h file
			Devel::PPPort::WriteFile( $ppp );

			skip( "Distro did not come with a $ppp file", 1 );
		}

		$haveppport++;

		# was it already stripped or not?
		my $oldver = capture_merged { system( $^X, $ppp, '--version' ) };
		if ( length $oldver ) {
			if ( $oldver =~ /^This is ppport\.h ([\d\.]+)$/ms ) {
				fail( "$ppp file needs to be stripped" );
			} else {
				$needstrip++;
				pass( "$ppp file was already stripped" );
			}
		} else {
			die "Unable to run $ppp and get the output";
		}

		# remove it and create a new one so we have the latest one, always
		unlink( $ppp ) or die "Unable to unlink '$ppp': $!";
		Devel::PPPort::WriteFile( $ppp );
	}

	# Then, we run it :)
	my $result = capture_merged { system( $^X, $ppp ) };

	if ( length $result ) {
		# Did we have any xs files?
		if ( $result =~ /^No input files given/m ) {
			pass( 'No XS files detected' );
		} else {
			# is the last line saying "OK" ?
			if ( $result =~ /Looks good$/m ) {
				# Did we get any warnings? Display them in case they're useful...
				my @warns;
				foreach my $l ( split( "\n", $result ) ) {
					if ( $l =~ /^\*\*\*\s+WARNING:\s+/s ) {
						push( @warns, $l );
					}
				}

				if ( @warns ) {
					pass( "$ppp says you are good to go with some warnings" );
					diag( $_ ) for @warns;
				} else {
					pass( "$ppp says you are good to go" );
				}
			} else {
				fail( "$ppp caught some errors" );
				diag( $result );
			}
		}
	} else {
		die "Unable to run $ppp and get the output";
	}

	# remove our generated ppport.h file
	if ( ! $haveppport ) {
		unlink( $ppp ) or die "Unable to unlink '$ppp': $!";
	} else {
		if ( $needstrip ) {
			$result = capture_merged { system( $^X, $ppp, '--strip' ) };
			if ( length $result ) {
				die "Unable to strip $ppp file: $result";
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
