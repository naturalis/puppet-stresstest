# == Class: stresstest
#
# Full description of class stresstest here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { stresstest:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
#
# Author: hugovanduijn@naturalis.nl
#
class stresstest (
  $cputest         = true,
  $memorytest      = true,
  $disktest        = true,
  $disks           = ['sdb','sdc'],
  $duration        = '60m',
  $starthour       = 12,
  $startminute     = 0,
){
  if $cputest {
    $_cputest = " --cpu ${processorcount}"
  }
  if $memorytest {
    $amounttotest = $memorysize_mb * 0.50
    $_memorytest = " -m 1 --vm-bytes ${amounttotest}M"
  }

  if $disktest {
    $postcommand = " && /usr/local/sbin/disktest.sh"
    file { '/usr/local/sbin/disktest.sh' :
      content     => template("stresstest/disktest.sh.erb"),
      mode        => 700,
    }
  }


  if ($_memorytest or $_cputest) {
    package { 'stress':
      ensure     => present
    }
    $stressoptions = "${_cputest} ${_memorytest} --timeout ${duration}"
    cron { 'stresstest' :
      command    => template("stresstest/runstress.sh.erb"),
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour,
      require    => Package['stress']
    }
  }
  if (!$_memorytest or !$_cputest) {
    cron { 'stresstest' :
      command    => "/usr/local/sbin/disktest.sh",
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour,
      require    => File['/usr/local/sbin/disktest.sh'],
    }
  }


}
