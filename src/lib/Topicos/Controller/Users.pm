package Topicos::Controller::Users;

use strict;
use warnings;
use utf8;

use Mojo::Base 'Mojolicious::Controller';

use Try::Tiny;

use Topicos::Utils::Password qw( encrypt );

use Data::Dumper;

sub startup {
    my ( $self, $c ) = @_;

    my $r = $c->routes;

    $r->route('/cadastre-se')->via('get')->to('users#signup');
    $r->route('/cadastre-se')->via('post')->to('users#save');
    
    my $admin
        = $c->admin_routes->route('/clientes')->to( controller => 'users' );
    
    $admin->route('/')->via('get')->to('users#list');
    $admin->route('/novo')->via('get')->to('users#form');
    $admin->route('/save')->via('post')->to('users#save');
    $admin->route('/edit/:user_id')->via('get')->to('users#form');
    $admin->route('/del/:user_id')->via('get')->to('users#del');
}


sub signup {
    my $self = shift;
    
    $self->stash(
        msg => $self->flash('msg') || { type => 'not', text => '' }
    );
}


sub save {
    my $self = shift;
    
    my $target = $self->param('target') || '';
    
    my %user = (
        user_id     => $self->param('user_id')      || 0,
        email       => $self->param('email')        || '',
        password    => $self->param('password')     || '',
        full_name   => $self->param('full_name')    || '',
        status      => $self->param('status')       || 0,
        type        => $self->param('type')         || 0,
    );
    
    $user{password}
        = $user{email} && $user{password}
        ? encrypt( $user{email}, $user{password} )
        : ''
        ;
    
    do { delete $user{ $_ } unless $user{ $_ } } foreach keys %user;  
    
    my $msg;
    try {
        my $res;
        
        if ( $user{user_id} ) {
            $res = $self->model->resultset('Users')->save( \%user );
        }
        else {
            $res = $self->model->resultset('Users')->add( \%user );
        }
        
        if ( $res ) {
            $msg = {
                type => 'wrn',
                text => 'Perfil gravado com sucesso.',
            };
            
            my $sess_user = $self->session('user');
            
            if ( $sess_user->{user_id} == $res->{user_id} ) {
                $self->session( user => $res );
            }
        }
        else {
            $msg = {
                type => 'err',
                text => 'Falha gravando dados do usuário',
            };
        }
    }
    catch {
        warn $_;
        
        $msg = {
            type => 'err',
            text => $_,
        };
    };
    
    $self->flash( msg => $msg );
    
    if ( $target eq 'edit' ) {
        return $self->redirect_to( '/admin/clientes/edit/' . $user{user_id} );
    }
    else {
        return $self->redirect_to( '/cadastre-se' );
    }
}


sub form {
    my $self = shift;
    
    my $user_id = $self->param('user_id')   || 0;
    my $msg     = $self->flash('msg')       || { type => 'not', text => '' };
    
    my $user;
    try {
        $user = $self->model->resultset('Users')->get({
            user_id => $user_id
        });
    }
    catch {
        warn $_;
        
        $user = {
            user_id     => '',
            email       => '',
            full_name   => '',
            status      => '',
            type        => '',
        };
        
        $msg = {
            type    => 'err',
            text    => $_,
        };
    };
    
    $self->stash( user => $user, msg => $msg );
}

sub del {
    my $self = shift;
    
    my $user_id = $self->param('user_id') || 0;
    
    my $msg;
    try {
        my $del_ok = $self->model->resultset('Users')->del({
            user_id => $user_id
        });
        
        $msg = {
            type => 'wrn',
            text => 'Perfil romovido com sucesso',
        };
    }
    catch {
        warn $_;
        
        $msg = {
            type => 'err',
            text => 'Falha removendo usuário ' . $user_id,
        };
    };
    
    $self->flash( msg => $msg );
    
    return $self->redirect_to('/admin/clientes');
}

sub list {
    my $self = shift;
    
    my $msg = $self->flash('msg') || { type => 'not', text => '' };
    
    my $users = $self->model->resultset('Users')->list || [];
    
    $self->stash( msg => $msg, users => $users );
}

return 42;
