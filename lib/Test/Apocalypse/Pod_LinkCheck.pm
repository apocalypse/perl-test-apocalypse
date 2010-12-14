package Test::Apocalypse::Pod_LinkCheck;

# ABSTRACT: Plugin for Test::Pod::LinkCheck

sub _is_release { 1 }

use Test::Pod::LinkCheck 0.004;

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
