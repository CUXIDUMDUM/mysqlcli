package Mysql::Command::dumpdb;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use Readonly;
use MooseX::Types::Path::Class;
use Path::Class;

extends 'MooseX::App::Cmd::Command';
with 'Mysql::Role::Command';

Readonly my $MYSQLDUMP  => q(/usr/bin/mysqldump);

sub abstract {
    return "dumpdb abstract";
}
 
sub description {
    return <<ENDDESC;
dumpdb description
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

has 'dump_dir' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    required => 1,
    coerce   => 1,
);

has 'databases' => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

sub _get_cli {
    my ($self) = @_;

    my @cli = ($MYSQLDUMP);
    push(@cli, '--user=' . $self->db_user) 
        if defined $self->db_user;
    push(@cli, '--password=' . $self->db_password) 
        if defined $self->db_password;

    push(@cli, q(--databases));
    return wantarray ? @cli : "@cli";
}


sub _dump_databases {
    my ($self) = @_;


    $self->dump_dir->mkpath()
        unless -d $self->dump_dir->stringify;

    for my $db ( @{$self->databases} ) {

        my $cmd = $self->_get_cli();
        $cmd .= qq( $db );
        $cmd .= q( > );
        $cmd .= file($self->dump_dir->stringify, $db);
        $self->r_run3( $cmd );

    }

    return;
}

sub execute {
    my ($self, $opt, $args) = @_;

    say q(Dumping Database);
    $self->_dump_databases();
    say q(Database Dumped);

    return;
}

1;
