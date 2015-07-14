puppet-stresstest
===================

Puppet module for stresstesting hardware
test can be started using /usr/local/sbin/stresstest.sh and logs to /tmp/stresstest.log

Parameters
-------------
All parameters have sensible defaults and can be overwritten in init.pp or Hiera data files

Classes
-------------
- stresstest

Dependencies
-------------
- stress ( installed by module )
- smartmontools ( installed by module )
- hdparm ( default linux )
- badblocks ( default linux )


Limitations
-------------
This module has been built on and tested against Puppet 3.4.2 and higher.

The module has been tested on:
- ubuntu 12.04LTS
- ubuntu 14.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

