#!/usr/bin/perl

use strict;
use inc::Module::Install;
use File::Slurp;

all_from('lib/CGI/Cache.pm');

auto_set_bugtracker;
githubmeta;

include(
  'File::Slurp' => 0,
);

license('gpl');

requires(
  'File::Path' => 0,
  'Tie::Restore' => 0,
  'File::Spec' => 0,
  'Cache::Cache' => 0,
  'Storable' => 0,
);

test_requires(
  'Test::More' => 0,
  'Error' => 0,
);

check_optional('Benchmark::Timer' => '0.7100',
  "Install Benchmark::Timer if you want to run \"make testspeed\"\n");

sub MY::postamble {
  return &Module::AutoInstall::postamble . <<'EOF';
testspeed :: pure_all
	PERL_DL_NONLAZY=1 $(PERLRUN) "-I$(INST_LIB)" \
	  "-I$(INST_ARCHLIB)" t/speed.pl
EOF
}

clean_files('t/CGI_Cache_tempdir','t/*.cgi');

license 'gpl2';
auto_license(holder => 'David Coppit');

WriteAll();

if (auto_tester) {
  my $code = read_file('Makefile');
  $code =~ s/TEST_VERBOSE\s*=\s*0/TEST_VERBOSE=1/ or die "Couldn't enable verbose mode in Makefile";
  write_file('Makefile', $code);
}
