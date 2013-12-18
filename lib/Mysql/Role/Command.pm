package Mysql::Role::Command;

use Moose::Role;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use IPC::Run3;
use Capture::Tiny qw(:all);

sub r_run3 {
    my $self    = shift;
    my $command = shift;
    my $input   = shift;

    my $stdout = q{};
    my $stderr = q{};

    my $handle_stdout = sub {
        say(@_);

        $stdout .= $_ for @_;
    };

    my $handle_stderr = sub {
        say(@_);

        $stderr .= $_ for @_;
    };

    say("Running command: [$command]");

    run3( $command, \$input, $handle_stdout, $handle_stderr );

    if ($?) {
        my $exit = $? >> 8;

        my $msg = "[$command] returned an exit code of $exit\n";
        $msg .= "\nSTDOUT:\n$stdout\n\n" if length $stdout;
        $msg .= "\nSTDERR:\n$stderr\n\n" if length $stderr;

        die $msg;
    }

    return $stdout;

}

1;
