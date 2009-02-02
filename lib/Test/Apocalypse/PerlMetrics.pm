# Declare our package
package Test::Apocalypse::PerlMetrics;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.02';

# setup our tests and etc
use Test::More;
use Perl::Metrics::Simple;

# Set some constants
BEGIN {
	if ( ! defined &NUMDISPLAY ) { *NUMDISPLAY = sub () { 10 } }
}

# does our stuff!
sub do_test {
	# do it!
	plan tests => 1;
	my $analzyer = Perl::Metrics::Simple->new;
	my $analysis = $analzyer->analyze_files( 'lib/' );

	if ( ok( $analysis->file_count(), 'analyzed at least one file' ) ) {
		# only print extra stuff if necessary
		if ( $ENV{TEST_VERBOSE} ) {
			diag( '-- Perl Metrics Summary --' );
			diag( ' File Count: ' . $analysis->file_count );
			diag( ' Package Count: ' . $analysis->package_count );
			diag( ' Subroutine Count: ' . $analysis->sub_count );
			diag( ' Total Code Lines: ' . $analysis->lines );
			diag( ' Non-Sub Lines: ' . $analysis->main_stats->{'lines'} );

			diag( '-- Subrotuine Metrics Summary --' );
			my $summary_stats = $analysis->summary_stats;
			diag( ' Min: lines(' . $summary_stats->{sub_length}->{min} . ') McCabe(' . $summary_stats->{sub_complexity}->{min} . ')' );
			diag( ' Max: lines(' . $summary_stats->{sub_length}->{max} . ') McCabe(' . $summary_stats->{sub_complexity}->{max} . ')' );
			diag( ' Mean: lines(' . $summary_stats->{sub_length}->{mean} . ') McCabe(' . $summary_stats->{sub_complexity}->{mean} . ')' );
			diag( ' Standard Deviation: lines(' . $summary_stats->{sub_length}->{standard_deviation} . ') McCabe(' . $summary_stats->{sub_complexity}->{standard_deviation} . ')' );
			diag( ' Median: lines(' . $summary_stats->{sub_length}->{median} . ') McCabe(' . $summary_stats->{sub_complexity}->{median} . ')' );

			diag( "-- Top" . NUMDISPLAY() . " subroutines by McCabe Complexity --" );
			my @sorted_subs = sort { $b->{'mccabe_complexity'} <=> $a->{'mccabe_complexity'} } @{ $analysis->subs };
			foreach my $i ( 0 .. ( NUMDISPLAY() - 1 ) ) {
				diag( ' ' . $sorted_subs[$i]->{'path'} . ':' . $sorted_subs[$i]->{'name'} . ' ->' .
					' McCabe(' . $sorted_subs[$i]->{'mccabe_complexity'} . ')' .
					' lines(' . $sorted_subs[$i]->{'lines'} . ')'
				);
			}

			diag( "-- Top" . NUMDISPLAY() . " subroutines by lines --" );
			@sorted_subs = sort { $b->{'lines'} <=> $a->{'lines'} } @sorted_subs;
			foreach my $i ( 0 .. ( NUMDISPLAY() - 1 ) ) {
				diag( ' ' . $sorted_subs[$i]->{'path'} . ':' . $sorted_subs[$i]->{'name'} . ' ->' .
					' lines(' . $sorted_subs[$i]->{'lines'} . ')' .
					' McCabe(' . $sorted_subs[$i]->{'mccabe_complexity'} . ')'
				);
			}

			#require Data::Dumper;
			#diag( 'Summary Stats: ' . Data::Dumper::Dumper( $analysis->summary_stats ) );
			#diag( 'File Stats: ' . Data::Dumper::Dumper( $analysis->file_stats ) );
		}
	}

	return;
}

1;
__END__
=head1 NAME

Test::Apocalypse::PerlMetrics - Plugin for Perl::Metrics::Simple

=head1 SYNOPSIS

	Please do not use this module directly.

=head1 ABSTRACT

Encapsulates Perl::Metrics::Simple functionality.

=head1 DESCRIPTION

Encapsulates Perl::Metrics::Simple functionality.

=head1 EXPORT

None.

=head1 SEE ALSO

L<Test::Apocalypse>

L<Perl::Metrics::Simple>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
