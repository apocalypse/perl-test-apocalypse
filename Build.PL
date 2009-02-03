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

	'test_files'		=> 't/*.t',

	'add_to_cleanup'	=> [ 'META.yml', 'Makefile.PL', 'README', 'Makefile' ],	# automatically generated

	'requires'		=> {
		# Test stuff
		'Test::More'			=> 0,
		'Test::Compile'			=> 0,
		'Test::Perl::Critic'		=> 0,
		'Test::Dependencies'		=> 0,
		'Test::Distribution'		=> 0,
		'Test::Fixme'			=> 0,
		'Test::HasVersion'		=> 0,
		'Test::CheckManifest'		=> 0,
		'Test::MinimumVersion'		=> 0,
		'Test::Pod::Coverage'		=> 0,
		'Test::Spelling'		=> 0,
		'Test::Pod'			=> 0,
		'Test::Prereq'			=> 0,
		'Test::Prereq::Build'		=> 0,
		'Test::Strict'			=> 0,
		'Test::UseAllModules'		=> 0,
		'Test::YAML::Meta'		=> 0,
		'Test::NoWarnings'		=> 0,
		'Test::CheckChanges'		=> 0,
		'Test::File'			=> 0,
		'Test::Dir'			=> 0,
		'Test::Signature'		=> 0,
		'Test::Portability::Files'	=> 0,

		# handy tools
		'File::Find::Rule'		=> 0,
		'Module::CPANTS::Analyse'	=> 0,
		'Perl::Metrics::Simple'		=> 0,
		'Test::Block'			=> 0,
		'YAML'				=> 0,
		'version'			=> 0,
		'CPANPLUS::Backend'		=> 0,
		'CPANPLUS::Configure'		=> 0,
		'Devel::PPPort'			=> 0,
		'Module::CoreList'		=> 0,

		# we need a recent perl
		'perl'				=> '5.008',
	},
);

# all done!
$build->create_build_script;
