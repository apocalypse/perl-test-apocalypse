# Declare our package
package Test::Apocalypse;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.01';

# setup our tests and etc
use Test::Block qw( $Plan );
use Test::More;
use Module::Pluggable require => 1, search_path => [ __PACKAGE__ ];

# auto-export the only sub we have
use base qw( Exporter );
our @EXPORT = qw( is_apocalypse_here );

sub is_apocalypse_here {
	# arrayref of tests to skip/use/etc
	my $tests = shift;

	# should we even run those tests?
	if ( ! $ENV{TEST_AUTHOR} ) {
		plan skip_all => 'Author test. Sent $ENV{TEST_AUTHOR} to a true value to run.';
	} else {
		plan 'no_plan';
	}

	# loop through our plugins
	foreach my $t ( __PACKAGE__->plugins() ) {
		# localize the stuff
		local $Plan;

		# do nasty override of Test::Builder::plan
		no warnings 'redefine'; no strict 'refs';
		my $oldplan = \&Test::Builder::plan;
		my $newplan = sub {
			my( $self, $cmd, $arg ) = @_;
			return unless $cmd;

			# handle the cmds
			if ( $cmd eq 'skip_all' ) {
				$Plan = 1;
				$self->skip( "skipping $t" );
			} elsif ( $cmd eq 'tests' ) {
				$Plan = $arg;
			} elsif ( $cmd eq 'no_plan' ) {
				# ignore it
			}

			return 1;
		};
		*{'Test::Builder::plan'} = $newplan;

		# run it!
		use warnings; use strict;
		$t->do_test();

		# revert the override
		no warnings 'redefine'; no strict 'refs';
		*{'Test::Builder::plan'} = $oldplan;
	}

	# passed all tests!
	return 1;
}

1;
__END__
=head1 NAME

Test::Apocalypse - Apocalypse's favorite tests bundled into a simple interface

=head1 SYNOPSIS

	#!/usr/bin/perl
	use strict; use warnings;

	use Test::More;

	# AUTHOR test
	if ( not $ENV{TEST_AUTHOR} ) {
		plan skip_all => 'Author test. Sent $ENV{TEST_AUTHOR} to a true value to run.';
	} else {
		eval { use Test::Apocalypse };
		if ( $@ ) {
			plan skip_all => 'Test::Apocalypse required for validating the distribution';
		} else {
			is_apocalypse_here();
		}
	}

=head1 ABSTRACT

Using this test module simplifies/bundles common distribution tests favored by the CPAN id APOCAL.

=head1 DESCRIPTION

=head1 EXPORT

Automatically exports the "is_apocalypse_here" sub.

=head1 SEE ALSO

None.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Apocalypse

=head2 Websites

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Apocalypse>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Apocalypse>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Apocalypse>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Apocalypse>

=back

=head2 Bugs

Please report any bugs or feature requests to C<bug-test-apocalypse at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Apocalypse>.  I will be
notified, and then you'll automatically be notified of progress on your bug as I make changes.

=head1 AUTHOR

Apocalypse E<lt>apocal@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Apocalypse

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
