package Topicos::Controller::Users;

use Mojo::Base 'Mojolicious::Controller';

sub startup {
    my ( $self, $c ) = @_;

    my $r = $c->routes;

    $r->route('/cadastre-se')->via('get')->to('users#signup');
    $r->route('/cadastre-se')->via('post')->to('users#add');
}


sub signup {
    my $self = shift;
}


sub add {
    my $self = shift;
    
    my $email       = $self->param('email')     || '';
    my $password    = $self->param('password')  || '';
    my $target      = $self->param('target')    || '';
    
    my $res = undef;
    
    if ( $email && $password ) {
        $res = $self->model->resultset('Users')->add({
            eamil       => $email,
            password    => $password,
        });
    }
    
    if ( defined $res ) {
        
    }
    else {
        $self->stash(   err_msg     => $res->{error}    );
        $self->render(  template    => 'users/signup'   );
    }
}



42;
