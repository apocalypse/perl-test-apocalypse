# Declare our package
package Test::Apocalypse::JSONMeta;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.11';

use Test::More;

sub _load_prereqs {
	return (
		'Test::JSON::Meta'	=> '0.04',
	);
}

sub do_test {
	# We need to make sure there's actually a JSON file in the dist!
	if ( -e 'META.json' ) {
		meta_json_ok();
	} else {
		plan skip_all => 'distro did not come with a META.json file';
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::JSONMeta - Plugin for Test::JSON::Meta

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 DESCRIPTION

Encapsulates Test::JSON::Meta functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::JSON::Meta>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
