package Test::Apocalypse::Dependencies;

# ABSTRACT: Plugin to check for metadata dependencies

use Test::More;

use File::Slurp 9999.13;
use YAML::Any 0.72;
use JSON::Any 1.25;
use File::Find::Rule 0.32;
use Perl::PrereqScanner 1.000;
use Test::Deep 0.108;

sub do_test {
	# load the metadata
	my $runtime_req;
	my $test_req;
	if ( -e 'META.json' ) {
		my $file = read_file( 'META.json' );
		my $metadata = JSON::Any->new->Load( $file );
		$runtime_req = $metadata->{'prereqs'}{'runtime'}{'requires'};
		$test_req = $metadata->{'prereqs'}{'test'}{'requires'};
	} elsif ( -e 'META.yml' ) {
		my $file = read_file( 'META.yml' );
		my $metadata = Load( $file );
		$runtime_req = $metadata->{'requires'};
	} else {
		die 'No META.(json|yml) found!';
	}

	# remove 'perl' dep
	# TODO should we use Perl::MinimumVersion to scan for perl ver to sanity check?
	delete $runtime_req->{'perl'} if exists $runtime_req->{'perl'};
	delete $test_req->{'perl'} if defined $test_req and exists $test_req->{'perl'};

	# Okay, scan the files
	my $req_runtime = Version::Requirements->new;
	my $req_test = Version::Requirements->new;
	foreach my $file ( File::Find::Rule->file()->name( qr/\.pm$/ )->in( 'lib' ) ) {
		$req_runtime->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
	}

	# scan the test dir only if we have test metadata
	if ( defined $test_req ) {
		foreach my $file ( File::Find::Rule->file()->name( qr/\.(pm|t|pl)$/ )->in( 't' ) ) {
			$req_test->add_requirements( Perl::PrereqScanner->new->scan_file( $file ) );
		}
	}

	# Do the actual comparison!
	if ( defined $test_req ) {
		plan tests => 2;
	} else {
		plan tests => 1;
	}

	cmp_deeply( $req_runtime->as_string_hash, $runtime_req, "Runtime requires" );
	cmp_deeply( $req_test->as_string_hash, $test_req, "Test requires" ) if defined $test_req;

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords metadata

=head1 DESCRIPTION

Loads the metadata and uses L<Perl::PrereqScanner> to look for dependencies and compares the lists.

=cut
