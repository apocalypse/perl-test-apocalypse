# Declare our package
package Test::Apocalypse::OutdatedPrereqs;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

# RELEASE test only!
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'YAML'			=> '0.70',
		'CPANPLUS::Configure'	=> '0.90',
		'CPANPLUS::Backend'	=> '0.90',
		'version'		=> '0.77',
		'Module::CoreList'	=> '2.23',
	);
}

sub do_test {
	# does META.yml exist?
	if ( -e 'META.yml' and -f _ ) {
		_load_yml( 'META.yml' );
	} else {
		# maybe one directory up?
		if ( -e '../META.yml' and -f _ ) {
			_load_yml( '../META.yml' );
		} else {
			plan tests => 1;
			fail( 'META.yml is missing, unable to process it!' );
		}
	}

	return;
}

sub _load_yml {
	# we'll load a file
	my $file = shift;

	# okay, proceed to load it!
	my $data;
	eval {
		$data = YAML::LoadFile( $file );
	};
	if ( $@ ) {
		plan tests => 1;
		fail( "Unable to load $file => $@" );
		return;
	}

	# massage the data
	## no critic ( ProhibitAccessOfPrivateData )
	$data = $data->{'requires'};
	delete $data->{'perl'} if exists $data->{'perl'};

	# init the backend ( and set some options )
	my $cpanconfig = CPANPLUS::Configure->new;
	$cpanconfig->set_conf( 'verbose' => 0 );
	$cpanconfig->set_conf( 'no_update' => 1 );

	# ARGH, CPANIDX doesn't work well with this kind of search...
	if ( $cpanconfig->get_conf( 'source_engine' ) =~ /CPANIDX/ ) {
		diag( "Disabling CPANIDX for CPANPLUS" );
		$cpanconfig->set_conf( 'source_engine' => 'CPANPLUS::Internals::Source::Memory' );
	}

	my $cpanplus = CPANPLUS::Backend->new( $cpanconfig );

	# silence CPANPLUS!
	{
		no warnings 'redefine';
		sub Log::Message::Handlers::cp_msg { return };
		sub Log::Message::Handlers::cp_error { return };
	}

	# Okay, how many prereqs do we have?
	if ( scalar keys %$data == 0 ) {
		plan skip_all => "No prereqs found in META.yml";
		return;
	}

	# Argh, check for CPANPLUS sanity!
#   Failed test 'no warnings'
#   at /usr/local/share/perl/5.10.0/Test/NoWarnings.pm line 45.
# There were 1 warning(s)
# 	Previous test 189 'no breakpoint test of blib/lib/POE/Component/SSLify/ClientHandle.pm'
# 	Key 'archive' (/home/apoc/.cpanplus/01mailrc.txt.gz) is of invalid type for 'Archive::Extract::new' provided by CPANPLUS::Internals::Source::__create_author_tree at /usr/share/perl/5.10/CPANPLUS/Internals/Source.pm line 539
#  at /usr/share/perl/5.10/Params/Check.pm line 565
# 	Params::Check::_store_error('Key \'archive\' (/home/apoc/.cpanplus/01mailrc.txt.gz) is of ...', 1) called at /usr/share/perl/5.10/Params/Check.pm line 345
# 	Params::Check::check('HASH(0x3ce9f50)', 'HASH(0x3cf7b08)') called at /usr/share/perl/5.10/Archive/Extract.pm line 227
	{
		my @warn;
		local $SIG{'__WARN__'} = sub { push @warn, shift };
		my $module = $cpanplus->parse_module( 'module' => 'Test::Apocalypse' );
		if ( @warn ) {
			plan skip_all => "Unable to sanely use CPANPLUS, aborting!";
			return;
		}
	}

	# analyze every one of them!
	plan tests => scalar keys %$data;
	foreach my $prereq ( keys %$data ) {
		_check_cpan( $cpanplus, $prereq, $data->{ $prereq } );
	}

	return;
}

# checks a prereq against CPAN
sub _check_cpan {
	my $backend = shift;
	my $prereq = shift;
	my $version = shift;

	# check CPANPLUS
	my $module = $backend->parse_module( 'module' => $prereq );
	if ( defined $module ) {
		# okay, for starters we check to see if it's version 0 then we skip it
		if ( $version eq '0' ) {
			pass( "Skipping '$prereq' because it is specified as version 0" );
			return;
		}

		# Does the prereq have funky characters that we're unable to process now?
		if ( $version =~ /[<>=,!]+/ ) {
			# simple style of parsing, may blow up in the future!
			my @versions = split( ',', $version );

			# sort them by version, descending
			s/[\s<>=!]+// for @versions;
			@versions = sort { $b <=> $a }
				map { version->new( $_ ) } @versions;

			# pick the highest version to use as comparison
			$version = $versions[0];
		}

		# convert both objects to version objects so we can compare
		$version = version->new( $version ) if ! ref $version;
		my $cpanversion = version->new( $module->version );

		# TODO fix this bug
#		#   Failed test 'Comparing 'Test::NoPlan' to CPAN version'
#		#   at /home/apoc/mygit/perl-test-apocalypse/blib/lib/Test/Apocalypse/OutdatedPrereqs.pm line 144.
#		#          got: 3e-06
#		#     expected: 2e-06
#		t/apocalypse.t .. 862/?

		# check it!
		cmp_ok( $cpanversion, '==', $version, "Comparing '$prereq' to CPAN version" );
	} else {
		my $release = Module::CoreList->first_release( $prereq );
		if ( defined $release ) {
			pass( "Skipping '$prereq' because it is a CORE module" );
		} else {
			fail( "Warning: '$prereq' is not found on CPAN!" );
		}
	}

	return;
}

1;
__END__

=for stopwords CPAN prereq prereqs

=head1 NAME

Test::Apocalypse::OutdatedPrereqs - Plugin to detect outdated prereqs

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

This plugin detects outdated prereqs in F<META.yml> specified relative to CPAN.

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
