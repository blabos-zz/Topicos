package Topicos;

use strict;
use warnings;
use utf8;

use Mojo::Base 'Mojolicious';

use Topicos::Loader;
use Topicos::Model;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes Namespace
    $self->routes->namespace('Topicos::Controller');

    # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
    $self->plugin('PODRenderer');
    
    $self->helper(
        model => sub {
            my $dsn = 'dbi:SQLite:' . $self->app->home . '/var/topicos.db';
            return Topicos::Model::instance($dsn);
        }
    );
    
    $self->helper(
        admin_routes => sub {
            return $self->routes->bridge('/admin')
              ->to( controller         => 'access', action => 'logged' )
              ->bridge->to( controller => 'admin',  action => 'base' );
        }
    );

    # Loading Modules
    my @core_modules = qw{ Admin Access Home Users };
    Topicos::Loader::load( $self, @core_modules );
}

return 42;
