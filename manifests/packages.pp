# Install packages for several operating systems
class stresstest::packages {
  case $::operatingsystem {
    centos, redhat: {
      singleton_resources(
        Package['stress'],
      )
    }
    debian, ubuntu: {
      singleton_resources(
        Package['stress'],
      )
    }
    default: {
      fail('Unrecognized operating system')
    }
  }
}
