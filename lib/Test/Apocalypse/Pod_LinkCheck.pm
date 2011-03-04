package Test::Apocalypse::Pod_LinkCheck;

# ABSTRACT: Plugin for Test::Pod::LinkCheck

use Test::Pod::LinkCheck 0.004;

# LinkCheck often FAILs on misconfigured machines
sub _do_automated { 0 }

sub do_test {
	Test::Pod::LinkCheck->new->all_pod_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Pod::LinkCheck> functionality.

=cut
