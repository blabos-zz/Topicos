package Topicos::Controller::Home;

use Mojo::Base 'Mojolicious::Controller';

sub startup {
    my ( $self, $c ) = @_;

    my $r = $c->routes;

    $r->route('/')->to('home#index');
    $r->route('/sobre')->to('home#about');
    
}

sub index {
    my $self = shift;
    
}

sub about {
    my $self = shift;
    
}

42;
