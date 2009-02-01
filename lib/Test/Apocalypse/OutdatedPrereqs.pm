# Declare our package
package Test::Apocalypse::OutdatedPrereqs;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::More;
use YAML;
use CPANPLUS::Backend;
use CPANPLUS::Configure;
use version;

# does our stuff!
sub do_test {
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
	} else {
		note( "Loaded $file, proceeding with analysis" );
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
		eval "sub Log::Message::Handlers::cp_msg { return }";
		eval "sub Log::Message::Handlers::cp_error { return }";
	}

	# Okay, how many prereqs do we have?
	plan tests => scalar keys %$data;

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
			ok( 1, "Skipping '$prereq' because it is specified as version 0" );
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
		is( $cpanversion, $version, "Comparing '$prereq' to CPAN version" );
	} else {
		ok( 0, "Warning: '$prereq' is not found on CPAN!" );
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::OutdatedPrereqs - Plugin to detect outdated prereqs

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

This plugin detects outdated prereqs in F<META.yml> being specified relative to CPAN.

=head1 DESCRIPTION

This plugin detects outdated prereqs in F<META.yml> being specified relative to CPAN.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
