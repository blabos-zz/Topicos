package Topicos::Controller::Access;

use strict;
use warnings;
use utf8;

use parent 'Mojolicious::Controller';

use Topicos::Utils::Password qw( encrypt );


sub startup {
    my ( $self, $c ) = @_;

    my $r = $c->routes;

    $r->route('/login')->via('get')->to('access#index');
    $r->route('/login')->via('post')->to('access#login');
    $r->route('/logout')->via('get')->to('access#logout');
}

sub index {
    my $self = shift;
    
    my $target = $self->flash( 'target' ) || '/';
    
    return $self->redirect_to( $target ) if $self->is_logged;
    
    $self->stash(
        target  => $target,
        msg     => {
            type => 'not',
            text => '',
        }
    );
}

sub login {
    my $self = shift;

    my $email       = $self->param('email')     || '';
    my $password    = $self->param('password')  || '';
    my $target      = $self->param('target')    || '/';
    
    return $self->redirect_to( $target ) if $self->is_logged;

    my $user = $self->model->resultset('Users')->get_user_by_email( $email );

    if ( $user && $password ) {
        my $pass = encrypt( $user->{email}, $password );

        if ( $pass eq $user->{password} ) {
            delete $user->{password};
            
            $self->session( 'user' => $user );
            
            return $self->redirect_to( $target );
        }
    }

    $self->stash(
        target  => $target,
        msg     => {
            type => 'err',
            text => 'Usuário ou senha inválidos',
        },
    );
    
    $self->render( template => 'access/index' );
}

sub logout {
    my $self = shift;
    $self->session( 'expires' => 1 ) if $self->is_logged;
    $self->redirect_to('/');
}


sub logged {
    my $self = shift;

    if ( $self->is_logged ) {
        return 1;
    }
    else {
        my $target = '' . $self->req->url;
        
        $self->flash( target => $target );
        
        return $self->redirect_to('/login');
    }
}


sub is_logged {
    my $self = shift;
    
    my $user = $self->session('user');
    return defined $user && $user->{email};
}


return 42;
