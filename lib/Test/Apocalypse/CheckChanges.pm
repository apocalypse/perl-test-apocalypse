package Test::Apocalypse::CheckChanges;

# ABSTRACT: Plugin for Test::CheckChanges

# TODO oh please don't set plan in import!
#use Test::CheckChanges 0.08;

# TODO wait for this bug to be fixed: RT#63914

sub do_test {
	require Test::CheckChanges;
	Test::CheckChanges->import;
	Test::CheckChanges::ok_changes();

	return;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::CheckChanges> functionality.

=cut
