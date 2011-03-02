package Test::Apocalypse::PerlCritic;

# ABSTRACT: Plugin for Test::Perl::Critic

use Test::More;
use Test::Perl::Critic 1.02;
use File::Spec 3.31;

sub do_test {
	# set default opts
	require Perl::Critic::Utils::Constants;
	my $rcfile = File::Spec->catfile( 't', 'perlcriticrc' );
	my $default_rcfile; # did we generate a default?
	my %opts = (
		'-verbose' => 8, # sets "[%p] %m at line %l, column %c.  (Severity: %s)\n"
		'-severity' => 'brutal',
		'-profile' => $rcfile,
		'-profile-strictness' => $Perl::Critic::Utils::Constants::PROFILE_STRICTNESS_FATAL,
	);

	# Do we have a perlcriticrc?
	if ( ! -e $rcfile ) {
		# Generate it using the default!
		open( my $rc, '>', $rcfile ) or die "Unable to open $rcfile for writing: $!";
		print $rc _default_perlcriticrc();
		close $rc or die "Unable to close $rcfile: $!";
		$default_rcfile = 1;
	}
	Test::Perl::Critic->import( %opts );

	TODO: {
		local $TODO = "PerlCritic";
		all_critic_ok();
	}

	if ( $default_rcfile ) {
		unlink $rcfile or die "Unable to remove $rcfile: $!";
	}

	return;
}

sub _default_perlcriticrc {
	# Build a default file
	my $rcfile = <<'EOF';
# If you're wondering why there's a gazillion exclusions in here...
# It's because I installed every Perl::Critic policy there is ;)

# ---------------------------------------------
# Policies that is already covered by other tests in Test::Apocalypse
# ---------------------------------------------

[-Compatibility::PerlMinimumVersionAndWhy]
[-Modules::RequirePerlVersion]
# covered by MinimumVersion

[-Documentation::PodSpelling]
# covered by Pod_Spelling

# ---------------------------------------------
# editor/style stuff that is too strict
# ---------------------------------------------

[-CodeLayout::RequireTidyCode]
[-CodeLayout::RequireUseUTF8]
[-Editor::RequireEmacsFileVariables]
[-Miscellanea::RequireRcsKeywords]
[-Tics::ProhibitLongLines]
[-Subroutines::ProhibitExcessComplexity]
[-Bangs::ProhibitFlagComments]
[-Bangs::ProhibitCommentedOutCode]
[-Documentation::RequirePODUseEncodingUTF8]
[-Documentation::RequirePodLinksIncludeText]
[-CodeLayout::ProhibitHardTabs]
[-ValuesAndExpressions::ProhibitNoisyQuotes]
[-NamingConventions::Capitalization]
[-NamingConventions::ProhibitMixedCaseVars]
[-Bangs::ProhibitVagueNames]
[-CodeLayout::ProhibitParensWithBuiltins]
[-ValuesAndExpressions::ProhibitMagicNumbers]

# ---------------------------------------------
# miscellaneous policies that is just plain annoying
# ---------------------------------------------

[-ErrorHandling::RequireCarping]
[-ErrorHandling::RequireUseOfExceptions]
[-ErrorHandling::RequireCheckingReturnValueOfEval]
[-Modules::RequireExplicitPackage]
[-Modules::ProhibitAutomaticExportation]
[-Subroutines::ProhibitCallsToUndeclaredSubs]
[-ValuesAndExpressions::RequireInterpolationOfMetachars]
[-ValuesAndExpressions::ProhibitInterpolationOfLiterals]
[-BuiltinFunctions::ProhibitStringyEval]
[-TestingAndDebugging::ProhibitNoWarnings]
[-ValuesAndExpressions::ProhibitFiletest_f]
[-Variables::ProhibitPunctuationVars]
[-References::ProhibitDoubleSigils]
[-RegularExpressions::RequireExtendedFormatting]
[-RegularExpressions::ProhibitEscapedMetacharacters]
[-RegularExpressions::RequireLineBoundaryMatching]
[-RegularExpressions::RequireDotMatchAnything]
[-Subroutines::RequireArgUnpacking]
[-ControlStructures::ProhibitPostfixControls]
[-Variables::ProhibitLocalVars]
[-Subroutines::ProhibitCallsToUnexportedSubs]
[-ValuesAndExpressions::ProhibitAccessOfPrivateData]
[-Compatibility::ProhibitThreeArgumentOpen]
[-InputOutput::RequireCheckedSyscalls]
[-InputOutput::RequireBracedFileHandleWithPrint]
[-Lax::ProhibitEmptyQuotes::ExceptAsFallback]
[-ValuesAndExpressions::ProhibitEmptyQuotes]
[-Subroutines::ProhibitUnusedPrivateSubroutines]
[-Subroutines::RequireFinalReturn]
[-Subroutines::ProtectPrivateSubs]
[-Variables::RequireInitializationForLocalVars]
[-TestingAndDebugging::ProhibitNoStrict]
[-RegularExpressions::ProhibitFixedStringMatches]
[-Lax::ProhibitStringyEval::ExceptForRequire]
[-BuiltinFunctions::ProhibitStringySplit]

# ---------------------------------------------
# TODO probably sane policies but need to do a lot of work to fix them...
# ---------------------------------------------

[-Tics::ProhibitUseBase]
# what is the preferred workaround?

[-CodeLayout::ProhibitHashBarewords]
# sometimes we're lazy!

[-Documentation::RequirePodSections]
# what is the "default" list? Obviously not PBP because it requires way too much sections!

[-Compatibility::PodMinimumVersion]
# there should be a Test::Apocalypse check for that!

[-RegularExpressions::ProhibitUnusualDelimiters]
# sometimes we like other delims...

[-ControlStructures::ProhibitUnlessBlocks]
# it's so easy to be lazy!

[-Miscellanea::ProhibitUselessNoCritic]
# I don't want to go through my old code and clean them up... laziness again!

[-ValuesAndExpressions::ProhibitMixedBooleanOperators]
# sometimes it feels "natural" to code in that style...

[-Modules::RequireExplicitInclusion]
# while this makes sense sometimes it's a drag to list the modules that you *know* a prereq will pull in...

[-ValuesAndExpressions::ProhibitVersionStrings]
# is this really a problem? If so, it's still a lot of work to go through code and figure out the proper string...

[-InputOutput::ProhibitBacktickOperators]
# sometimes it's handy to use it instead of a full-blown IPC module...

EOF

	return $rcfile;
}

1;

=pod

=for Pod::Coverage do_test

=head1 DESCRIPTION

Encapsulates L<Test::Perl::Critic> functionality.

Automatically sets the following options:

	-verbose => 8,
	-severity => 'brutal',
	-profile => 't/perlcriticrc',
	-profile-strictness => 'fatal',

If the C<t/perlcriticrc> file isn't present a default one will be generated and used. Please see the source of this module
for the default config, it is too lengthy to copy and paste into this POD! If you want to override the critic options,
please create your own C<t/perlcriticrc> file in the distribution!

=head1 SEE ALSO
Perl::Critic

=cut
