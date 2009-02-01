#!/usr/bin/perl
use strict; use warnings;

# do our stuff!
use Test::More;
eval "use Test::Apocalypse";
if ( $@ ) {
	plan skip_all => 'Test::Apocalypse required for validating the distribution';
} else {
	is_apocalypse_here();
}
