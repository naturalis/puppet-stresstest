# == Class: stresstest
#
# Author Name <hugovanduijn@naturalis.nl>
#
class stresstest (
  $cputest         = true,
  $memorytest      = true,
  $disktest        = true,
  $badblocktest    = false,
  $disks           = ['sdb','sdc'],
  $duration        = '360m',
){
  if $cputest {
    $_cputest = " --cpu ${stresstest::processorcount}"
  }

  if $memorytest {
    $amounttotest = $::memorysize_mb * 0.80
    $_memorytest  = " -m 1 --vm-bytes ${stresstest::amounttotest}M"
  }

  if ($_memorytest or $_cputest) {
    $stressoptions = "${_cputest} ${_memorytest} --timeout ${duration}"
    package { 'stress':
      ensure    => present
    }
  }

  if ($disktest) {
    package { 'smartmontools':
      ensure    => present
    }
  }

  file { '/usr/local/sbin/stresstest.sh' :
    content     => template('stresstest/stresstest.sh.erb'),
    mode        => '0700',
  }

  notify{'Start /usr/local/sbin/stresstest.sh to run the stress test':}

}
