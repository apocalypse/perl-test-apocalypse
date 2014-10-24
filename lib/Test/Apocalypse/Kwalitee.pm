package Test::Apocalypse::Kwalitee;

# ABSTRACT: Plugin for Test::Kwalitee

use Test::More;
use Module::CPANTS::Analyse 0.95;
use version 0.77;

sub _do_automated { 0 }

sub do_test {
	# the following code was copied/plagarized/transformed from Test::Kwalitee, thanks!
	# The reason why I didn't just use that module is because it doesn't print the kwalitee or consider extra metrics...

	# init CPANTS with the latest tarball
	my $tarball = _get_tarball( '.' );
	if ( ! defined $tarball ) {
		# Dist::Zilla-specific code, the tarball we want is 3 levels up ( when using dzp::TestRelease :)
		# [@Apocalyptic/TestRelease] Extracting /home/apoc/mygit/perl-pod-weaver-pluginbundle-apocalyptic/Pod-Weaver-PluginBundle-Apocalyptic-0.001.tar.gz to .build/MiNXla4CY7
		$tarball = _get_tarball( '../../..' );
		if ( ! defined $tarball ) {
			plan skip_all => 'Distribution tarball not found, unable to run CPANTS Kwalitee tests!';
			return;
		}
	}

	_analyze( $tarball ) if defined $tarball;

	return;
}

sub _analyze {
	my $tarball = shift;

	my $analyzer = Module::CPANTS::Analyse->new({
		'dist'	=> $tarball,
	});

	# set the number of tests / run analyzer
	my @indicators = $analyzer->mck()->get_indicators();
	plan tests => scalar @indicators;
	$analyzer->unpack;
	$analyzer->analyse;
	$analyzer->calc_kwalitee;
	my $kwalitee_points = 0;
	my $available_kwalitee = 0;

	# loop over the kwalitee metrics
	foreach my $gen ( @{ $analyzer->mck()->generators() } ) {
		foreach my $metric ( @{ $gen->kwalitee_indicators() } ) {
			# get the result
			my $result = $metric->{'code'}->( $analyzer->d(), $metric );
			my $type = 'CORE';
			if ( exists $metric->{'is_experimental'} and $metric->{'is_experimental'} ) {
				$type = 'EXPERIMENTAL';
			}
			if ( exists $metric->{'is_extra'} and $metric->{'is_extra'} ) {
				$type = 'EXTRA';
			}

			if ( $type eq 'CORE' or $result ) {
				ok( $result, "[$type] $metric->{'name'}" );
			} else {
				if ( ! $ENV{PERL_APOCALYPSE} ) {
					# non-core tests PASS automatically for ease of use
					pass( "[$type] $metric->{'name'} treated as PASS" );
				} else {
					fail( "[$type] $metric->{'name'}" );
				}
			}

			# print more diag if it failed
			if ( ! $result && $ENV{TEST_VERBOSE} ) {
				diag( '[' . $metric->{'name'} . '] error(' . $metric->{'error'} . ') remedy(' . $metric->{'remedy'} . ')' );
				if ( $metric->{'name'} eq 'prereq_matches_use' or $metric->{'name'} eq 'build_prereq_matches_use' ) {
					require Data::Dumper; ## no critic (Bangs::ProhibitDebuggingModules)
					diag( "module information: " . Data::Dumper::Dumper( $analyzer->d->{'uses'} ) );
				}
			}

			# should we tally up the kwalitee?
			if ( ! exists $metric->{'is_experimental'} || ! $metric->{'is_experimental'} ) {
				# we increment available only for CORE, not extra
				if ( ! exists $metric->{'is_extra'} || ! $metric->{'is_extra'} ) {
					$available_kwalitee++;
				}
				if ( $result ) {
					$kwalitee_points++;
				}
			}
		}
	}

	# for diag, print out the kwalitee of the module
	diag( "Kwalitee rating: " . sprintf( "%.2f%%", 100 * ( $kwalitee_points / $available_kwalitee ) ) . " [$kwalitee_points / $available_kwalitee]" );

	# That piece of crap dumps files all over :(
	_cleanup_debian_files();

	return;
}

sub _get_tarball {
	my $path = shift;

	# get our list of stuff, and try to find the latest tarball
	opendir( my $dir, $path ) or die "Unable to opendir: $!";
	my @dirlist = readdir( $dir );
	closedir( $dir ) or die "Unable to closedir: $!";

	# get the tarballs
	@dirlist = grep { /(?:tar(?:\.gz|\.bz2)?|tgz|zip)$/ } @dirlist;

	# short-circuit
	if ( scalar @dirlist == 0 ) {
		return;
	}

	# get the versions
	@dirlist = map { [ $_, $_ ] } @dirlist;
	for ( @dirlist ) {
		$_->[0] =~ s/^.*\-([^\-]+)(?:tar(?:\.gz|\.bz2)?|tgz|zip)$/$1/;
		$_->[0] = version->new( $_->[0] );
	}

	# sort by version
	@dirlist = reverse sort { $a->[0] <=> $b->[0] } @dirlist;

	# TODO should we use file::spec and stuff here?
	return $path . '/' . $dirlist[0]->[1];
}

# Module::CPANTS::Kwalitee::Distros suck!
#t/a_manifest..............1/1
##   Failed test at t/a_manifest.t line 13.
##          got: 1
##     expected: 0
## The following files are not named in the MANIFEST file: /home/apoc/workspace/VCS-perl-trunk/VCS-2.12.2/Debian_CPANTS.txt
## Looks like you failed 1 test of 1.
#t/a_manifest.............. Dubious, test returned 1 (wstat 256, 0x100)
sub _cleanup_debian_files {
	foreach my $file ( qw( Debian_CPANTS.txt ../Debian_CPANTS.txt ) ) {
		if ( -e $file and -f _ ) {
			my $status = unlink( $file );
			if ( ! $status ) {
				warn "unable to unlink $file";
			}
		}
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords kwalitee

=head1 DESCRIPTION

Encapsulates L<Test::Kwalitee> functionality. This plugin also processes the extra metrics, and prints out the kwalitee as a diag() for info.

=cut
