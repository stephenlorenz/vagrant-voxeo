# Basic Puppet Apache manifest

Exec {
path => [
  '/usr/local/bin',
  '/opt/local/bin',
  '/usr/bin', 
  '/usr/sbin', 
  '/bin',
  '/sbin'],
  logoutput => true
}

class update {
  exec { 'yum update':
    command => 'yum -y update'

  }
}

class enable-ssh {
    package { 'openssh-server':
        ensure => installed,
        notify  => Service['sshd'], 
    }
    service { 'sshd':
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
    }

}

class enable-java {
    package { 'java-1.6.0-openjdk.x86_64':
        ensure => installed,
        notify  => Exec['install prophecy'],
    }
}

class install-prophecy {
  exec { 'download prophecy':
     command => 'wget -P /tmp/ "http://voxeo.com/wp-content/themes/voxeo/inc/prophecy11_download_linux_tts_small.php"',
     creates => '/tmp/prophecy-11.7.69229.0-small-tts-ds-vm.bin',
  }
  file { '/tmp/prophecy-11.7.69229.0-small-tts-ds-vm.bin':
    source  => '/tmp/prophecy-11.7.69229.0-small-tts-ds-vm.bin',
    owner   => 'root',
    group   => 'root',
    mode    => '740',
    notify  => Exec['install prophecy'],
}

  exec { 'install prophecy':
     command => '/tmp/prophecy-11.7.69229.0-small-tts-ds-vm.bin -i silent',
     creates => '/opt/voxeo/prophecy/COPYRIGHT',
     timeout => 0,
  }
}

class install-additional-dependencies {
    $additionalDeps = ["libxml2.x86_64", "libxml2-devel.x86_64", "libxml2-python.x86_64", "libxml2-static.x86_64", "libxml2.i686", "libxml2-devel.i686", "compat-dapl.x86_64", "compat-dapl-devel.x86_64", "compat-dapl-static.x86_64", "compat-dapl-utils.x86_64", "compat-db.x86_64", "compat-db42.x86_64", "compat-db43.x86_64", "compat-expat1.x86_64", "compat-gcc-34.x86_64", "compat-gcc-34-c++.x86_64", "compat-gcc-34-g77.x86_64", "compat-glibc.x86_64", "compat-glibc-headers.x86_64", "compat-libcap1.x86_64", "compat-libf2c-34.x86_64", "compat-libgfortran-41.x86_64", "compat-libstdc++-296.i686", "compat-libstdc++-33.x86_64", "compat-libtermcap.x86_64", "compat-openldap.x86_64", "compat-openmpi.x86_64", "compat-openmpi-devel.x86_64", "compat-openmpi-psm.x86_64", "compat-openmpi-psm-devel.x86_64", "compat-opensm-libs.x86_64", "compat-readline5.x86_64", "compat-readline5-devel.x86_64", "compat-readline5-static.x86_64", "compat-dapl.i686", "compat-dapl-devel.i686", "compat-db.i686", "compat-db42.i686", "compat-db43.i686", "compat-expat1.i686", "compat-libcap1.i686", "compat-libf2c-34.i686", "compat-libgfortran-41.i686", "compat-libstdc++-33.i686", "compat-libtermcap.i686", "compat-openldap.i686", "compat-openmpi.i686", "compat-openmpi-devel.i686", "compat-opensm-libs.i686", "compat-readline5.i686", "compat-readline5-devel.i686", "libcap.i686 ", "libcrypto.so.6", "openssl098e.i686"]
    package { $additionalDeps: ensure => "installed" }
}

include update
include enable-ssh
include enable-java
include install-prophecy
include install-additional-dependencies
