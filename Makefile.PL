use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

Verify_OK_To_Install() unless grep { /^FORCE_INSTALL$/ } @ARGV;

sub Verify_OK_To_Install
{
  if (eval "require CGI::Cache" && $CGI::Cache::VERSION <= 1.00)
  {
    print <<EOF;
WARNING!

The interface to CGI::Cache has changed substantially in this version. Any
scripts developed using previous versions CGI::Cache will NOT work.

Do you want to continue installing CGI::Cache?
EOF

    my $answer;
    do
    {
      $answer = <STDIN>;
    } until $answer =~ /^[yn]/i;

    exit 1 if $answer =~ /^n/i;
  }
  elsif (eval "require CGI::Cache" && $CGI::Cache::VERSION <= 1.20)
  {
    print <<EOF;
WARNING!

The interface to CGI::Cache has changed slightly in this version. Any
scripts developed using previous versions CGI::Cache will likely not
work.

Do you want to continue installing CGI::Cache?
EOF

    my $answer;
    do
    {
      $answer = <STDIN>;
    } until $answer =~ /^[yn]/i;

    exit 1 if $answer =~ /^n/i;
  }
}


# Have to do this because MakeMaker and POSIX collide because someone used
# @EXPORT when they should have used @EXPORT_OK. See
# http://www.deja.com/=dnt_mn/getdoc.xp?AN=469218990&fmt=text
unless (eval "require POSIX")
{
  print "Warning: prerequisite POSIX 0 not found\n";
}

@ARGV = Set_Install_Options(@ARGV)
  unless (grep {/^PREFIX=/} @args) || (grep {/^INSTALLDIRS=/} @args);

WriteMakefile(
    'EXE_FILES' => [ ],
    'NAME'	=> 'CGI::Cache',
    'VERSION_FROM' => 'lib/CGI/Cache.pm',
    'PM'        => {
      'lib/CGI/Cache.pm' => '$(INST_LIB)/CGI/Cache.pm',
    },
    'PREREQ_PM' => { 'File::Path' => 0,
                     'File::Spec' => 0,
                     'File::Spec::Functions' => 0,
                     'Cache::SizeAwareFileCache' => 0,
                     'Storable' => 0,
                     'IO::File' => 0,
    },
);

# --------------------------------------------------------------------------

sub Set_Install_Options
{
  my @args = @_;

  my $install_location = ExtUtils::MakeMaker::prompt(
    "Choose your installation type:\n[1] normal Perl locations\n" .
    "[2] custom locations\n=>" => '1');

  if ($install_location eq '2')
  {
    my $home = Get_Home_Directory();

    print "\n","-"x78,"\n\n";

    my $prefix = ExtUtils::MakeMaker::prompt(
      "What PREFIX should I use?\n=>" => $home);

    push @args,"PREFIX=$prefix";
  }

  return @args;
}
