class argo::mon::sensutools (
  $voname         = '',
  $sensu_url      = '',
  $sensu_token    = '',
  $namespace      = '',
  $webapi_url     = '',
  $webapi_token   = '',
  $metricprofiles = '',
) {
  file { ['/var/nagios', '/var/nagios/rw']:
    ensure => directory,
    owner  => 'sensu',
    group  => 'sensu',
  }

  package { 'argo-sensu-tools':
    ensure => latest,
  }

  file { '/etc/argo-sensu-tools/argo-sensu-tools.conf':
    content => template('argo/mon/sensutools/argo-sensu-tools.conf.erb'),
    require => Package['argo-sensu-tools'],
    notify  => Service['passive2sensu'],
  }

  service { 'passive2sensu':
    ensure => 'running',
    enable => true,
    require => [ Package['argo-sensu-tools'], File['/etc/argo-sensu-tools/argo-sensu-tools.conf'] ],
  }
}
