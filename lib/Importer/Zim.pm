
package Importer::Zim;

use 5.018;
use warnings;
use Module::Runtime ();

sub import {
    shift->backend(@_)->import(@_);
}

sub backend {
    my $how = ( ref $_[2] ? $_[2]->{-how} : undef ) // 'lexical';
    my $backend = __PACKAGE__ . '::' . ucfirst($how);
    return Module::Runtime::use_module($backend);
}

1;

=encoding utf8

=head1 NAME

Importer::Zim - Import functions à la Invader Zim

=head1 SYNOPSIS

    use Importer::Zim 'Scalar::Util' => 'blessed';
    use Importer::Zim 'Scalar::Util' => 'blessed' => { -as => 'typeof' };

    use Importer::Zim 'Foo' => { -version => '3.0' } => 'foo';

=head1 METHODS

=head2 import

    Importer::Zim->import($class => $export);
    Importer::Zim->import($class => \%opts => $export);

=cut
