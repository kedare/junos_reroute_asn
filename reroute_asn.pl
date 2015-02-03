#!/bin/env perl

use strict;
use Net::CIDR::Lite;

my $asn = $ARGV[0];
my $groupName = $ARGV[1];
my $nextHop = $ARGV[2];

if (not defined $asn) {
    print "USAGE : $0 <ASN> <GROUP_NAME> <NEXT_HOP>\n";
    print "This scripts will create a junos group that contains static routes to a specific ASN using a designated next-hop\n";
    exit;
}

my $cmd = "/opt/local/bin/whois -h whois.radb.net -i origin AS$asn | grep -Eo '([0-9.]+){4}/[0-9]+'";
my $result = `$cmd`;
my @base_networks = split /\n/, $result;
my @aggregated_networks = Net::CIDR::Lite->new(@base_networks)->list;

foreach my $network (@aggregated_networks) {
    print "set groups $groupName routing-options static route $network next-hop $nextHop\n"; 
}
