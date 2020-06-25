#!/usr/bin/perl

#babeld-config.pl
#v0.1

use strict;
use lib "/opt/vyatta/share/perl5/";
use Data::Dumper;

#config
my $config_path = "/etc/babeld.conf";
my $init_script = "/etc/init.d/babeld";

my $config_out = '';

use Vyatta::Config;
my $c = new Vyatta::Config();

$c->setLevel('protocols babeld');


open(my $fh, '>', $config_path) || die "Couldn't open $config_path - $!";

$config_out  = "#\n# autogenerated by $0 on " . `date` . "#\n";

if ($c->returnValue("protocol-group") ne "" ) {$config_out .= "protocol-group" . $c->returnValue("protocol-group"); }
if ($c->returnValue("protocol-port") ne "" ) {$config_out .= "protocol-port" . $c->returnValue("protocol-port"); }
if ($c->returnValue("kernel-priority") ne "" ) {$config_out .= "kernel-priority" . $c->returnValue("kernel-priority"); }
if ($c->returnValue("reflect-kernel-metric") ne "" ) {$config_out .= "reflect-kernel-metric" . $c->returnValue("reflect-kernel-metric"); }
if ($c->returnValue("allow-duplicates") ne "" ) {$config_out .= "allow-duplicates" . $c->returnValue("allow-duplicates"); }
if ($c->returnValue("random-id") ne "" ) {$config_out .= "random-id" . $c->returnValue("random-id"); }
if ($c->returnValue("ipv6-subtrees") ne "" ) {$config_out .= "ipv6-subtrees" . $c->returnValue("ipv6-subtrees"); }
if ($c->returnValue("debug") ne "" ) {$config_out .= "debug" . $c->returnValue("debug"); }
if ($c->returnValue("local-port") ne "" ) {$config_out .= "local-port" . $c->returnValue("local-port"); }
if ($c->returnValue("local-port-readwrite") ne "" ) {$config_out .= "local-port-readwrite" . $c->returnValue("local-port-readwrite"); }
if ($c->returnValue("local-path") ne "" ) {$config_out .= "local-path" . $c->returnValue("local-path"); }
if ($c->returnValue("local-path-readwrite") ne "" ) {$config_out .= "local-path-readwrite" . $c->returnValue("local-path-readwrite"); }
if ($c->returnValue("export-table") ne "" ) {$config_out .= "export-table" . $c->returnValue("export-table"); }
if ($c->returnValue("import-table") ne "" ) {$config_out .= "import-table" . $c->returnValue("import-table"); }
if ($c->returnValue("link-detect") ne "" ) {$config_out .= "link-detect" . $c->returnValue("link-detect"); }
if ($c->returnValue("diversity") ne "" ) {$config_out .= "diversity" . $c->returnValue("diversity"); }
if ($c->returnValue("diversity-factor") ne "" ) {$config_out .= "diversity-factor" . $c->returnValue("diversity-factor"); }
if ($c->returnValue("smoothing-half-life") ne "" ) {$config_out .= "smoothing-half-life" . $c->returnValue("smoothing-half-life"); }
if ($c->returnValue("skip-kernel-setup") ne "" ) {$config_out .= "skip-kernel-setup" . $c->returnValue("skip-kernel-setup"); }
if ($c->returnValue("router-id") ne "" ) {$config_out .= "router-id" . $c->returnValue("router-id"); }
if ($c->returnValue("first-table-number") ne "" ) {$config_out .= "first-table-number" . $c->returnValue("first-table-number"); }
if ($c->returnValue("first-rule-priority") ne "" ) {$config_out .= "first-rule-priority" . $c->returnValue("first-rule-priority"); }

my @listen_interfaces  = $c->returnValues('interface');

foreach my $int (@listen_interfaces) {
    $config_out .= "interface $int\n";    
}

my @redistributeIF  = $c->listNodes('redistribute interface');
foreach my $int (@redistributeIF) {
    my $local="";
    my $res=$c->returnValue("redistribute interface $int local");
    
    if ( $res eq "false" ) { 
      $local="";
    } else {
      $local=" local ";
    }
    $config_out .= "redistribute $local if $int\n";
}
if ( $c->returnValue('denydefault') eq "true" ) { $config_out .= "redistribute deny\n"; }
if ( $c->returnValue('denydefaultlocal') eq "true" ) { $config_out .= "redistribute local deny\n"; }


print $fh $config_out;
close $fh;

 my $rc = system("/etc/init.d/babeld restart");