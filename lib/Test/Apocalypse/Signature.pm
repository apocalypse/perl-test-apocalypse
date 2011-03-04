package Test::Apocalypse::Signature;

# ABSTRACT: Plugin for Test::Signature

use Test::More;
use Test::Signature 1.10;

# Various people have said SIGNATURE tests are INSANE on end-user install...
sub _do_automated { 0 }

sub do_test {
	# do we have a signature file?
	if ( -e 'SIGNATURE' ) {
		signature_ok();
	} else {
		plan skip_all => 'No SIGNATURE file found';
	}

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Signature> functionality.

=cut
