# Declare our package
package Test::Apocalypse;
use strict; use warnings;

# Initialize our version
use vars qw( $VERSION );
$VERSION = '0.03';

# setup our tests and etc
use Test::Block qw( $Plan );
use Test::More;
use Test::Builder;
use Module::Pluggable require => 1, search_path => [ __PACKAGE__ ];

# auto-export the only sub we have
use base qw( Exporter );
our @EXPORT = qw( is_apocalypse_here ); ## no critic ( ProhibitAutomaticExportation )

sub is_apocalypse_here {
	# arrayref of tests to skip/use/etc
	my $tests = shift;

	# should we even run those tests?
	if ( ! $ENV{TEST_AUTHOR} ) {
		plan skip_all => 'Author test. Sent $ENV{TEST_AUTHOR} to a true value to run.';
	} else {
		plan 'no_plan';

		# load our nifty "catch-all" tests
		eval "use Test::NoWarnings";		## no critic ( ProhibitStringyEval )
	}

	# loop through our plugins
	foreach my $t ( __PACKAGE__->plugins() ) {	## no critic ( RequireExplicitInclusion )
		# localize the stuff
		local $Plan;

		# do nasty override of Test::Builder::plan
		my $oldplan = \&Test::Builder::plan;		## no critic ( ProhibitCallsToUnexportedSubs )
		my $newplan = sub {
			my( $self, $cmd, $arg ) = @_;
			return unless $cmd;

			# handle the cmds
			if ( $cmd eq 'skip_all' ) {
				$Plan = { $t => 1 };
				SKIP: {
					$self->skip( "skipping $t", 1 );
				}
			} elsif ( $cmd eq 'tests' ) {
				$Plan = { $t => $arg };
			} elsif ( $cmd eq 'no_plan' ) {
				# ignore it
				$Plan = { $t => 0 };
			}

			return 1;
		};

		no warnings 'redefine'; no strict 'refs';
		*{'Test::Builder::plan'} = $newplan;

		# run it!
		use warnings; use strict;
		diag( "running $t tests..." );
		$t->do_test();

		# revert the override
		no warnings 'redefine'; no strict 'refs';
		*{'Test::Builder::plan'} = $oldplan;
	}

	# done with testing
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
	eval "use Test::Apocalypse";
	if ( $@ ) {
		plan skip_all => 'Test::Apocalypse required for validating the distribution';
	} else {
		# lousy hack for kwalitee
		require Test::NoWarnings; require Test::Pod; require Test::Pod::Coverage;
		is_apocalypse_here();
	}

=head1 ABSTRACT

Using this test module simplifies/bundles common distribution tests favored by the CPAN id APOCAL.

=head1 DESCRIPTION

This module greatly simplifies common author tests for modules heading towards CPAN. I was sick of copy/pasting
the tons of t/foo.t scripts + managing them in every distro. I thought it would be nice to bundle all of it into
one module and toss it on CPAN :) That way, every time I update this module all of my dists would be magically
updated!

This module respects the TEST_AUTHOR env variable, if it is not set it will skip the entire testsuite. Normally
end-users should not run it; but you can if you want to see how bad my dists are, ha!

This module uses L<Module::Pluggable> to have custom "backends" that process various tests. We wrap them in a hackish
L<Test::Block> block per-plugin and it seems to work nicely. If you want to write your own, it should be a breeze
once you look at some of my plugins and see how it works. ( more documentation to come )

=head2 Usage

In order to use this, you would need to be familiar with the "standard" steps in order to fully exercise the testsuite.
There are a few steps we require, because our plugins need stuff to be prepared for them. For starters, you would need
a test file in your distribution similar to the one in SYNOPSIS. Once that is done and added to your MANIFEST and etc,
you can do this:

	perl Build.PL			# sets up the dist ( duh, hah )
	./Build dist			# makes the tarball ( so certain plugins can process it )
	TEST_AUTHOR=1 ./Build test	# runs the testsuite!

=head1 EXPORT

Automatically exports the "is_apocalypse_here" sub.

=head1 MORE IDEAS

=over 4

=item * Document the way we do plugins so others can add to this testsuite :)

=item * Per-plugin configuration for distros so we can override the default config

=item * POD standards check

Do we have SYNOPSIS, ABSTRACT, SUPPORT, etc sections?

=item * Use Test::AutoLoader to check for .al files

Br0ken install at this time...

=item * Help with version updates automatically

This little snippet helps a lot, I was wondering if I could integrate it into the testsuite hah!

	find -name '*.pm' | grep -v /blib/ | xargs sed -i "s/\$VERSION = '[^']\+\?';/\$VERSION = '0.03';/"

=item * Help Test::CheckChanges author for more formats

I already filed a ticket, RT#42976 but if others have different formats please contribute!

=item * Use Test::DistManifest instead of Test::CheckManifest

DistManifest has better support for MANIFEST.SKIP but the install is br0ken at this time...

=item * Use Test::GreaterVersion to sanity check versions

The problem here is that I've got to learn the CPAN backend to extract the module name from the distro tarball,
and pass it on to the test...

=item * Use Test::PerlTidy to check code style

Br0ken install at this time...

=item * Integrate Test::UniqueTestNames into the testsuite

This would be nice, but I'm not sure if I can actually force this on other tests. Otherwise I'll be just making
sure that the Test::Apocalypse tests is unique, which is worthless to $dist trying to clean itself up...

=back

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
