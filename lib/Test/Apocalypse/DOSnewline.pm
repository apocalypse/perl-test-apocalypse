package Test::Apocalypse::DOSnewline;

# ABSTRACT: Plugin to detect presence of DOS newlines

use Test::More;
use File::Find::Rule 0.32;

# TODO If a win32 user downloads the tarball, it will have DOS newlines in it?
sub _do_automated { 0 }

sub do_test {
	plan tests => 1;

	# generate the file list
	my @files = File::Find::Rule->grep( qr/\r\n/ )->in( '.' );

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

=pod

=for Pod::Coverage do_test

=for stopwords dist

=head1 DESCRIPTION

This plugin detects the presence of DOS newlines in the dist.

=cut
