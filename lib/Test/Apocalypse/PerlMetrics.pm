# Declare our package
package Test::Apocalypse::PerlMetrics;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.10';

use Test::More;

sub _load_prereqs {
	return (
		'Perl::Metrics::Simple'	=> '0.13',
	);
}

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
__END__

=head1 NAME

Test::Apocalypse::PerlMetrics - Plugin for Perl::Metrics::Simple

=head1 SYNOPSIS

	die "Don't use this module directly. Please use Test::Apocalypse instead.";

=head1 ABSTRACT

Encapsulates Perl::Metrics::Simple functionality.

=head1 DESCRIPTION

Encapsulates Perl::Metrics::Simple functionality. Enable TEST_VERBOSE to get a diag() output of some metrics.

=head2 do_test()

The main entry point for this plugin. Automatically called by L<Test::Apocalypse>, you don't need to know anything more :)

=head1 SEE ALSO

L<Test::Apocalypse>

L<Perl::Metrics::Simple>

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
