class argo::mon::amspublisher (
  $nagioshost = '',
  $publisher_queues_topics = {},
) {
  package {'argo-nagios-ams-publisher':
    ensure => latest,
  }

  file { '/etc/argo-nagios-ams-publisher/ams-publisher.conf':
    content => template('argo/mon/amspublisher/ams-publisher.conf.erb'),
    notify  => Service['ams-publisher.service'],
  }

  service { 'ams-publisher.service': 
    ensure  => 'running',
    enable  => true,
    require => [ Package['argo-nagios-ams-publisher'], File['/etc/argo-nagios-ams-publisher/ams-publisher.conf'] ],
  }
}
