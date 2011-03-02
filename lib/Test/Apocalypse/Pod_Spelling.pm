package Test::Apocalypse::Pod_Spelling;

# ABSTRACT: Plugin for Test::Spelling

use Test::More;
use Test::Spelling 0.11;
use File::Spec 3.31;
use File::Which 1.09;

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
			if ( $word =~ /^(.+)\.\w+$/ ) {
				add_stopwords( $1 );
			} else {
				add_stopwords( $word );
			}
		}
	}

	# Run the test!
	TODO: {
		local $TODO = "Pod_Spelling";
		all_pod_files_spelling_ok();
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords spellchecker stopword stopwords pm

=head1 DESCRIPTION

Encapsulates L<Test::Spelling> functionality. We also add each filename as a stopword, to reduce "noise" from the spellchecker.

If you need to add stopwords, please look at L<Pod::Spell> for ways to add it to each .pm file!

=cut
