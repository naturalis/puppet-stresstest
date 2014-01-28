puppet-stresstest
===================

Puppet module for stresstesting hardware
tests are scheduled and run using the crontab, install mail functionality for reporting the test results. A good combination is using the ssmtp module, the garex/puppet-module-ssmtp is a good example.
the disk tests logs to /tmp, the logs are combined and send to the root user. 

A max runtime for badblock testing is set for 2 hours, the hours are added to the starthour variable and together may not exceed 24 hours as it will result in incorrect cron time parameters.

Parameters
-------------
All parameters have sensible defaults and can be overwritten by foreman or Hiera data files

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
ubuntu 12.04LTS

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

