package Test::Apocalypse::NoPlan;

# ABSTRACT: Plugin for Test::NoPlan

use Test::NoPlan 0.0.6;

sub do_test {
	all_plans_ok( {
		'topdir'	=> 't',
		'recurse'	=> 1,
		'method'	=> 'new',	# needed so it doesn't use create() and bomb out
	} );

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::NoPlan> functionality.

=cut
