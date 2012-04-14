package Topicos::Model::Schema::Result::Users;

use strict;
use warnings;
use utf8;

use parent 'DBIx::Class::Core';

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    user_id   => {
        data_type           => 'integer',
        is_nullable         => 0,
        is_auto_increment   => 1,
        is_numeric          => 1,
        retrieve_on_insert  => 1,
    },
    password    => {
        data_type           => 'text',
        is_nullable         => 0,
        is_numeric          => 0,
    },
    email       => {
        data_type           => 'varchar',
        size                => 80,
        is_nullable         => 0,
        is_numeric          => 0,
        retrieve_on_insert  => 1,
    },
    full_name   => {
        data_type           => 'varchar',
        size                => 80,
        is_nullable         => 0,
        default_value       => '',
        is_numeric          => 0,
        retrieve_on_insert  => 1,
    },
    status      => {
        data_type           => 'integer',
        is_nullable         => 0,
        is_numeric          => 1,
        retrieve_on_insert  => 1,
        default_value       => 1,
    },
    type      => {
        data_type           => 'integer',
        is_nullable         => 0,
        is_numeric          => 1,
        retrieve_on_insert  => 1,
        default_value       => 1,
    },
);

__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->add_unique_constraints(
    ['email'],
);


return 42;
