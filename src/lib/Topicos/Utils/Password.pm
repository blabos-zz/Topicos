package Topicos::Utils::Password;

use strict;
use warnings;
use utf8;

use Digest::MD5 qw( md5_base64 );
use Crypt::Eksblowfish::Bcrypt qw( bcrypt_hash en_base64 );


use parent 'Exporter';

our @EXPORT_OK = qw( encrypt );


sub encrypt {
    my ( $email, $pass, %args ) = @_;
    
    return en_base64(
        bcrypt_hash(
            {
                key_nul => $args{key_nul}   || 1,
                cost    => $args{cost}      || 10,
                salt    => substr( md5_base64( $email ), 0, 16 ),
            },
            $pass,
        )
    );
}

return 42;