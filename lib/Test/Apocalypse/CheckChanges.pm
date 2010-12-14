package Test::Apocalypse::CheckChanges;

# ABSTRACT: Plugin for Test::CheckChanges

# TODO oh please don't set plan in import!
#use Test::CheckChanges 0.08;

# TODO pester upstream about this hunk of code:
#END {
#    if (!defined $test->has_plan()) {
#       $test->done_testing(1);
#    }
#}

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
