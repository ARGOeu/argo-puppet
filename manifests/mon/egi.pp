class argo::mon::egi {
  include yum::repo::nordugrid

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  file { '/etc/arc/nagios/90-local.ini':
    source  => 'puppet:///modules/argo/mon/egi/90-local.ini',
    require => Package['nordugrid-arc-nagios-plugins-egi'],
  }

  package { ['condor', 'nordugrid-arc-nagios-plugins-egi', 'nagios-plugins-igtf']:
  }

  file { '/var/lib/gridprobes/biomed':
    ensure => directory,
    owner  => 'nagios',
    group  => 'nagios',
  }
}
