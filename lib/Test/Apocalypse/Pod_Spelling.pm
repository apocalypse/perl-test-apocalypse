# Declare our package
package Test::Apocalypse::Pod_Spelling;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.06';

use Test::More;

sub do_test {
	my %MODULES = (
		'Test::Spelling'	=> '0.11',
		'File::Spec'		=> '3.31',
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

	# get our list of files, and add the "namespaces" as stopwords
	foreach my $p ( Test::Spelling::all_pod_files() ) {
		foreach my $word ( File::Spec->splitdir( $p ) ) {
			next if ! length $word;
			if ( $word eq 'lib' or $word eq 'blib' ) { next }
			if ( $word =~ /^(.+)\.pm$/ ) { $word = $1 }

			add_stopwords( $word );
		}
	}

	# Add our "common" perl crap that the spellchecker doesn't catch!
	add_stopwords( qw( annocpan cpan http poe rt stdin todo xs yaml stdout yml fixme perl
		csv db backpan lwp sqlite backend hardcode svn git cvs plugin unicode ppport ) );

	# Run the test!
	all_pod_files_spelling_ok();

	return;
}

1;
__END__

=for stopwords spellchecker stopword stopwords pm

=head1 NAME

Test::Apocalypse::Pod_Spelling - Plugin for Test::Spelling

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Test::Spelling functionality.

=head1 DESCRIPTION

Encapsulates Test::Spelling functionality. We also add each filename as a stopword, to reduce "noise" from the spellchecker.

If you need to add stopwords, please look at L<Pod::Spell> for ways to add it to each .pm file!

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Spelling>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
