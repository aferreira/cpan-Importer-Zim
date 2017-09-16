
BEGIN {
    require Importer::Zim;
    *zim:: = *Importer::Zim::;
}

package zim;

# ABSTRACT: Import functions à la Invader Zim

1;

=encoding utf8

=head1 SYNOPSIS

    use zim 'Scalar::Util' => 'blessed';
    use zim 'Scalar::Util' => 'blessed' => { -as => 'typeof' };

    use zim 'Mango::BSON' => ':bson';

    use zim 'Foo' => { -version => '3.0' } => 'foo';

    use zim 'Krazy::Taco' => qw(tacos burritos poop);

=head1 DESCRIPTION

    "The rightful order has been restored."
      – Gaz

L<zim> is an alias to L<Importer::Zim>.

=cut
