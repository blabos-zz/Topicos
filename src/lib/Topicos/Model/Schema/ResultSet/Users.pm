package Topicos::Model::Schema::ResultSet::Users;

use strict;
use warnings;
use utf8;

use parent 'DBIx::Class::ResultSet';


sub add {
    my $self = shift;
    my $args = shift;
    
    my $row = $self->create( $args ); 
    
    return defined $row
        ? { $row->get_columns }
        : undef
        ;
}


sub save {
    my $self = shift;
    my $args = shift;
    
    my $row = $self->update_or_create( $args );
    
    return defined $row
        ? { $row->get_columns }
        : undef
        ;
}


sub get {
    my $self = shift;
    my $args = shift;
    
    my $row = $self->find( $args );
    
    return defined $row
        ? { $row->get_columns }
        : undef
        ;
}


sub del {
    my $self = shift;
    my $args = shift;
    
    my $user = $self->find( $args );
    
    return defined $user
        ? $user->delete
        : 0
        ;
}


sub list {
    my ( $self, @args ) = @_;
    
    my $rs = $self->search;
    
    return defined $rs
        ? [ map { { $_->get_columns } } $rs->all ]
        : undef
        ;
}


sub get_user_by_email {
    my ( $self, $email ) = @_;
    
    return $self->get({ email => $email });
}


return 42;
