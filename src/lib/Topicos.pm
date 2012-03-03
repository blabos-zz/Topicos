package Topicos;

use Mojo::Base 'Mojolicious';

use Topicos::Loader;

# This method will run once at server start
sub startup {
    my $self = shift;

    # Routes Namespace
    $self->routes->namespace('Topicos::Controller');

    # Documentation browser under "/perldoc" (this plugin requires Perl 5.10)
    $self->plugin('PODRenderer');

    # Loading Modules
    my @core_modules = qw{ Home };
    Topicos::Loader::load( $self, @core_modules );
}

42;
