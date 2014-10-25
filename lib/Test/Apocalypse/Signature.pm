package Test::Apocalypse::Signature;

# ABSTRACT: Plugin for Test::Signature

use Test::More;
use Test::Signature 1.10;

# Various people have said SIGNATURE tests are INSANE on end-user install...
sub _do_automated { 0 }

# do we have a signature file?
sub _is_disabled {
	if ( ! -e 'SIGNATURE' ) {
		return 'No SIGNATURE file found';
	}
}

sub do_test {
	signature_ok();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Signature> functionality.

=cut
