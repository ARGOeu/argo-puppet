class argo::mon::amspublisher (
  $nagioshost              = '',
  $publisher_queues_topics = {},
) {
  package {'argo-nagios-ams-publisher':
    ensure => latest,
  }

  file { '/etc/ams-publisher/ams-publisher-nagios.conf':
    content => template('argo/mon/amspublisher/ams-publisher.conf.erb'),
    notify  => Service['ams-publisher-nagios.service'],
  }

  service { 'ams-publisher-nagios.service':
    ensure  => 'running',
    enable  => true,
    require => [ Package['argo-nagios-ams-publisher'], File['/etc/ams-publisher/ams-publisher-nagios.conf'] ],
  }
}
