package Topicos::Model;

use strict;
use warnings;
use utf8;

use Topicos::Model::Schema;


my $__INSTANCE__ = undef;


sub instance {
    unless ( defined $__INSTANCE__ ) {
        my $dsn = shift;
        
        $__INSTANCE__ = bless(
            { schema => Topicos::Model::Schema->connect( $dsn ) },
            'Topicos::Model',
        );
    }
    
    return $__INSTANCE__->{schema};
}

42;
