# Declare our package
package Test::Apocalypse::ConsistentVersion;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

sub _load_prereqs {
	return (
		'Test::ConsistentVersion'	=> '0.2.2',
	);
}

sub do_test {
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

=head1 DESCRIPTION

Encapsulates Test::ConsistentVersion functionality. We disable the pod/readme checks because it's not "common practice" to put
them in POD, I think...

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

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
