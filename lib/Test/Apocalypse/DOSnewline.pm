# Declare our package
package Test::Apocalypse::DOSnewline;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'File::Find::Rule'	=> '0.32',
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
	plan tests => 1;

	# Find what directories we have
	my @dirs;
	foreach my $d ( qw( lib t examples script xt doc ) ) {	# TODO any other "standard" CPAN dirs?
		if ( -d $d ) {
			push( @dirs, $d );
		}
	}

	# generate the file list
	my $rule = File::Find::Rule->new;
	$rule->grep( qr/\r\n/ );
	my @files = $rule->in( @dirs );

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

=for stopwords dist

=head1 NAME

Test::Apocalypse::DOSnewline - Plugin to detect presence of DOS newlines

=head1 SYNOPSIS

	# Please do not use this module directly.

=head1 ABSTRACT

This plugin detects for the presence of DOS newlines in the dist.

=head1 DESCRIPTION

This plugin detects for the presence of DOS newlines in the dist.

=head1 SEE ALSO

L<Test::Apocalypse>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
