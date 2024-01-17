class argo::mon::arc (
  $local_ini='puppet:///modules/argo/mon/egi/90-local.ini',
) {
  include yum::repo::nordugrid

  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { ['nordugrid-arc-nagios-plugins', 'argo-probe-igtf']:
  }

  file { '/etc/arc/nagios/90-local.ini':
    source  => $local_ini,
    require => Package['nordugrid-arc-nagios-plugins'],
  }

  file { '/var/spool/arc/nagios':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0666',
    require => Package['nordugrid-arc-nagios-plugins'],
  }

  file { '/var/spool/argo/probes/argo-probe-igtf':
    ensure  => directory,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0660',
    require => Package['argo-probe-igtf'],
  }
}
