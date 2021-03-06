
package Importer::Zim;

# ABSTRACT: Import functions without namespace pollution

use 5.010001;
use warnings;

use Module::Runtime ();

use Importer::Zim::Utils 0.8.0 qw(DEBUG carp croak);

BEGIN {
    my $v = $ENV{IMPORTER_ZIM_BACKEND} || '+Lexical,+EndOfScope,+Unit,+Bogus';
    *DEFAULT_BACKEND = sub () {$v};
}

my %MIN_VERSION = do {
    my %v = (
        '+Lexical'    => '0.10.0',
        '+EndOfScope' => '0.5.0',
        '+Unit'       => '0.6.0',
        '+Bogus'      => '0.12.0',
    );
    /^\+/ and $v{ _backend_class($_) } = $v{$_} for keys %v;
    %v;
};

sub backend { _backend( ref $_[2] eq 'HASH' ? $_[2]{-how} // '' : '' ) }

sub export_to { goto &{ __PACKAGE__->backend->can('export_to') } }

sub import {    # Load +Base if import() is called
    require Importer::Zim::Base;
    Importer::Zim::Base->VERSION('0.12.1');
    no warnings 'redefine';
    *import = \&_import;
    goto &_import;
}

sub _backend_class { $_[0] =~ s/^\+// ? __PACKAGE__ . '::' . $_[0] : $_[0] }

sub _backend {
    state $BACKEND_FOR;
    return $BACKEND_FOR->{ $_[0] } if exists $BACKEND_FOR->{ $_[0] };
    my @how = split ',', length $_[0] ? $_[0] : DEFAULT_BACKEND;
    for my $how (@how) {
        my $backend = _backend_class($how);
        my @version
          = exists $MIN_VERSION{$backend} ? ( $MIN_VERSION{$backend} ) : ();
        my $mod = eval { &Module::Runtime::use_module( $backend, @version ) };
        _trace_backend( $mod, $backend, @version ) if DEBUG;
        return $BACKEND_FOR->{ $_[0] } = $mod if $mod;
    }
    croak qq{Can't load any backend};
}

sub _import {
    unshift @_, shift->backend(@_);
    goto &Importer::Zim::Base::import_into;
}

sub _trace_backend {
    my ( $mod, $backend, $version ) = @_;
    my $rv = $version ? " $version+" : '';
    unless ($mod) {
        carp qq{Failed to load "$backend"$rv backend};
        return;
    }
    my $v = $mod->VERSION // 'NA';
    carp qq{Loaded "$backend"$rv ($v) backend};
}

no Importer::Zim::Utils qw(DEBUG carp croak);

1;

=encoding utf8

=head1 SYNOPSIS

    use Importer::Zim 'Scalar::Util' => 'blessed';
    use Importer::Zim 'Scalar::Util' => 'blessed' => { -as => 'typeof' };

    use Importer::Zim 'Mango::BSON' => ':bson';

    use Importer::Zim 'Foo' => { -version => '3.0' } => 'foo';

    use Importer::Zim 'SpaceTime::Machine' => [qw(robot rubber_pig)];

=head1 DESCRIPTION

   "Because, when you create a giant monster of doom,
   no matter how cute, you have to... you have to... I don't know."
     – Zim

This pragma imports subroutines from other modules in a clean way.
"Clean imports" here mean that the imported symbols will
be available for compilation and will not pollute
the user namespace at runtime.

L<Importer::Zim> relies on pluggable backends which give a precise
meaning to "clean imports". For example,
L<Importer::Zim::Lexical> uses lexical subs that are bound
to the surrounding lexical scope and never touch the target
namespace.

By default, L<Importer::Zim> looks at package variables
C<@EXPORT>, C<@EXPORT_OK> and C<%EXPORT_TAGS> to decide
what are exportable subroutines. It tries its best to implement
a behavior akin to L<Exporter> without the corresponding namespace pollution.

=head1 BACKENDS

L<Importer::Zim> will try the following backends in order
until one succeeds to load.

=over 4

=item *

L<Importer::Zim::Lexical> - symbols are imported as lexical subroutines

=item *

L<Importer::Zim::EndOfScope> - symbols are imported to caller namespace
while surrounding scope is compiled

=item *

L<Importer::Zim::Unit> - symbols are imported to caller namespace
while current unit is compiled

=back

Read also L<Importer::Zim::Cookbook/WHICH BACKEND?>.

=head1 METHODS

=head2 import

    Importer::Zim->import($class => @imports);
    Importer::Zim->import($class => \%opts => @imports);

=head1 FUNCTIONS

=head2 export_to

    Importer::Zim::export_to($target, %imports);
    Importer::Zim::export_to($target, \%imports);

=head1 DEBUGGING

You can set the C<IMPORTER_ZIM_DEBUG> environment variable
to get some diagnostics information printed to C<STDERR>.

    IMPORTER_ZIM_DEBUG=1

=head1 SEE ALSO

L<zim>

L<Importer::Zim::Cookbook>

L<Importer> and L<Lexical::Importer>

L<lexically>

=cut
