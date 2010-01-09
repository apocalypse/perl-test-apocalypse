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

	# generate the file list
	my $rule = File::Find::Rule->new;
	$rule->grep( qr/\r\n/ );
	my @files = $rule->in( '.' );

	# for now, we skip SVN + git stuff
	# also skip any tarballs
	@files = grep { $_ !~ /(?:\.svn\/|\.git\/|tar(?:\.gz|\.bz2)?|tgz|zip)/ } @files;

	# test it!
	if ( scalar @files ) {
		fail( 'DOS-style newline detected in the distribution' );
		foreach my $f ( @files ) {
			diag( "DOS-style newline found in: $f" );
		}
	} else {
		pass( 'No files have DOS-style newline in it' );
	}

	return;
}

1;
__END__

=for stopwords dist

=head1 NAME

Test::Apocalypse::DOSnewline - Plugin to detect presence of DOS newlines

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

This plugin detects for the presence of DOS newlines in the dist.

=head1 DESCRIPTION

This plugin detects for the presence of DOS newlines in the dist.

=head1 SEE ALSO

L<Test::Apocalypse>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
