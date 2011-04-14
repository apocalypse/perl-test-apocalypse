package Test::Apocalypse::PerlCritic;

# ABSTRACT: Plugin for Test::Perl::Critic

use Test::More;
use Test::Perl::Critic 1.02;
use File::Spec 3.31;

# This is so we always have all PerlCritic plugins installed, yay!
use Task::Perl::Critic 1.007;

sub _do_automated { 0 }

sub do_test {
	# set default opts
	require Perl::Critic::Utils::Constants;
	my %opts = (
		'-verbose' => 8, # sets "[%p] %m at line %l, column %c.  (Severity: %s)\n"
		'-severity' => 'brutal',
		'-profile-strictness' => $Perl::Critic::Utils::Constants::PROFILE_STRICTNESS_FATAL,
	);

	# Do we have a perlcriticrc?
	my $rcfile = File::Spec->catfile( 't', 'perlcriticrc' );
	my $default_rcfile; # did we generate a default?
	if ( ! -e $rcfile ) {
		# Maybe it's in the CWD?
		if ( ! -e 'perlcriticrc' ) {
			# Generate it using the default!
			if ( ! -d 't' ) {
				# We're already in the test dir
				$rcfile = 'perlcriticrc';
			}

			open( my $rc, '>', $rcfile ) or die "Unable to open $rcfile for writing: $!";
			print $rc _default_perlcriticrc();
			close $rc or die "Unable to close $rcfile: $!";
			$default_rcfile = 1;
		} else {
			$rcfile = 'perlcriticrc';
		}
	}
	Test::Perl::Critic->import( %opts, '-profile' => $rcfile );

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

[-Bangs::ProhibitCommentedOutCode]
[-Bangs::ProhibitFlagComments]
[-Bangs::ProhibitVagueNames]
[-CodeLayout::ProhibitHardTabs]
[-CodeLayout::ProhibitParensWithBuiltins]
[-CodeLayout::RequireTidyCode]
[-CodeLayout::RequireUseUTF8]
[-Documentation::RequirePodLinksIncludeText]
[-Documentation::RequirePODUseEncodingUTF8]
[-Editor::RequireEmacsFileVariables]
[-Miscellanea::RequireRcsKeywords]
[-NamingConventions::Capitalization]
[-NamingConventions::ProhibitMixedCaseVars]
[-Subroutines::ProhibitExcessComplexity]
[-Tics::ProhibitLongLines]
[-ValuesAndExpressions::ProhibitEscapedCharacters]
[-ValuesAndExpressions::ProhibitMagicNumbers]
[-ValuesAndExpressions::ProhibitNoisyQuotes]
[-ValuesAndExpressions::RestrictLongStrings]

# ---------------------------------------------
# miscellaneous policies that is just plain annoying
# ---------------------------------------------

[-BuiltinFunctions::ProhibitStringyEval]
[-BuiltinFunctions::ProhibitStringySplit]
[-Compatibility::ProhibitThreeArgumentOpen]
[-ControlStructures::ProhibitPostfixControls]
[-ControlStructures::ProhibitCascadingIfElse]
[-ErrorHandling::RequireCarping]
[-ErrorHandling::RequireCheckingReturnValueOfEval]
[-ErrorHandling::RequireUseOfExceptions]
[-InputOutput::RequireBracedFileHandleWithPrint]
[-InputOutput::RequireCheckedSyscalls]
[-Lax::ProhibitEmptyQuotes::ExceptAsFallback]
[-Lax::ProhibitStringyEval::ExceptForRequire]
[-Miscellanea::ProhibitTies]
[-Modules::ProhibitAutomaticExportation]
[-Modules::RequireExplicitPackage]
[-NamingConventions::ProhibitMixedCaseSubs]
[-References::ProhibitDoubleSigils]
[-RegularExpressions::ProhibitEscapedMetacharacters]
[-RegularExpressions::ProhibitFixedStringMatches]
[-RegularExpressions::RequireDotMatchAnything]
[-RegularExpressions::RequireExtendedFormatting]
[-RegularExpressions::RequireLineBoundaryMatching]
[-Subroutines::ProhibitCallsToUndeclaredSubs]
[-Subroutines::ProhibitCallsToUnexportedSubs]
[-Subroutines::ProhibitManyArgs]
[-Subroutines::ProhibitUnusedPrivateSubroutines]
[-Subroutines::ProtectPrivateSubs]
[-Subroutines::RequireArgUnpacking]
[-Subroutines::RequireFinalReturn]
[-TestingAndDebugging::ProhibitNoStrict]
[-TestingAndDebugging::ProhibitNoWarnings]
[-ValuesAndExpressions::ProhibitAccessOfPrivateData]
[-ValuesAndExpressions::ProhibitCommaSeparatedStatements]
[-ValuesAndExpressions::ProhibitEmptyQuotes]
[-ValuesAndExpressions::ProhibitFiletest_f]
[-ValuesAndExpressions::ProhibitInterpolationOfLiterals]
[-ValuesAndExpressions::RequireInterpolationOfMetachars]
[-Variables::ProhibitLocalVars]
[-Variables::ProhibitPunctuationVars]
[-Variables::RequireInitializationForLocalVars]

# ---------------------------------------------
# TODO probably sane policies but need to do a lot of work to fix them...
# ---------------------------------------------

[-CodeLayout::ProhibitHashBarewords]
# sometimes we're lazy!

[-Compatibility::PodMinimumVersion]
# there should be a Test::Apocalypse check for that!

[-ControlStructures::ProhibitUnlessBlocks]
# it's so easy to be lazy!

[-Documentation::RequirePodSections]
# what is the "default" list? Obviously not PBP because it requires way too much sections!

[-Miscellanea::ProhibitUselessNoCritic]
# I don't want to go through my old code and clean them up... laziness again!

[-Modules::RequireExplicitInclusion]
# while this makes sense sometimes it's a drag to list the modules that you *know* a prereq will pull in...

[-RegularExpressions::ProhibitComplexRegexes]
# while this is true it's unavoidable in some cases...

[-RegularExpressions::ProhibitUnusualDelimiters]
# sometimes we like other delims...

[-Subroutines::ProhibitBuiltinHomonyms]
# in POE "shutdown" is commonly used, also in some classes we define convenience methods like "print" and etc...

[-ValuesAndExpressions::ProhibitMixedBooleanOperators]
# sometimes it feels "natural" to code in that style...

[-ValuesAndExpressions::ProhibitVersionStrings]
# is this really a problem? If so, it's still a lot of work to go through code and figure out the proper string...

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
