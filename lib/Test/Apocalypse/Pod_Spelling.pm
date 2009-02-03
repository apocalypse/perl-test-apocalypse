# Declare our package
package Test::Apocalypse::Pod_Spelling;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::Spelling;

# our list of common stopwords
my @stopwords = qw( AnnoCPAN CPAN RT dist prereqs API XS );

# FIXME figure this out per-dist! I'm adding myself for now :)
push( @stopwords, 'APOCAL' );

# does our stuff!
sub do_test {
	# Add our global list of stopwords
	add_stopwords( @stopwords );

	all_pod_files_spelling_ok();

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::Pod_Spelling - Plugin for Test::Spelling

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Test::Spelling functionality.

=head1 DESCRIPTION

Encapsulates Test::Spelling functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Test::Spelling>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
