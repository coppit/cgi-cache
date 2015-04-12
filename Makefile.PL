#!/usr/bin/perl

use strict;

# For PRIVATE Module::Install extensions
use lib 'lib';

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

Add_Test_Target('testspeed', 't/speed.pl');

license 'gpl2';
auto_license(holder => 'David Coppit');

WriteAll();

if (auto_tester) {
  my $code = read_file('Makefile');
  $code =~ s/TEST_VERBOSE\s*=\s*0/TEST_VERBOSE=1/ or die "Couldn't enable verbose mode in Makefile";
  write_file('Makefile', $code);
}
