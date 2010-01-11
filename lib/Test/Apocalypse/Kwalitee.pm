# Declare our package
package Test::Apocalypse::Kwalitee;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'Module::CPANTS::Analyse'	=> '0.85',
		'version'			=> '0.77',
	);

	while (my ($module, $version) = each %MODULES) {
		eval "use $module $version";	## no critic ( ProhibitStringyEval )
		next unless $@;

		if ( $ENV{RELEASE_TESTING} ) {
			die 'Could not load release-testing module ' . $module . " -> $@";
		} else {
			plan skip_all => $module . ' not available for testing';
		}
	}

	# Run the test!
	# the following code was copied/plagarized/transformed from Test::Kwalitee, thanks!
	# The reason why I didn't just use that module is because it doesn't print the kwalitee or consider extra metrics...

	# init CPANTS with the latest tarball
	my $tarball = _get_tarball();
	if ( ! defined $tarball ) {
		plan skip_all => 'Distribution tarball not found, unable to run CPANTS Kwalitee tests.';
		return;
	}
	my $analyzer = Module::CPANTS::Analyse->new({
		'dist'	=> $tarball,
	});

	# set the number of tests / run analyzer
	my @indicators = $analyzer->mck()->get_indicators();
	plan tests => scalar @indicators - 3;	# remove the problematic tests
	$analyzer->unpack;
	$analyzer->analyse;
	$analyzer->calc_kwalitee;
	my $kwalitee_points = 0;
	my $available_kwalitee = 0;

	# loop over the kwalitee metrics
	foreach my $gen ( @{ $analyzer->mck()->generators() } ) {
		foreach my $metric ( @{ $gen->kwalitee_indicators() } ) {
			# skip problematic ones
			if ( $metric->{'name'} =~ /^(?:is_prereq|prereq_matches_use|build_prereq_matches_use)$/ ) { next }
			#if ( $metric->{'name'} =~ /^(?:is_prereq)$/ ) { next }

			# get the result
			my $result = $metric->{'code'}->( $analyzer->d(), $metric );
			my $type = 'CORE';
			if ( exists $metric->{'is_experimental'} and $metric->{'is_experimental'} ) {
				$type = 'EXPERIMENTAL';
			}
			if ( exists $metric->{'is_extra'} and $metric->{'is_extra'} ) {
				$type = 'EXTRA';
			}

			# non-core tests PASS automatically
			if ( $type eq 'CORE' or $result ) {
				ok( $result, "[$type] $metric->{'name'}" );
			} else {
				pass( "[$type] $metric->{'name'} treated as PASS" );
			}

			# print more diag if it failed
			if ( ! $result && $ENV{TEST_VERBOSE} ) {
				diag( '[' . $metric->{'name'} . '] error(' . $metric->{'error'} . ') remedy(' . $metric->{'remedy'} . ')' );
				if ( $metric->{'name'} eq 'prereq_matches_use' or $metric->{'name'} eq 'build_prereq_matches_use' ) {
					require Data::Dumper;
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
	# get our list of stuff, and try to find the latest tarball
	opendir( my $dir, '.' ) or die "Unable to opendir: $!";
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
	@dirlist = sort { $b->[0] <=> $a->[0] } @dirlist;

	return $dirlist[0]->[1];
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
__END__

=for stopwords kwalitee

=head1 NAME

Test::Apocalypse::Kwalitee - Plugin for Test::Kwalitee

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Kwalitee functionality.

=head1 DESCRIPTION

Encapsulates Test::Kwalitee functionality. This plugin also processes the extra metrics, and prints out the kwalitee as a diag() for info.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Kwalitee>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
