# Declare our package
package Test::Apocalypse::CPANMeta;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

sub _load_prereqs {
	return (
		'Test::CPAN::Meta'	=> '0.13',
	);
}

sub do_test {
	meta_yaml_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::CPANMeta - Plugin for Test::CPAN::Meta

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::CPAN::Meta functionality.

=head1 DESCRIPTION

Encapsulates Test::CPAN::Meta functionality.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::CPAN::Meta>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
