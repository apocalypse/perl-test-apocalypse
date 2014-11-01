package Test::Apocalypse::Dependencies;

# ABSTRACT: Plugin to check for metadata dependencies

use Test::More;
use File::Slurp 9999.13;
use YAML::Any 0.72;
use JSON::Any 1.25;
use File::Find::Rule 0.32;
use Perl::PrereqScanner 1.000;
use Test::Deep 0.108;
use CPAN::Meta::Requirements 2.113640;

sub _do_automated { 0 }

sub do_test {
	# load the metadata
	my $runtime_req;
	my $test_req;
	my $provides;
	if ( -e 'META.json' ) {
		my $file = read_file( 'META.json' );
		my $metadata = JSON::Any->new->Load( $file );
		$runtime_req = $metadata->{'prereqs'}{'runtime'}{'requires'};
		$test_req = $metadata->{'prereqs'}{'test'}{'requires'};
		$provides = $metadata->{'provides'} if exists $metadata->{'provides'};
	} elsif ( -e 'META.yml' ) {
		my $file = read_file( 'META.yml' );
		my $metadata = Load( $file );
		$runtime_req = $metadata->{'requires'};
		$provides = $metadata->{'provides'} if exists $metadata->{'provides'};
	} else {
		die 'No META.(json|yml) found!';
	}

	# Okay, scan the files
	my $found_runtime = CPAN::Meta::Requirements->new;
	my $found_test = CPAN::Meta::Requirements->new;
	foreach my $file ( File::Find::Rule->file()->name( qr/\.pm$/ )->in( 'lib' ) ) {
		$found_runtime->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
	}

	# scan the test dir only if we have test metadata
	if ( defined $test_req ) {
		foreach my $file ( File::Find::Rule->file()->name( qr/\.(pm|t|pl)$/ )->in( 't' ) ) {
			$found_test->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
		}
	}

	# Okay, the spec says that anything already in the runtime req shouldn't be listed in test req
	# That means we need to "fake" the prereq and make sure the comparison is OK
	if ( defined $test_req ) {
		my %temp = %{ $found_test->as_string_hash };
		foreach my $mod ( keys %temp ) {
			if ( ! exists $test_req->{ $mod } and exists $runtime_req->{ $mod } ) {
				# don't copy runtime_req's version because it might be different and cmp_deeply will complain!
				$test_req->{ $mod } = $temp{ $mod };
			}
		}
	}

	# We remove any prereqs that we provided in the package
	if ( defined $provides ) {
		foreach my $p ( keys %$provides ) {
			$found_runtime->clear_requirement( $p );
			$found_test->clear_requirement( $p );
		}
	}

	# Thanks to PoCo::SmokeBox::Uploads::Rsync's use of PoCo::Generic, we have to do this
	# Mangle the found version to the required one if it was 0
	{
		my %temp = %{ $found_runtime->as_string_hash };
		foreach my $p ( keys %temp ) {
			# Thanks to Test::Pod::LinkCheck requiring Config we have to do this!
			$runtime_req->{$p} = 0 if ! defined $runtime_req->{$p};

			if ( $runtime_req->{ $p } ne '0' and $temp{ $p } eq '0' ) {
				$found_runtime->clear_requirement( $p );
				$found_runtime->add_minimum( $p => $runtime_req->{ $p } );
			}
		}
	}

	# Do the same for the test stuff
	if ( defined $test_req ) {
		my %temp = %{ $found_test->as_string_hash };
		foreach my $p ( keys %temp ) {
			if ( $test_req->{ $p } ne '0' and $temp{ $p } eq '0' ) {
				$found_test->clear_requirement( $p );
				$found_test->add_minimum( $p => $runtime_req->{ $p } );
			}
		}
	}

	# remove 'perl' dep - we check it in MinimumVersion anyway
	delete $runtime_req->{'perl'} if exists $runtime_req->{'perl'};
	delete $test_req->{'perl'} if defined $test_req and exists $test_req->{'perl'};
	$found_runtime->clear_requirement( 'perl' );
	$found_test->clear_requirement( 'perl' );

	# Convert version objects to regular or we'll get something like this:
	# Compared $data->{"Test\:\:NoPlan"}
	#    got : 'v0.0.6'
	# expect : '0.0.6'
	$found_runtime = $found_runtime->as_string_hash;
	$found_runtime->{ $_ } =~ s/^v// for keys %$found_runtime;
	$runtime_req->{ $_ } =~ s/^v// for keys %$runtime_req;

	# Do the actual comparison!
	if ( defined $test_req ) {
		plan tests => 2;

		$found_test = $found_test->as_string_hash;
		$found_test->{ $_ } =~ s/^v// for keys %$found_test;
		$test_req->{ $_ } =~ s/^v// for keys %$test_req;

		# TODO interesting, somewhere deep in the build chain it auto-upgraded Test::More version...
		# I had 0.88 set but somehow 0.96 was in the META.yml argh!
		if ( $found_test->{'Test::More'} ne $test_req->{'Test::More'} ) {
			diag( 'Found weird Test::More version mismatch, ignoring it! (' . $found_test->{'Test::More'} . ' vs ' . $test_req->{'Test::More'} . ')' );
			$found_test->{'Test::More'} = $test_req->{'Test::More'};
		}
	} else {
		plan tests => 1;
	}

	cmp_deeply( $found_runtime, $runtime_req, "Runtime requires" );
	cmp_deeply( $found_test, $test_req, "Test requires" ) if defined $test_req;

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords metadata

=head1 DESCRIPTION

Loads the metadata and uses L<Perl::PrereqScanner> to look for dependencies and compares the lists.

=cut
