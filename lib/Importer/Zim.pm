
package Importer::Zim;

# ABSTRACT: Import functions à la Invader Zim

use 5.018;
use warnings;
use Module::Runtime ();

sub import {
    shift->backend(@_)->import(@_);
}

my %MIN_VERSION = do {
    my %v = ( '+Lexical' => '0.5.0', );
    /^\+/ and $v{ backend_class($_) } = $v{$_} for keys %v;
    %v;
};

sub backend_class {
    my $how = shift;
    return ( $how =~ s/^\+// )
      ? ( __PACKAGE__ . '::' . $how )
      : $how;
}

sub backend {
    my $how = ( ref $_[2] ? $_[2]->{-how} : undef ) // '+Lexical';
    my $backend = backend_class($how);
    my @version
      = exists $MIN_VERSION{$backend} ? ( $MIN_VERSION{$backend} ) : ();
    return &Module::Runtime::use_module( $backend, @version );
}

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
"Clean imports" here mean that the import symbols are available
only at some scope.

L<Importer::Zim> relies on pluggable backends which give a precise
meaning to "available at some scope". For example,
L<Importer::Zim::Lexical> creates lexical subs that go away
as soon the lexical scope ends.

By default, L<Importer::Zim> looks at package variables
C<@EXPORT>, C<@EXPORT_OK> and C<%EXPORT_TAGS> to decide
what are exportable subroutines. It tries its best to implement
a behavior akin to L<Exporter> without the corresponding namespace pollution.

=head1 METHODS

=head2 import

    Importer::Zim->import($class => @imports);
    Importer::Zim->import($class => \%opts => @imports);

=head1 SEE ALSO

L<zim>

L<Importer> and L<Lexical::Importer>

L<lexically>

=cut
