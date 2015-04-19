package Module::Install::PRIVATE::Add_Test_Target;

use strict;
use File::Slurp;

use vars qw( @ISA $VERSION );

use Module::Install::Base;
@ISA = qw( Module::Install::Base );

$VERSION = sprintf "%d.%02d%02d", q/0.10.0/ =~ /(\d+)/g;

# ---------------------------------------------------------------------------

sub Add_Test_Target
{
  my ($self, $target, $test) = @_;

  # Tell Module::Install to include this, since we use it.
  $self->perl_version('5.005');
  $self->configure_requires('File::Slurp', 0);

  *main::MY::postamble = sub {
    return &Module::AutoInstall::postamble . <<EOF;
$target :: pure_all
\tPERL_DL_NONLAZY=1 \$(PERLRUN) "-I\$(INST_LIB)" "-I\$(INST_ARCHLIB)" $test
EOF
  };
}

1;
