
package Importer::Zim;

use 5.018;
use warnings;
use Module::Runtime ();

sub import {
    shift->backend(@_)->import(@_);
}

my %MIN_VERSION = do {
    my %v = ( '+Lexical' => '0.2.0', );
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

=head1 NAME

Importer::Zim - Import functions à la Invader Zim

=head1 SYNOPSIS

    use Importer::Zim 'Scalar::Util' => 'blessed';
    use Importer::Zim 'Scalar::Util' => 'blessed' => { -as => 'typeof' };

    use Importer::Zim 'Mango::BSON' => ':bson';

    use Importer::Zim 'Foo' => { -version => '3.0' } => 'foo';

=head1 METHODS

=head2 import

    Importer::Zim->import($class => $export);
    Importer::Zim->import($class => \%opts => $export);

=cut
