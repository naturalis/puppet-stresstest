puppet-stresstest
===================

Puppet module for stresstesting hardware
tests are scheduled and run using the crontab, install mail functionality for reporting the test results. A good combination is using the ssmtp module, the garex/puppet-module-ssmtp is a good example.


Parameters
-------------
All parameters have sensible defaults and can be overwritten by foreman or Hiera data files

Classes
-------------
stresstest
- 

Dependencies
-------------
stress ( installed by module )
hdparm ( default linux )
badblocks ( default linux )
- 

Limitations
-------------
This module has been built on and tested against Puppet ... and higher.

The module has been tested on:
- ubuntu 12.04LTS
- 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

