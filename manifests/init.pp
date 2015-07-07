# == Class: stresstest
#
# Author Name <hugovanduijn@naturalis.nl>
#
class stresstest (
  $cputest         = true,
  $memorytest      = true,
  $disktest        = true,
  $badblocktest    = false,
  $badblockruntime = 2,
  $disks           = ['sdb','sdc'],
  $duration        = '120m',
  $starthour       = 12,
  $startminute     = 0,
  $startmonth      = 1,
  $startmonthday   = 1,
){
  if $cputest {
    $_cputest = " --cpu ${processorcount}"
  }

  if $memorytest {
    $amounttotest = $memorysize_mb * 0.80
    $_memorytest = " -m 1 --vm-bytes ${amounttotest}M"
  }

  if ($_memorytest or $_cputest) {
    $stressoptions = "${_cputest} ${_memorytest} --timeout ${duration}"
    package { 'stress':
      ensure      => present
    } ->
    file { '/usr/local/sbin/stresstest.sh' :
      content     => template("stresstest/stresstest.sh.erb"),
      mode        => 700,
    } ->
    cron { 'stresstest cpu' :
      command    => "/usr/local/sbin/stresstest.sh",
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour,
      month      => $startmonth,
      monthday   => $startmonthday,
    }
  }

  if ($disktest) {
    package { 'smartmontools':
      ensure     => present
    } ->
    file { '/usr/local/sbin/disktest.sh' :
      content    => template("stresstest/disktest.sh.erb"),
      mode       => 700,
    } ->
    cron { 'stresstest disk' :
      command    => "/usr/local/sbin/disktest.sh",
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour,
      month      => $startmonth,
      monthday   => $startmonthday,
    }
  }


  if $badblocktest {
    file { '/usr/local/sbin/badblocktest.sh' :
      content    => template("stresstest/badblocktest.sh.erb"),
      mode       => 700,
    } ->
    cron { 'badblock test disk' :
      command    => "/usr/local/sbin/badblocktest.sh",
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour,
      month      => $startmonth,
      monthday   => $startmonthday,
    }
  }

  if $badblockruntime > 0 {
    $killat = $starthour + $badblockruntime
    if ($killat > 24) {
      $killat = $killat - 24
      $killatday = $startmonthday+1
    } else {
      $killatday = $startmonthday
    }
    if ($killat > 24) { 
      $killat = 24
    }
    cron { 'badblock kill process' :
      command    => "/usr/bin/killall /sbin/badblocks",
      user       => 'root',
      minute     => $startminute,
      hour       => $starthour + $badblockruntime,
      month      => $startmonth,
      monthday   => $killatday,
    }
  }
}
