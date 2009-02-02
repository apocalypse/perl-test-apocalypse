# Declare our package
package Test::Apocalypse::DOSnewline;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.02';

# setup our tests and etc
use Test::More;
use File::Find::Rule;

# does our stuff!
sub do_test {
	plan tests => 1;

	# generate the file list
	my $rule = File::Find::Rule->new;
	$rule->grep( qr/\r\n/ );
	my @files = $rule->in( qw( lib t examples ) );	# FIXME sometimes we don't have examples dir, F:F:R complains!

	# FIXME read in MANIFEST.SKIP and use it!
	# for now, we skip SVN + git stuff
	@files = grep { $_ !~ /(?:\/\.svn\/|\/\.git\/)/ } @files;

	# test it!
	if ( scalar @files ) {
		fail( 'DOS-style newline detected' );
		foreach my $f ( @files ) {
			diag( "newline check on $f" );
		}
	} else {
		pass( 'no files have DOS-style newline in it' );
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::DOSnewline - Plugin to detect presence of DOS newlines

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

This plugin detects for the presence of DOS newlines in the dist.

=head1 DESCRIPTION

This plugin detects for the presence of DOS newlines in the dist.

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
