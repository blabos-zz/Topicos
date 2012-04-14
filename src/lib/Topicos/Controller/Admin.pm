package Topicos::Controller::Admin ;

use strict;
use warnings;
use utf8;

use parent 'Mojolicious::Controller';

sub startup {
    my ( $self, $c ) = @_;
    
    $c->admin_routes->route('/')->to('users#list');
}

sub base {
    my $self = shift;

    return 1;
}

return 42;
