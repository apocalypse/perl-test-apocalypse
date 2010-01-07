# Declare our package
package Test::Apocalypse::OutdatedPrereqs;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'YAML'			=> '0.70',
		'CPANPLUS::Configure'	=> '0.88',
		'CPANPLUS::Backend'	=> '0.88',
		'version'		=> '0.77',
		'Module::CoreList'	=> '2.23',
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
	# does META.yml exist?
	if ( -e 'META.yml' and -f _ ) {
		load_yml( 'META.yml' );
	} else {
		# maybe one directory up?
		if ( -e '../META.yml' and -f _ ) {
			load_yml( '../META.yml' );
		} else {
			plan tests => 1;
			fail( 'META.yml is missing, unable to process it!' );
		}
	}

	return;
}

# main entry point
sub load_yml {
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
	$data = $data->{'requires'};
	delete $data->{'perl'} if exists $data->{'perl'};

	# init the backend ( and set some options )
	my $cpanconfig = CPANPLUS::Configure->new;
	$cpanconfig->set_conf( 'verbose' => 0 );
	$cpanconfig->set_conf( 'no_update' => 1 );
	my $cpanplus = CPANPLUS::Backend->new( $cpanconfig );

	# silence CPANPLUS!
	{
		no warnings 'redefine';
		## no critic ( ProhibitStringyEval )
		eval "sub Log::Message::Handlers::cp_msg { return }";
		eval "sub Log::Message::Handlers::cp_error { return }";
	}

	# Okay, how many prereqs do we have?
        if(scalar keys %$data > 0) {
          plan tests => scalar keys %$data;
        } else {
          plan skip_all => "No prereqs";
        }

	# analyze every one of them!
	foreach my $prereq ( keys %$data ) {
		check_cpan( $cpanplus, $prereq, $data->{ $prereq } );
	}

	return;
}

# checks a prereq against CPAN
sub check_cpan {
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
			# FIXME simplistic style of parsing
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

	# Please do not use this module directly.

=head1 ABSTRACT

This plugin detects outdated prereqs in F<META.yml> specified relative to CPAN.

=head1 DESCRIPTION

This plugin detects outdated prereqs in F<META.yml> specified relative to CPAN.

=head1 SEE ALSO

L<Test::Apocalypse>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
