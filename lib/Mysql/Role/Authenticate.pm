package Mysql::Role::Authenticate;

use Moose;
use namespace::autoclean;
use 5.019;
use Data::Dump qw(dump);
use Carp;
use Authen::Simple;
use Authen::Simple::Kerberos;
use Authen::Simple::LDAP;

sub authenticate {
    my ($self) = @_;

    my $simple = Authen::Simple->new(

        Authen::Simple::Kerberos->new( 
            realm => 'REALM.COMPANY.COM'
        ),

        Authen::Simple::LDAP->new( 
            host => 'ldap.company.com',
            basedn => 'ou=People,dc=company,dc=net'
        ),
    );

    return $simple->authenticate();
}


1;
