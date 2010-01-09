# Build.PL
use strict; use warnings;
use Module::Build;

my $build = Module::Build->new(
	# look up Module::Build::API for the info!
	'dynamic_config'	=> 0,
	'module_name'		=> 'Test::Apocalypse',
	'license'		=> 'perl',

	'dist_abstract'		=> "Apocalypse's favorite tests bundled into a simple interface",
	'dist_author'		=> 'Apocalypse <APOCAL@cpan.org>',

	'create_packlist'	=> 1,
	'create_makefile_pl'	=> 'traditional',
	'create_readme'		=> 1,
	'create_license'	=> 1,
	'sign'			=> 0,

	'test_files'		=> 't/*.t',

	'add_to_cleanup'	=> [ 'META.yml', 'Makefile.PL', 'README', 'Makefile', 'LICENSE' ], # automatically generated

	'requires'		=> {
		# FIXME this sucks, I have to repeat the version here and in the Test::Apocalypse::XYZ module...

		# Test stuff
		'Test::More'			=> '0.94',
		'Test::Compile'			=> '0.11',
		'Test::Perl::Critic'		=> '1.02',
		'Test::Dependencies'		=> '0.12',
		'Test::Distribution'		=> '2.00',
		'Test::Fixme'			=> '0.04',
		'Test::HasVersion'		=> '0.012',
		'Test::MinimumVersion'		=> '0.011',
		'Test::Pod::Coverage'		=> '1.08',
		'Test::Spelling'		=> '0.11',
		'Test::Pod'			=> '1.40',
		'Test::Prereq'			=> '1.037',
		'Test::Prereq::Build'		=> '1.037',
		'Test::Strict'			=> '0.13',
		'Test::UseAllModules'		=> '0.12',
		'Test::YAML::Meta'		=> '0.14',
		'Test::NoWarnings'		=> '0.084',
		'Test::CheckChanges'		=> '0.08',
		'Test::File'			=> '1.29',
		'Test::Dir'			=> '1.006',
		'Test::Signature'		=> '1.10',
		'Test::Portability::Files'	=> '0.05',
		'Test::DistManifest'		=> '1.005',
		'Test::Module::Used'		=> '0.1.2',
		'Test::Synopsis'		=> '0.06',
		'Test::CPAN::Meta'		=> '0.13',
		'Test::NoBreakpoints'		=> '0.13',
		'Test::EOL'			=> '0.3',
		'Test::ConsistentVersion'	=> '0.2.2',
		'Test::AutoLoader'		=> '0.03',

		# handy tools
		'File::Spec'			=> '3.31',
		'File::Find::Rule'		=> '0.32',
		'Module::CPANTS::Analyse'	=> '0.85',
		'Perl::Metrics::Simple'		=> '0.13',
		'Test::Block'			=> '0.11',
		'YAML'				=> '0.70',
		'version'			=> '0.77',
		'CPANPLUS'			=> '0.90',
		'Devel::PPPort'			=> '3.19',
		'Module::CoreList'		=> '2.23',

		# we need a recent perl
		'perl'				=> '5.008',
	},

	# include the standard stuff in META.yml
	'meta_merge'	=> {
		'resources'	=> {
			'license'	=> 'http://dev.perl.org/licenses/',
			'homepage'	=> 'http://search.cpan.org/dist/Test-Apocalypse',
			'bugtracker'	=> 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Apocalypse',
			'repository'	=> 'http://github.com/apocalypse/perl-test-apocalypse',
		},
	},
);

# all done!
$build->create_build_script;
