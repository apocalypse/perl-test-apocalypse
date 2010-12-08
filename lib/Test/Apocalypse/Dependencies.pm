# Declare our package
package Test::Apocalypse::Dependencies;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

sub _load_prereqs {
	return (
		'File::Slurp'		=> '9999.13',
		'YAML::Any'		=> '0.72',
		'JSON::Any'		=> '1.25',
		'File::Find::Rule'	=> '0.32',
		'Perl::PrereqScanner'	=> '1.000',
		'Test::Deep'		=> '0.108',
	);
}

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
__END__

=for stopwords metadata

=head1 NAME

Test::Apocalypse::Dependencies - Plugin to check for metadata dependencies

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

Loads the metadata and uses L<Perl::PrereqScanner> to look for dependencies and compares the lists.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
