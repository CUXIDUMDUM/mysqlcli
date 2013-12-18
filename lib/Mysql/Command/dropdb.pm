package Mysql::Command::dropdb;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use Readonly;

extends 'MooseX::App::Cmd::Command';
with 'Mysql::Role::Command';

Readonly my $MYSQL      => q(/usr/bin/mysql);
Readonly my $MYSQLADMIN => q(/usr/bin/mysqladmin);

sub abstract {
    return "dropdb abstract";
}
 
sub description {
    return <<ENDDESC;
dropdb description
ENDDESC
}

has 'db_user' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'root',
);

has 'db_password' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'admin',
);

has 'database' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

sub _get_cli {
    my ($self) = @_;

    my @cli = ($MYSQL);
    push(@cli, '--user=' . $self->db_user) 
        if defined $self->db_user;
    push(@cli, '--password=' . $self->db_password) 
        if defined $self->db_password;
    push(@cli, qw(--batch -e ));

    return wantarray ? @cli : "@cli";
}


sub _drop_database {
    my ($self) = @_;

    my $cmd = $self->_get_cli();
    my $ddl = q(drop database ) . $self->database;
    $cmd .= qq('$ddl');
    $self->r_run3( $cmd );

    return;
}

sub execute {
    my ($self, $opt, $args) = @_;

    say q(Dropping Database);
    $self->_drop_database();
    say q(Database Dropped);

    return;
}

1;
