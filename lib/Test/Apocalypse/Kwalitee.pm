# Declare our package
package Test::Apocalypse::Kwalitee;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::More;
use Cwd qw( cwd );
use Module::CPANTS::Analyse;
use version;

# does our stuff!
sub do_test {
	# the following code was copied/plagarized/transformed from Test::Kwalitee, thanks!

	# init CPANTS with the latest tarball
	my $analyzer = Module::CPANTS::Analyse->new({
	#	'distdir'	=> cwd(),
	#	'dist'		=> cwd(),
		'dist'	=> get_tarball(),
	});

	# set the number of tests / run analyzer
	my @indicators = $analyzer->mck()->get_indicators();
	plan tests => scalar @indicators;
	$analyzer->unpack;
	$analyzer->analyse;
	$analyzer->calc_kwalitee;

	# loop over the kwalitee metrics
	foreach my $gen ( @{ $analyzer->mck()->generators() } ) {
		# let it analyze the data
		#$gen->analyse( $analyzer );

		foreach my $metric ( @{ $gen->kwalitee_indicators() } ) {
			# skip problematic ones
			#if ( $metric->{'name'} =~ /^(?:extracts_nicely|has_version|has_proper_version)$/ ) { next }

			# get the result
			my $result = $metric->{'code'}->( $analyzer->d(), $metric );
			ok( $result, $metric->{'name'} );

			# print more diag if it failed
			if ( ! $result ) {
				diag( '[' . $metric->{'name'} . '] error(' . $metric->{'error'} . ') remedy(' . $metric->{'remedy'} . ')' );
			}
		}
	}

	# for diag, print out the kwalitee of the module
	if ( $ENV{TEST_VERBOSE} ) {
		diag( "Total Kwalitee: " . $analyzer->mck()->total_kwalitee() );
	}

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

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Kwalitee functionality.

=head1 DESCRIPTION

Encapsulates Test::Kwalitee functionality.

=head1 EXPORT

None.

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
