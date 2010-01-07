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

	# init CPANTS with the latest tarball
	my $analyzer = Module::CPANTS::Analyse->new({
		'dist'	=> get_tarball(),
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
			ok( $result, "[$type] $metric->{'name'}" );

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
	cleanup_debian_files();

	return;
}

sub get_tarball {
	# get our list of stuff, and try to find the latest tarball
	opendir( my $dir, '.' ) or die "unable to opendir: $!";
	my @dirlist = readdir( $dir );
	closedir( $dir );

	# get the tarballs
	@dirlist = grep { /\.tar\.gz$/ } @dirlist;

	# get the versions
	@dirlist = map { [ $_, $_ ] } @dirlist;
	for ( @dirlist ) {
		$_->[0] =~ s/^.*\-([^\-]+)\.tar\.gz$/$1/;
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
sub cleanup_debian_files {
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
=head1 NAME

Test::Apocalypse::Kwalitee - Plugin for Test::Kwalitee

=head1 SYNOPSIS

	# Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Kwalitee functionality.

=head1 DESCRIPTION

Encapsulates Test::Kwalitee functionality.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Kwalitee>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
