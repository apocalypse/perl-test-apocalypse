package Test::Apocalypse::Distribution;

# ABSTRACT: Plugin for Test::Distribution

use Test::More;

use Test::Distribution 2.00 ();

sub do_test {
	# we ignore podcover because we already have a plugin for it...
	Test::Distribution->import( not => 'podcover', distversion => 1 );

	return;
}

1;

=pod

=for Pod::Coverage do_test

=for stopwords distversion podcover

=head1 DESCRIPTION

Encapsulates L<Test::Distribution> functionality. We disable the podcover test, as we already have a plugin for that. Also, we enable the
distversion test.

=cut
