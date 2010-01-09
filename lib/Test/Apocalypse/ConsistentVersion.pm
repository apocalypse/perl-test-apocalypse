# Declare our package
package Test::Apocalypse::ConsistentVersion;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::ConsistentVersion'	=> '0.2.2',
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
	Test::ConsistentVersion::check_consistent_versions(
		no_pod		=> 1,
		no_readme	=> 1,
	);

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::ConsistentVersion - Plugin for Test::ConsistentVersion

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::ConsistentVersion functionality.

=head1 DESCRIPTION

Encapsulates Test::ConsistentVersion functionality. We disable the pod/readme checks because it's not "common practice" to put
them in POD, I think...

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::ConsistentVersion>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut