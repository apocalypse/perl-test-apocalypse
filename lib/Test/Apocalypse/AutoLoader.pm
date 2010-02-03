# Declare our package
package Test::Apocalypse::AutoLoader;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.08';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::AutoLoader'	=> '0.03',
		'YAML'			=> '0.70',
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

# loads a yml file
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
	$data = $data->{'provides'};	## no critic ( ProhibitAccessOfPrivateData )

	# Okay, how many modules do we have?
	if ( scalar keys %$data > 0 ) {
		plan tests => scalar keys %$data;
	} else {
		plan skip_all => "No provided modules found in META.yml";
	}

	# analyze every one of them!
	foreach my $module ( keys %$data ) {
		if ( _module_has_autoload( $module ) ) {
			autoload_ok( $module );
		} else {
			pass( "Skipping '$module' because it has no autoloaded files" );
		}
	}

	return;
}

# basically ripped off from Test::AutoLoader so we don't get the annoying "unable to find autoload directory" failure
sub _module_has_autoload {
	my $pkg = shift;
	my $dirname;

	if (defined($dirname = $INC{"$pkg.pm"})) {
		if ( $^O eq 'MacOS' ) {
			$pkg =~ tr#/#:#;
			$dirname =~ s#^(.*)$pkg\.pm\z#$1auto:$pkg#s;
		} else {
			$dirname =~ s#^(.*)$pkg\.pm\z#$1auto/$pkg#s;
		}
	}
	unless (defined $dirname and -d $dirname && -r _ ) {
		return 0;
	} else {
		return 1;
	}
}

1;
__END__
=head1 NAME

Test::Apocalypse::AutoLoader - Plugin for Test::AutoLoader

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::AutoLoader functionality.

=head1 DESCRIPTION

Encapsulates Test::AutoLoader functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::AutoLoader>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
