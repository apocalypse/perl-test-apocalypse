# Declare our package
package Test::Apocalypse::Pod_Spelling;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

# RELEASE test only!
# TODO because goddamn spelling test almost always FAILs even with stopwords added to it...
sub _do_automated { 0 }

sub _load_prereqs {
	return (
		'Test::Spelling'	=> '0.11',
		'File::Spec'		=> '3.31',
		'File::Which'		=> '1.09',
	);
}

sub do_test {
	# Thanks to CPANTESTERS, not everyone have "spell" installed...
	# FIXME pester Test::Spelling author to be more smarter about this failure mode!
	my $binary = which( 'spell' );
	if ( ! defined $binary ) {
		plan skip_all => 'The binary "spell" is not found, unable to test spelling!';
		return;
	} else {
		# Set the spell path, to be sure!
		set_spell_cmd( $binary );
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

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

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
