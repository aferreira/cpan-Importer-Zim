
BEGIN {
    require Importer::Zim;
    *zim:: = *Importer::Zim::;
}

package zim;

1;

=encoding utf8

=head1 NAME

zim - Import functions à la Invader Zim

=head1 SYNOPSIS

    use zim 'Scalar::Util' => 'blessed';
    use zim 'Scalar::Util' => 'blessed' => { -as => 'typeof' };

    use zim 'Foo' => { -version => '3.0' } => 'foo';

=head1 DESCRIPTION

L<zim> is an alias to L<Importer::Zim>.

=cut
