package Mysql::Command::runddl;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use Readonly;
use MooseX::Types::Path::Class;

extends 'MooseX::App::Cmd::Command';
with 'Mysql::Role::Command';

Readonly my $MYSQL      => q(/usr/bin/mysql);
Readonly my $MYSQLADMIN => q(/usr/bin/mysqladmin);

sub abstract {
    return "runddl abstract";
}
 
sub description {
    return <<ENDDESC;
runddl description
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

has 'schema_file' => (
    is       => 'ro',
    isa      => 'Path::Class::File',
    required => 1,
    coerce   => 1,
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
    push(@cli, qw(--batch ));
    push(@cli, $self->database);

    return wantarray ? @cli : "@cli";
}


sub _run_ddl {
    my ($self) = @_;

    my $cmd = $self->_get_cli();
    $cmd .= q( < ) . $self->schema_file->stringify;
    $self->r_run3( $cmd );

    return;
}

sub execute {
    my ($self, $opt, $args) = @_;

    say q(Running DDL);
    $self->_run_ddl();
    say q(DDL Completed);

    return;
}

1;
