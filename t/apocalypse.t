#!/usr/bin/perl
use strict; use warnings;

use Test::More;
eval "use Test::Apocalypse";
if ( $@ ) {
	plan skip_all => 'Test::Apocalypse required for validating the distribution';
} else {
	require Test::NoWarnings; require Test::Pod; require Test::Pod::Coverage;	# lousy hack for kwalitee

	# we can't eat our own dogfood yet :(
	is_apocalypse_here( {
		# Thanks to Regexp::Assemble for making this, ha!
		# my $ra = Regexp::Assemble->new;
		# $ra->add( '^Fixme$' );		# I use FIXMEs in this module as "ideas" and etc
		# $ra->add( '^Strict$' );		# Test::Strict doesn't skip Makefile/Build file and complains about them...
		# $ra->add( '^ModuleUsed$' );		# we use eval's to load our plugins' modules, dang!
		# $ra->add( '^OutdatedPrereqs$' );	# we need to specify older 'version' module for Debian, and others...
		# $ra->add( '^Dependencies$' );		# same problem as ModuleUsed
		# print $ra->as_string;

		# Add PERL_APOCALYSPE env var so we can test everything when needed...
		! $ENV{PERL_APOCALYPSE} ? ( deny => qr/^(?:(?:OutdatedPrereq|Dependencie)s|ModuleUsed|Strict|Fixme)$/, ) : (),
	} );
}
