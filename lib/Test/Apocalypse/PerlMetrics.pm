package Test::Apocalypse::PerlMetrics;

# ABSTRACT: Plugin for Perl::Metrics::Simple

use Test::More;

use Perl::Metrics::Simple 0.13;

sub do_test {
	plan tests => 1;
	my $analzyer = Perl::Metrics::Simple->new;
	my $analysis = $analzyer->analyze_files( 'lib/' );
	my $numdisplay = 10;

	## no critic ( ProhibitAccessOfPrivateData )
	if ( ok( $analysis->file_count(), 'Analyzed at least one file' ) ) {
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

			diag( "-- Top$numdisplay subroutines by McCabe Complexity --" );
			my @sorted_subs = sort { $b->{'mccabe_complexity'} <=> $a->{'mccabe_complexity'} } @{ $analysis->subs };
			foreach my $i ( 0 .. ( $numdisplay - 1 ) ) {
				last if ! defined $sorted_subs[$i];

				diag( ' ' . $sorted_subs[$i]->{'path'} . ':' . $sorted_subs[$i]->{'name'} . ' ->' .
					' McCabe(' . $sorted_subs[$i]->{'mccabe_complexity'} . ')' .
					' lines(' . $sorted_subs[$i]->{'lines'} . ')'
				);
			}

			diag( "-- Top$numdisplay subroutines by lines --" );
			@sorted_subs = sort { $b->{'lines'} <=> $a->{'lines'} } @sorted_subs;
			foreach my $i ( 0 .. ( $numdisplay - 1 ) ) {
				last if ! defined $sorted_subs[$i];

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

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Perl::Metrics::Simple> functionality. Enable TEST_VERBOSE to get a diag() output of some metrics.

=cut
