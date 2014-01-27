# == Class: stresstest
#
# Author Name <hugovanduijn@naturalis.nl>
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
